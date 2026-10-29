import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../core/models/health_flag.dart';
import '../../../core/storage/app_prefs.dart';
import '../model/scan_mode.dart';
import '../model/scan_result.dart';
import '../repository/scan_repository.dart';

/// Where the scan flow currently sits (its steps run through one shared
/// view model, like My Day's step machine).
enum ScanPhase {
  /// Capture screens (HTML 7/8) before anything was captured.
  idle,

  /// Capture done — the flag screen (between capture and processing).
  reviewing,

  /// The processing checklist (HTML 9) is running.
  processing,

  /// Analysis finished — the result screen (HTML 10) is ready.
  resultReady,

  /// Analysis failed; the processing screen offers a retry.
  error,
}

/// Session state for one scan, shared by every screen of the flow:
/// capture mode → flags → processing → result.
///
/// App-scope (wired in `app_providers.dart`) because the state must
/// survive navigation between the flow's separate routes; starting a new
/// scan from the scan-mode screen resets it via [startSession].
class ScanViewModel extends ChangeNotifier {
  ScanViewModel(this._repository)
    : selectedFlags = HealthFlag.fromKeys(AppPrefs.healthFlags);

  final ScanRepository _repository;

  /// Steps shown on the processing screen, in order.
  static const int totalSteps = 4;

  /// Gap between two checklist steps completing.
  static const Duration stepDuration = Duration(milliseconds: 700);

  ScanMode mode = ScanMode.barcode;
  Set<HealthFlag> selectedFlags;
  ScanPhase phase = ScanPhase.idle;
  ScanResult? result;

  /// Result of the session being left behind while the user runs a fresh
  /// scan from the result screen; restored when the scanner pops back so
  /// the previous result screen keeps its content instead of a loader.
  ScanResult? previousResult;

  /// Checklist progress: how many steps have completed.
  int completedSteps = 0;

  /// Mock torch/flash state of the camera screens.
  bool torchOn = false;

  /// Photos captured so far in photo mode (two are required).
  int photoCount = 0;

  /// File paths of the photos captured with the real camera (photo mode).
  final List<String> photoPaths = [];

  /// Raw value of the barcode picked up by the live lens (barcode mode).
  String? barcodeValue;

  Timer? _stepTimer;
  int _runId = 0;

  /// Product name shown while the label is being read.
  String get workingName => _repository.workingName;

  /// How many of the user's own flags apply to this result.
  int get conditionFlagged =>
      selectedFlags.where((flag) => !flag.isNone).length;

  /// Photo mode still waiting for its second photo.
  bool get needsSecondPhoto => mode == ScanMode.photo && photoCount < 2;

  /// Called when the scan-mode screen opens or an option is picked:
  /// wipes any previous session and restores the saved flags.
  void startSession(ScanMode initialMode) {
    _stepTimer?.cancel();
    _runId++;
    mode = initialMode;
    selectedFlags = HealthFlag.fromKeys(AppPrefs.healthFlags);
    phase = ScanPhase.idle;
    previousResult = result;
    result = null;
    completedSteps = 0;
    torchOn = false;
    photoCount = 0;
    photoPaths.clear();
    barcodeValue = null;
    notifyListeners();
  }

  /// Barcode screen's "switch to photo mode": keeps the session but
  /// restarts the capture side.
  void switchMode(ScanMode next) {
    if (next == mode) return;
    mode = next;
    photoCount = 0;
    photoPaths.clear();
    barcodeValue = null;
    torchOn = false;
    notifyListeners();
  }

  void toggleTorch() {
    torchOn = !torchOn;
    notifyListeners();
  }

  /// Camera shutter (or a live barcode detection). [photoPath] and
  /// [barcode] carry the real capture when the lens produced one; without
  /// them the capture falls back to the demo session. Returns true when
  /// the capture is complete and the flow should move on to the flag
  /// step; false while photo mode is still collecting its two shots.
  bool capture({String? photoPath, String? barcode}) {
    if (mode == ScanMode.photo && photoCount < 2) {
      photoCount++;
      if (photoPath != null) photoPaths.add(photoPath);
      if (photoCount < 2) {
        notifyListeners();
        return false;
      }
    } else if (mode == ScanMode.barcode && barcode != null) {
      barcodeValue = barcode;
    }
    phase = ScanPhase.reviewing;
    notifyListeners();
    return true;
  }

  void toggleFlag(HealthFlag flag) {
    selectedFlags = HealthFlag.toggle(selectedFlags, flag);
    notifyListeners();
  }

  /// Flag step → processing: remembers the selection on-device, so the
  /// next scan opens pre-filled (the Profile tab edits the same list).
  Future<void> confirmFlags() =>
      AppPrefs.setHealthFlags(HealthFlag.toKeys(selectedFlags));

  /// Drives the processing checklist step by step, then runs the
  /// analysis. Safe to call again (retry, or re-entering the screen).
  void startProcessing() {
    _stepTimer?.cancel();
    final runId = ++_runId;
    completedSteps = 0;
    result = null;
    phase = ScanPhase.processing;
    notifyListeners();

    _stepTimer = Timer.periodic(stepDuration, (timer) {
      if (runId != _runId) {
        timer.cancel();
        return;
      }
      completedSteps++;
      notifyListeners();
      if (completedSteps >= totalSteps) {
        timer.cancel();
        _finish(runId);
      }
    });
  }

  Future<void> _finish(int runId) async {
    try {
      final analysis = await _repository.analyze(
        mode: mode,
        flags: selectedFlags,
      );
      if (runId != _runId) return;
      result = analysis;
      phase = ScanPhase.resultReady;
    } catch (_) {
      if (runId != _runId) return;
      phase = ScanPhase.error;
    }
    notifyListeners();
  }

  /// Puts the stashed result back before the scanner pops away, so going
  /// back from a re-scan lands on the previous result screen.
  void restoreResult() {
    final restored = previousResult;
    previousResult = null;
    if (restored != null) {
      result = restored;
      notifyListeners();
    }
  }

  /// Clears the session once the result is done with (result back → home).
  void endSession() {
    _stepTimer?.cancel();
    _runId++;
    phase = ScanPhase.idle;
    result = null;
    completedSteps = 0;
    torchOn = false;
    photoCount = 0;
    photoPaths.clear();
    barcodeValue = null;
    notifyListeners();
  }
}

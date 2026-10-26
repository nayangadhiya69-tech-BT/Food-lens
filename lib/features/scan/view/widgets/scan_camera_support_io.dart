import 'dart:io' show Platform;

/// Widget tests run without platform plugins; real devices never set this.
bool get isCameraDisabled => Platform.environment.containsKey('FLUTTER_TEST');

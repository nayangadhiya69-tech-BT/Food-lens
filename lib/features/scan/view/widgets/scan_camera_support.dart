/// Decides whether the capture screens may talk to the real camera.
///
/// Live camera plugins (camera, mobile_scanner) report missing platform
/// implementations through uncaught platform-channel errors and unmocked
/// event streams, which would fail widget tests. On the web the plugins
/// have no usable barcode/photo pipeline for this app either. In both
/// cases the capture screens fall back to their demo shutter path.
library;

import 'scan_camera_support_io.dart'
    if (dart.library.html) 'scan_camera_support_web.dart'
    as impl;

/// True when the capture screens must skip live camera initialization.
bool get scanCameraDisabled => impl.isCameraDisabled;

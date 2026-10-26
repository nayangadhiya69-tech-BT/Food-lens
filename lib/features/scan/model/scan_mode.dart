/// How the user chose to capture a product label (HTML screen 6).
enum ScanMode {
  /// Fast path: point the camera at the package barcode.
  barcode,

  /// Fallback for products without a barcode — two label photos
  /// (nutrition panel, then ingredients) per the product spec.
  photo,
}

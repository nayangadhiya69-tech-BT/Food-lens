/// A scanned product entry shown on Home and History.
///
/// This is clearly sample data while the app runs on mock repositories —
/// it is never presented as verified real-world information.
class ScanRecord {
  const ScanRecord({
    required this.id,
    required this.name,
    required this.emoji,
    required this.timestamp,
    required this.flagCount,
  });

  final String id;
  final String name;
  final String emoji;
  final DateTime timestamp;

  /// Number of label flags (0 = "Clear" pill in the design).
  final int flagCount;

  bool get isClear => flagCount == 0;

  factory ScanRecord.fromJson(Map<String, dynamic> json) {
    return ScanRecord(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      emoji: json['emoji'] as String? ?? '🍽️',
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
      flagCount: (json['flag_count'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'emoji': emoji,
        'timestamp': timestamp.toIso8601String(),
        'flag_count': flagCount,
      };
}

class QueueItemModel {
  final String id;
  final String name;
  final bool isCompleted;
  final int? completedAt;
  final int? timestamp;

  QueueItemModel(
      {required this.id,
      required this.name,
      required this.isCompleted,
      this.completedAt,
      this.timestamp});

  factory QueueItemModel.fromMap(Map<String, dynamic> map) {
    return QueueItemModel(
        id: map['id'] as String? ?? '',
        name: map['full_name'] as String? ?? '',
        isCompleted: map['isCompleted'] ?? false,
        timestamp: (map['timestamp'] as int? ?? 0),
        completedAt: map['completedAt'] as int? ?? 0);
  }
}

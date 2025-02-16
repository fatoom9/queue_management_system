class ReportModel {
  final String date;
  final int totalQueueItems;
  final int completedQueueItems;
  final double avgWaitingTime;

  ReportModel({
    required this.date,
    required this.totalQueueItems,
    required this.completedQueueItems,
    required this.avgWaitingTime,
  });

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      date: map['date'] ?? '',
      totalQueueItems: map['totalItems'] ?? 0,
      completedQueueItems: map['completedItems'] ?? 0,
      avgWaitingTime: (map['avgWaitingTime'] ?? 0).toDouble(),
    );
  }
}

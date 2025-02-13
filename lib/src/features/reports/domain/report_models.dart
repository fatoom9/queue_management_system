class ReportModel {
  final int totalQueueItems;
  final int completedQueueItems;
  final double averageWaitingTime;

  ReportModel({
    required this.totalQueueItems,
    required this.completedQueueItems,
    required this.averageWaitingTime,
  });

  ReportModel copyWith({
    int? totalQueueItems,
    int? completedQueueItems,
    double? averageWaitingTime,
  }) {
    return ReportModel(
      totalQueueItems: totalQueueItems ?? this.totalQueueItems,
      completedQueueItems: completedQueueItems ?? this.completedQueueItems,
      averageWaitingTime: averageWaitingTime ?? this.averageWaitingTime,
    );
  }
}

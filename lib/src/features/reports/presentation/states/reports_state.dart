import 'package:queue_management_system/src/features/queue/domain/models/person_details.dart';
import 'package:queue_management_system/src/features/reports/domain/report_models.dart';

class ReportsState {
  final List<PersonDetails> queueData;
  final ReportModel? report;
  final bool isLoading;
  final String? error;
  final bool isEmpty;

  ReportsState({
    this.queueData = const [],
    this.report,
    this.isLoading = false,
    this.error,
    required this.isEmpty,
  });
}

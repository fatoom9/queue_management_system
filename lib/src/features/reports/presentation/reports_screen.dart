import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/constants/app_theme.dart';
import 'package:queue_management_system/src/features/reports/application/reports_services.dart';
import 'package:queue_management_system/src/features/reports/domain/report_models.dart';

final reportsProvider = FutureProvider<List<ReportModel>>((ref) async {
  final service = ref.read(reportsServiceProvider);
  return service.getReports();
});

class ReportsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(reportsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reports Screen',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.theme.primaryColor,
      ),
      body: reportsAsync.when(
        data: (reports) => ListView.builder(
          itemCount: reports.length,
          itemBuilder: (context, index) {
            final report = reports[index];
            return Card(
              child: ListTile(
                title: Text("Date: ${report.date}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total Queue Items: ${report.totalQueueItems}"),
                    Text(
                        "Completed Queue Items: ${report.completedQueueItems}"),
                    Text(
                        "Average Waiting Time: ${report.avgWaitingTime.toStringAsFixed(2)} seconds"),
                  ],
                ),
              ),
            );
          },
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }
}

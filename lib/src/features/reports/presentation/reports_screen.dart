import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/constants/app_theme.dart';
import 'package:queue_management_system/src/features/reports/domain/report_models.dart';
import 'package:queue_management_system/src/features/reports/presentation/controllers/reports_controller_screen.dart';

/// Provider to asynchronously fetch reports
final reportsProvider = FutureProvider<List<ReportModel>>((ref) async {
  final controller = ref.read(reportsControllerProvider.notifier);
  await controller.fetchReports(); // Ensure data is loaded
  return ref.watch(reportsControllerProvider); // Return state
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
        data: (reports) {
          if (reports.isEmpty) {
            return Center(
              child: Text(
                "No reports available.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }
          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return Card(
                elevation: 3,
                margin: EdgeInsets.all(8),
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
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            "Error: $e",
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.refresh(reportsProvider),
        child: Icon(Icons.refresh),
        backgroundColor: AppTheme.theme.primaryColor,
      ),
    );
  }
}

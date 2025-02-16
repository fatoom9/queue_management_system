import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/common_widgets/button.dart'
    as button;
import 'package:queue_management_system/src/common_widgets/text_feild.dart'
    as textField;
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [button.secondaryColor, button.secondaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: reportsAsync.when(
          data: (reports) {
            if (reports.isEmpty) {
              return Center(
                child: Text(
                  "No reports available.",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
            }
            final groupedReports = <String, List<ReportModel>>{};
            for (var report in reports) {
              groupedReports.putIfAbsent(report.date, () => []).add(report);
            }

            return ListView(
              children: groupedReports.entries.map((entry) {
                final date = entry.key;
                final dateReports = entry.value;

                int totalQueueItems = dateReports.fold(
                    0, (sum, item) => sum + item.totalQueueItems);
                int completedQueueItems = dateReports.fold(
                    0, (sum, item) => sum + item.completedQueueItems);
                double avgWaitingTime = completedQueueItems > 0
                    ? dateReports.fold(
                            0.0, (sum, item) => sum + item.avgWaitingTime) /
                        completedQueueItems
                    : 0.0;

                return Card(
                  elevation: 3,
                  margin: EdgeInsets.all(8),
                  child: ExpansionTile(
                    title: Text(
                      "Date: $date",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Total Queue Items: $totalQueueItems"),
                            Text("Completed Queue Items: $completedQueueItems"),
                            Text(
                                "Average Waiting Time: ${avgWaitingTime.toStringAsFixed(2)} seconds"),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
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
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => ref.refresh(reportsProvider),
          child: Icon(Icons.refresh),
          backgroundColor: AppTheme.theme.primaryColor,
          heroTag: TextStyle(color: button.secondaryColor)),
    );
  }
}

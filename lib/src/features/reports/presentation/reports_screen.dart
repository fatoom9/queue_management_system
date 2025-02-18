import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/common_widgets/button.dart'
    as button;
import 'package:queue_management_system/src/constants/app_theme.dart';
import 'package:queue_management_system/src/features/reports/application/reports_services.dart';
import 'package:queue_management_system/src/features/reports/domain/report_models.dart';
import 'package:go_router/go_router.dart';

class ReportsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(reportServicesFutureProvider);
    final primaryColor = AppTheme.theme.primaryColor;
    final secondaryColor = button.secondaryColor;
    final boldTextStyle =
        const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reports Screen',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [secondaryColor, secondaryColor],
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
                  style: boldTextStyle,
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
                  margin: const EdgeInsets.all(8),
                  color: secondaryColor,
                  child: ExpansionTile(
                    title: Text(
                      "Date: $date",
                      style: boldTextStyle,
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
                              "Average Waiting Time: ${avgWaitingTime.toStringAsFixed(2)} seconds",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text(
              "Error: $e",
              style: TextStyle(color: button.accentColor, fontSize: 16),
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "refreshReportsFAB",
            onPressed: () => ref.refresh(reportServicesFutureProvider),
            backgroundColor: primaryColor,
            child: Icon(Icons.refresh, color: secondaryColor),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: "backToHomeFAB",
            onPressed: () {
              context.go('/home');
            },
            backgroundColor: const Color(0xFF335A7B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.home, color: secondaryColor),
          ),
        ],
      ),
    );
  }
}

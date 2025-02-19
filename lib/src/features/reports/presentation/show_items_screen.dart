import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:queue_management_system/src/common_widgets/button.dart';
import 'package:queue_management_system/src/features/reports/application/reports_services.dart';
import 'package:queue_management_system/src/features/reports/domain/queue_item_model.dart';
import 'package:queue_management_system/src/constants/app_theme.dart';

class ShowItemsScreen extends HookConsumerWidget {
  final String date;

  ShowItemsScreen({required this.date});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(itemsDetailsFutureProvider(date));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Items Screen',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: secondaryColor,
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
        child: itemsAsync.when(
          data: (items) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ...items.map((item) {
                    return Card(
                      color: secondaryColor,
                      child: ListTile(
                        title: Text("Name: ${item.name}",
                            style: TextStyle(color: primaryColor)),
                        subtitle: Text('ID: ${item.id}',
                            style: TextStyle(color: primaryColor)),
                        trailing:
                            (item.completedAt != null && item.completedAt! > 0)
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Completed at:",
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        _formatTimeOnly(item.completedAt!),
                                        style: TextStyle(color: primaryColor),
                                      ),
                                    ],
                                  )
                                : const Text("Pending",
                                    style: TextStyle(color: accentColor)),
                      ),
                    );
                  }).toList(),
                  FloatingActionButton(
                    heroTag: "refreshReportsFAB",
                    onPressed: () =>
                        ref.refresh(itemsDetailsFutureProvider(date)),
                    backgroundColor: primaryColor,
                    child: Icon(Icons.refresh, color: secondaryColor),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  String _formatTimeOnly(int timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final timeFormat = DateFormat('HH:mm');
    return timeFormat.format(dateTime);
  }
}

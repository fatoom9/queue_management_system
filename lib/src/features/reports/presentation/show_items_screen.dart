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
              fontSize: 24,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  children: items.map((item) {
                    return Card(
                      color: secondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name: ${item.name}",
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'ID: ${item.id}',
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  "Added at: ",
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  _formatTimeOnly(item.timestamp!),
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            if (item.completedAt != null &&
                                item.completedAt! > 0)
                              Row(
                                children: [
                                  Text(
                                    "Time to Complete: ",
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    _calculateTimeDifference(
                                        item.timestamp!, item.completedAt!),
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  "Status: ",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                item.completedAt != null &&
                                        item.completedAt! > 0
                                    ? Text(
                                        "Completed at ${_formatTimeOnly(item.completedAt!)}",
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 16,
                                        ),
                                      )
                                    : const Text(
                                        "Pending",
                                        style: TextStyle(
                                          color: accentColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
        ));
  }

  String _formatTimeOnly(int timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final timeFormat = DateFormat('HH:mm');
    return timeFormat.format(dateTime);
  }

  String _calculateTimeDifference(int startTimestamp, int endTimestamp) {
    final duration = Duration(milliseconds: endTimestamp - startTimestamp);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '$hours hrs $minutes mins';
    } else if (minutes > 0) {
      return '$minutes mins';
    } else {
      return '$seconds sec';
    }
  }
}

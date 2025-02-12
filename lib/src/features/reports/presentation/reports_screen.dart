import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/features/reports/presentation/controllers/reports_controller_screen.dart';

class ReportsScreen extends HookConsumerWidget {
  const ReportsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(reportsControllerProvider);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reports',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0288D1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (report.queueData.isEmpty)
              const Text('No queue data available')
            else
              ListView.builder(
                shrinkWrap: true,
                itemCount: report.queueData.length,
                itemBuilder: (context, index) {
                  final queueItem = report.queueData[index];
                  return ListTile(
                    title: Text(queueItem.fullName),
                    subtitle: Text('Queue number: ${queueItem.queueNumber}'),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

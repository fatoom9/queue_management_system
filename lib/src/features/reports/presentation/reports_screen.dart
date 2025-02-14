import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/common_widgets/button.dart';
import 'package:queue_management_system/src/constants/app_theme.dart';
import 'package:queue_management_system/src/features/reports/presentation/controllers/reports_controller_screen.dart';

class ReportsScreen extends HookConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsState = ref.watch(reportsControllerProvider);
    final queueData = reportsState.queueData;

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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [secondaryColor, secondaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: reportsState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : reportsState.isEmpty
                ? const Center(child: Text("No one in the queue"))
                : Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        "Total in Queue: ${queueData.length}",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: queueData.length,
                          itemBuilder: (context, index) {
                            final person = queueData[index];
                            return ListTile(
                              title: Text(person['full_name']),
                              subtitle: Text(
                                  "Queue Number: ${person['queue_number']}"),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

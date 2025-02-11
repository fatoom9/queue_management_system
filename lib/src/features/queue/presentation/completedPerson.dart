import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/features/queue/presentation/add_person_screen.dart';
import 'package:queue_management_system/src/features/queue/presentation/controllers/queue_controller.dart';
import 'package:queue_management_system/src/features/queue/presentation/home_screen.dart';
import 'package:queue_management_system/src/features/queue/presentation/person_details_screen.dart';

class Completedperson extends HookConsumerWidget {
  const Completedperson({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    //throw UnimplementedError();
    final queueList = ref
        .watch(queueControllerProvider)
        .where(
            (person) => person.completedAt != null && person.completedAt! > 0)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Completed Person',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0288D1),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB3E5FC), Color(0xFFE1F5FE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 18),
            queueList.isEmpty
                ? const Center(child: Text("No one in the queue"))
                : ListView.builder(
                    itemCount: queueList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final currentPerson = queueList[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                        child: ListTile(
                          title: Text(
                            currentPerson.fullName,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(currentPerson.phoneNumber),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (currentPerson.completedAt != null &&
                                  currentPerson.completedAt! > 0)
                                Text('')
                              /*const Icon(Icons.check_circle,
                                    color: Colors.green)
                                    */
                              else
                                // Text(''),
                                Text("#${currentPerson.queueNumber}"),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Color(0xFFBB594F)),
                                onPressed: () async {
                                  bool confirmDelete = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Confirm Delete"),
                                        content: const Text("Are you sure ?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false), // Cancel
                                            child: const Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(true), // Confirm
                                            child: const Text("Delete",
                                                style: TextStyle(
                                                    color: Colors.red)),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (confirmDelete == true) {
                                    await ref
                                        .read(queueControllerProvider.notifier)
                                        .removePersonFromQueue(
                                            currentPerson.id);
                                    await ref
                                        .read(queueControllerProvider.notifier)
                                        .updateQueueNumber();
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.add,
                                    color: Color(0xFF335a7b)),
                                onPressed: () async {
                                  // Step 1: Remove person from completedPerson screen
                                  await ref
                                      .read(queueControllerProvider.notifier)
                                      .removeFromCompletedList(
                                          currentPerson.id);

                                  // Step 2: Re-add them to the home screen
                                  await ref
                                      .read(queueControllerProvider.notifier)
                                      .addPersonToQueue(
                                          currentPerson.fullName,
                                          currentPerson.phoneNumber,
                                          currentPerson.notes ?? '');

                                  // Step 3: Update the queue numbers after modification
                                  await ref
                                      .read(queueControllerProvider.notifier)
                                      .updateQueueNumber();
                                  //Fref.invalidate(queueControllerProvider);
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  currentPerson.completedAt != null &&
                                          currentPerson.completedAt! > 0
                                      ? Icons.check_circle
                                      : Icons.check_circle_outline,
                                  color: currentPerson.completedAt != null &&
                                          currentPerson.completedAt! > 0
                                      ? Colors.green
                                      : Color(0xFF335A7B),
                                ),
                                onPressed: () async {
                                  if (currentPerson.completedAt == null ||
                                      currentPerson.completedAt == 0) {
                                    await ref
                                        .read(queueControllerProvider.notifier)
                                        .markAsCompleted(currentPerson.id);
                                  }
                                },
                              ),
                            ],
                          ),
                          leading: const Icon(Icons.person,
                              color: Color(0xFF0288D1)),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PersonDetailsScreen(person: currentPerson),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 16),
          const Spacer(),
          FloatingActionButton(
            heroTag: "addPersonFAB",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            },
            backgroundColor: const Color(0xFF335A7B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.undo, color: Colors.white),
          ),
          const SizedBox(width: 45),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}

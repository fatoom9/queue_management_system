import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/features/queue/data/repositories/queue_repository.dart';
import 'package:queue_management_system/src/features/queue/domain/models/person_details.dart';
import 'package:queue_management_system/src/features/queue/presentation/add_person_screen.dart';
import 'package:queue_management_system/src/features/queue/presentation/completedPerson.dart';
import 'package:queue_management_system/src/features/queue/presentation/controllers/queue_controller.dart';
import 'package:queue_management_system/src/features/queue/presentation/person_details_screen.dart';
import 'package:queue_management_system/src/features/auth/presentation/controllers/auth_controller.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueList = ref
        .watch(queueControllerProvider)
        .where(
            (person) => person.completedAt == null || person.completedAt == 0)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Queue Management',
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
            Image.asset(
              'assets/logo/logo.png',
              width: MediaQuery.of(context).size.width,
              height: 150,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 10),
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
                              else
                                Text("#${currentPerson.queueNumber}"),
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

                                    Future.delayed(Duration.zero, () {
                                      context.go('/completedPerson');
                                    });
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end, // Corrected here
        children: [
          FloatingActionButton(
            heroTag: "anotherFAB",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Completedperson(),
                ),
              );
            },
            backgroundColor: Color(0xFF335A7B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.check_circle, color: Colors.green),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "logoutFAB",
            onPressed: () {
              ref.read(authControllerProvider.notifier).signOut();
              context.go('/login');
            },
            backgroundColor: const Color(0xFF335A7B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.exit_to_app, color: Colors.white),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "addPersonFAB",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddPersonScreen(),
                ),
              );
            },
            backgroundColor: const Color(0xFF335A7B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

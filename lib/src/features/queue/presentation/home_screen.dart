import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/features/queue/data/repositories/queue_repository.dart';
import 'package:queue_management_system/src/features/queue/domain/models/person_details.dart';
import 'package:queue_management_system/src/features/queue/presentation/add_person_screen.dart';
import 'package:queue_management_system/src/features/queue/presentation/person_details_screen';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueRepo = ref.watch(queueRepositoryProvider);
    final fullNameController = useTextEditingController();
    final phoneController = useTextEditingController();
    final notesController = useTextEditingController();
    final person = useState<List<PersonDetails>>([]);

    useEffect(() {
      Future<void> loadQueue() async {
        person.value = await queueRepo.getQueue();
      }

      loadQueue();
      return null;
    }, []);

    void addPerson() async {
      if (fullNameController.text.isEmpty || phoneController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Full Name and Phone Number cannot be empty.')),
        );
        return;
      }
      final newPerson = PersonDetails(
        fullName: fullNameController.text,
        phoneNumber: phoneController.text,
        queueNumber: person.value.length + 1,
        timestampAdded: DateTime.now().millisecondsSinceEpoch,
        notes: notesController.text.isNotEmpty ? notesController.text : null,
        timestamp: DateTime.now().toString(),
      );
      await queueRepo.insertQueue(newPerson);
      person.value = await queueRepo.getQueue();
      fullNameController.clear();
      phoneController.clear();
      notesController.clear();
    }

    void removePerson(int id) async {
      await queueRepo.removeFromQueue(id);
      person.value = await queueRepo.getQueue();
    }

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
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: person.value.length,
                itemBuilder: (context, index) {
                  final currentPerson = person.value[index];
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
                          Text("#${currentPerson.queueNumber}"),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => removePerson(currentPerson.id!),
                          ),
                        ],
                      ),
                      leading:
                          const Icon(Icons.person, color: Color(0xFF0288D1)),
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
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Aligns one left, one right
        children: [
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: "logoutFAB",
            onPressed: () {
              context.go('/welcome');
            },
            backgroundColor: const Color(0xFF0288D1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.exit_to_app, color: Colors.white),
          ),
          const Spacer(),
          FloatingActionButton(
            heroTag: "addPersonFAB",
            onPressed: () async {
              final newPerson = await Navigator.push<PersonDetails>(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPersonScreen(
                    id: person.value.length + 1,
                  ),
                ),
              );
              if (newPerson != null) {
                person.value = List.from(person.value)..add(newPerson);
              }
            },
            backgroundColor: const Color(0xFF0288D1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.add, color: Colors.white),
          ),
          const SizedBox(width: 45),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}

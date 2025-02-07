import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/features/queue/application/queue_services';
import 'package:queue_management_system/src/features/queue/data/repositories/queue_repository.dart';
import 'package:queue_management_system/src/features/queue/domain/models/person_details.dart';
import 'package:queue_management_system/src/features/queue/presentation/add_person_screen.dart';
import 'package:queue_management_system/src/features/queue/presentation/person_details_screen.dart';
import '../../../router/router.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueRepo = ref.watch(queueRepoProvider);
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
      String fullName = fullNameController.text.trim();
      String phoneNumber = phoneController.text.trim();
      String notes = notesController.text.trim();

      if (fullName.isEmpty || phoneNumber.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Full Name and Phone Number cannot be empty.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final currentQueue = await queueRepo.getQueue();
      final nextQueueNumber =
          currentQueue.isEmpty ? 1 : currentQueue.length + 1;

      final newPerson = PersonDetails(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fullName: fullName,
        phoneNumber: phoneNumber,
        queueNumber: nextQueueNumber,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        addedBy: ,
        notes: notes.isNotEmpty ? notes : null,
      );

      try {
        await queueRepo.insertQueue(newPerson);
        person.value = await queueRepo.getQueue();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Person added successfully!')),
        );

        fullNameController.clear();
        phoneController.clear();
        notesController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add person: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    void updateQueueNumber() async {
      final currentQueue = await queueRepo.getQueue();
      for (int i = 0; i < currentQueue.length; i++) {
        final newPerson = PersonDetails(
          id: currentQueue[i].id,
          fullName: currentQueue[i].fullName,
          phoneNumber: currentQueue[i].phoneNumber,
          queueNumber: i + 1,
          timestamp: currentQueue[i].timestamp,
          notes: currentQueue[i].notes,
        );
        await queueRepo.updatePersonDetails(newPerson);
      }
      person.value = await queueRepo.getQueue();
    }

    void removePerson(String id) async {
      try {
        await queueRepo.removeFromQueue(id);
        person.value = await queueRepo.getQueue();
        updateQueueNumber();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove person: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    //update id after remove person

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
                            onPressed: () => removePerson(currentPerson.id),
                            //person.value = updateQueueNumber(),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: "logoutFAB",
            onPressed: () {
              ref.read(isLoggedInProvider.notifier).state = false;
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
                    queueNumber: person.value.length + 1,
                  ),
                ),
              );
              if (newPerson != null) {
                await queueRepo.insertQueue(newPerson);
                person.value = await queueRepo.getQueue();
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

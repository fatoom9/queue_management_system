import 'package:flutter/material.dart';
import 'package:queue_management_system/src/features/queue/domain/models/person_details.dart';

class AddPersonScreen extends StatelessWidget {
  final int id;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  AddPersonScreen({required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Person'),
        backgroundColor: const Color(0xFF0288D1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newPerson = PersonDetails(
                  id: id,
                  fullName: nameController.text,
                  phoneNumber: phoneController.text,
                  queueNumber: id,
                  timestampAdded: DateTime.now().millisecondsSinceEpoch,
                  notes: notesController.text.isNotEmpty
                      ? notesController.text
                      : null,
                  timestamp: DateTime.now().toString(),
                );

                Navigator.pop(
                    context, newPerson); // Return new person data to HomeScreen
              },
              child: const Text('Add Person'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0288D1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:queue_management_system/src/features/queue/domain/models/person_details.dart';

class AddPersonScreen extends StatelessWidget {
  final int queueNumber; // Use queueNumber instead of id
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  AddPersonScreen({required this.queueNumber, required int id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Person'),
        backgroundColor: const Color(0xFF0288D1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Full Name cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone Number cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Validate inputs
                  if (nameController.text.isEmpty ||
                      phoneController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Full Name and Phone Number cannot be empty.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  // Create a new PersonDetails object
                  final newPerson = PersonDetails(
                    id: DateTime.now()
                        .millisecondsSinceEpoch
                        .toString(), // Unique ID
                    fullName: nameController.text,
                    phoneNumber: phoneController.text,
                    queueNumber: queueNumber,
                    timestamp: DateTime.now().millisecondsSinceEpoch,
                    notes: notesController.text.isNotEmpty
                        ? notesController.text
                        : null,
                  );

                  // Return the new person data to the HomeScreen
                  Navigator.pop(context, newPerson);
                },
                child: const Text('Add Person'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0288D1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:queue_management_system/src/features/queue/presentation/controllers/queue_controller.dart';

class AddPersonScreen extends ConsumerStatefulWidget {
  const AddPersonScreen({Key? key}) : super(key: key);

  @override
  _AddPersonScreenState createState() => _AddPersonScreenState();
}

class _AddPersonScreenState extends ConsumerState<AddPersonScreen> {
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Person to Queue')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _fullNameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes (optional)'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      setState(() => _isLoading = true);
                      await ref
                          .read(queueControllerProvider.notifier)
                          .addPersonToQueue(
                            _fullNameController.text,
                            _phoneController.text,
                            _notesController.text,
                          );
                      setState(() => _isLoading = false);
                      Navigator.pop(context);
                    },
                    child: const Text('Add to Queue'),
                  ),
          ],
        ),
      ),
    );
  }
}

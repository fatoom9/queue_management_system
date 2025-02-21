import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:queue_management_system/src/common_widgets/button.dart';
import 'package:queue_management_system/src/constants/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:queue_management_system/src/features/queue/presentation/controllers/queue_controller.dart';

class AddPersonScreen extends ConsumerStatefulWidget {
  const AddPersonScreen({Key? key}) : super(key: key);

  @override
  _AddPersonScreenState createState() => _AddPersonScreenState();
}

class _AddPersonScreenState extends ConsumerState<AddPersonScreen> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final _idController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Person',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Container(
        color: secondaryColor, // Setting background color
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _idController,
                  decoration: const InputDecoration(
                    hintText: 'ID',
                    labelText: 'ID',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter ID';
                    }
                    if (!RegExp(r'^\d{9}$').hasMatch(value)) {
                      return 'ID must be 9 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(
                    hintText: 'Name',
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    hintText: 'Phone Number',
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                      return 'Phone number must be 10 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    hintText: 'Notes',
                    labelText: 'Notes (Optional)',
                    prefixIcon: Icon(Icons.note),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : Btn(
                        onPress: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _isLoading = true);
                            await ref
                                .read(queueControllerProvider.notifier)
                                .addPersonToQueue(
                                  _idController.text,
                                  _fullNameController.text,
                                  _phoneController.text,
                                  _notesController.text,
                                );
                            setState(() => _isLoading = false);
                          }
                        },
                        text: 'Add to Queue',
                      ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "backToHomeFAB",
        onPressed: () {
          context.goNamed('home');
        },
        backgroundColor: const Color(0xFF335A7B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.home, color: Colors.white),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/common_widgets/button.dart';
import 'package:queue_management_system/src/common_widgets/text_feild.dart';
import 'package:queue_management_system/src/constants/app_theme.dart';
import 'package:queue_management_system/src/features/queue/presentation/controllers/queue_controller.dart';

const Color primaryColor = Color(0xFF335A7B);
const Color secondaryColor = Color(0xFFf1f2ed);
const Color accentColor = Color(0xFFAD534A);

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
          'Add Person Screen',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: secondaryColor),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.theme.primaryColor,
      ),
      body: Container(
        color: secondaryColor, // Setting background color
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextFormField(
                  controller: _idController,
                  hintText: 'ID',
                  helpText: 'Please enter 9-digit ID',
                  obscureText: false,
                  icon: Icons.lock,
                  keyboardType: TextInputType.number,
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
                AppTextFormField(
                  controller: _fullNameController,
                  hintText: 'Full Name',
                  helpText: 'Please enter your full name',
                  obscureText: false,
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                AppTextFormField(
                  controller: _phoneController,
                  hintText: 'Phone Number',
                  helpText: 'Please enter a 10-digit phone number',
                  obscureText: false,
                  icon: Icons.phone,
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
                AppTextFormField(
                  controller: _notesController,
                  hintText: 'Notes (Optional)',
                  helpText: 'Optional notes about the person',
                  obscureText: false,
                  icon: Icons.note,
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
        child: const Icon(Icons.home, color: secondaryColor),
      ),
    );
  }
}

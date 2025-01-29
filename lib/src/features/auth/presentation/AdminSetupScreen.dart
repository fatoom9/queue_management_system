import 'package:flutter/material.dart';
import 'package:queue_management_system/src/features/auth/data/auth_repository.dart';
import 'package:queue_management_system/src/features/auth/domain/models/admin.dart';

class AdminSetupScreen extends StatefulWidget {
  const AdminSetupScreen({super.key});

  @override
  _AdminSetupScreenState createState() => _AdminSetupScreenState();
}

class _AdminSetupScreenState extends State<AdminSetupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthRepository _authRepo = AuthRepository(); // Initialize AuthRepository
  List<Admin> _admins = []; // To store the list of admins

  @override
  void initState() {
    super.initState();
    _authRepo.init();
    _loadAdmins();
  }

  // Load the list of admins from the database
  void _loadAdmins() async {
    final admins = await _authRepo.getAdmins();
    print("Loaded admins: $admins"); // Print loaded admins to debug

    setState(() {
      _admins = admins;
    });
  }

  void _createAdmin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email and password cannot be empty.')),
      );
      return;
    }

    final admin = Admin(
      id: DateTime.now().toString(), // Unique ID for the admin
      email: _emailController.text,
      password: _passwordController.text,
    );

    await _authRepo.insertAdmin(admin);

    // Reload the list of admins
    _loadAdmins();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Admin created successfully!')),
    );

    // Navigate back to the welcome screen or any other screen you want
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Admin'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Email input field
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            // Password input field
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            // Create Admin button
            ElevatedButton(
              onPressed: _createAdmin,
              child: const Text('Create Admin'),
            ),
            const SizedBox(height: 20),
            // Display the list of admins
            Text('Existing Admins:'),
            Expanded(
              child: ListView.builder(
                itemCount: _admins.length,
                itemBuilder: (context, index) {
                  final admin = _admins[index];
                  return ListTile(
                    title: Text(admin.email),
                    subtitle: Text(admin.id),
                    // ignore: avoid_print
                    //print(admin.password),
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

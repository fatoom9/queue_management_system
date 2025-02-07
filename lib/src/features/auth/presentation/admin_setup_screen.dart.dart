import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/features/auth/presentation/controllers/auth_controller.dart';

class AdminSetupScreen extends HookConsumerWidget {
  const AdminSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isLoading = useState(false);

    // Get auth controller
    final auth = ref.read(authControllerProvider.notifier);

    void createAdmin() async {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email and password cannot be empty.')),
        );
        return;
      }

      isLoading.value = true;
      await auth.createAdmin(emailController.text, passwordController.text);
      isLoading.value = false;

      // Clear the form
      emailController.clear();
      passwordController.clear();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Admin created successfully!')),
        );
        context.go('/welcome');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Admin',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0288D1),
      ),
      body: Stack(
        children: [
          Container(
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
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                      TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: isLoading.value ? null : createAdmin,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: isLoading.value
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text('Create Admin'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          context.go('/admin-list');
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text('View Admin List'),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          context.go('/welcome');
                        },
                        child: const Text('Back'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isLoading.value)
            Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

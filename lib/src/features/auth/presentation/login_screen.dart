import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/features/auth/data/auth_repository.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepo = ref.watch(authRepositoryProvider);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isLoading = useState(false);

    void login() async {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter both email and password')),
        );
        return;
      }

      FocusScope.of(context).unfocus();
      isLoading.value = true;

      final isValid = await authRepo.validateCredentials(
        emailController.text,
        passwordController.text,
      );

      isLoading.value = false;

      if (isValid) {
        context.go('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
              onPressed: isLoading.value ? null : login,
              child: isLoading.value
                  ? const CircularProgressIndicator()
                  : const Text('Login'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                context.go('/welcome');
              },
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}

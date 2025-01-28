import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
//import 'package:queue_management_system/src/features/auth/domain/auth_provider.dart';

class LoginScreen extends ConsumerWidget {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController(); 

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                final email = emailController.text;
                final password = passwordController.text;
                
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
 
   

  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widget/admin_list.dart';

class AdminListScreen extends StatelessWidget {
  const AdminListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Management',
<<<<<<< HEAD
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
=======
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
>>>>>>> f1c3e69bb1b2b2f04952dd658d679c6ffeaaba94
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 18),
            Center(
              child: Image.asset(
                'assets/logo/logo.png',
                width: MediaQuery.of(context).size.width * 0.6,
                height: 120,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Existing Admins:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: const AdminList(),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                context.go('/welcome');
              },
              child: const Text('Back'),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}

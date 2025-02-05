import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/features/auth/data/auth_repository.dart';
import 'package:queue_management_system/src/features/auth/domain/models/admin.dart';

class AdminSetupScreen extends HookConsumerWidget {
  const AdminSetupScreen({super.key, required Null Function() onSetupComplete});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepo = ref.watch(authRepositoryProvider);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final admins = useState<List<Admin>>([]);

    useEffect(() {
      Future<void> loadAdmins() async {
        admins.value = await authRepo.getAdmins();
      }

      loadAdmins();
      return null;
    }, []);

    void createAdmin() async {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email and password cannot be empty.')),
        );
        return;
      }

      final admin = Admin(
        id: DateTime.now().toString(),
        email: emailController.text,
        password: passwordController.text,
      );

      await authRepo.insertAdmin(admin);

      admins.value = await authRepo.getAdmins(); // update the list of admins
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Admin created successfully!')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Creat Admin',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
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
                    onPressed: createAdmin,
                    child: const Text('Create Admin'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.go('/admin-list'); // Navigate to admin list
                    },
                    child: const Text('View Admin List'),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      context.go('/welcome'); // Navigate back to welcome screen
                    },
                    child: const Text('Back'),
                  ),
                  const SizedBox(height: 10),
                  /* const Text('Existing Admins:'),
                  Expanded(
                    child: ListView.builder(
                      itemCount: admins.value.length,
                      itemBuilder: (context, index) {
                        final admin = admins.value[index];
                        return ListTile(
                          title: Text(admin.email),
                          subtitle: Text(admin.id),
                        );
                      },
                    ),
                  ),
                  */
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

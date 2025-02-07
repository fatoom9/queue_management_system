import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:queue_management_system/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:queue_management_system/src/features/auth/application/auth_service.dart';

class AdminList extends HookConsumerWidget {
  const AdminList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authControllerProvider.notifier);
    final admins = ref.watch(authServiceProvider).getAllAdmins();

    return FutureBuilder(
      future: admins,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final adminList = snapshot.data ?? [];
        if (adminList.isEmpty) {
          return const Center(child: Text('No admins found'));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          itemCount: adminList.length,
          itemBuilder: (context, index) {
            final admin = adminList[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 3,
              child: ListTile(
                title: Text(
                  admin.email,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text("ID: ${admin.id}"),
                leading: const Icon(Icons.admin_panel_settings, color: Color(0xFF0288D1)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await auth.deleteAdmin(admin.id);
                    // Refresh the list by rebuilding the widget
                    ref.refresh(authServiceProvider);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

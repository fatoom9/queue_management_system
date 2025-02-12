import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:queue_management_system/src/common_widgets/button.dart';
import 'package:queue_management_system/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:queue_management_system/src/features/auth/application/auth_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
          );
        }
        final adminList = snapshot.data ?? [];
        if (adminList.isEmpty) {
          return Center(
            child: Text(
              'No admins found',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: adminList.length,
          itemBuilder: (context, index) {
            final admin = adminList[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: ListTile(
                title: Text(
                  admin.email,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                subtitle: Text(
                  "ID: ${admin.id}",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                leading: const FaIcon(
                  FontAwesomeIcons.userShield, //
                  color: primaryColor,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: accentColor),
                  onPressed: () async {
                    await auth.deleteAdmin(admin.id);
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

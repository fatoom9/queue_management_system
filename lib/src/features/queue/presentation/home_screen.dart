import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/common_widgets/button.dart';
import 'package:queue_management_system/src/constants/app_theme.dart';
import 'package:queue_management_system/src/features/queue/presentation/controllers/queue_controller.dart';
import 'package:queue_management_system/src/features/queue/presentation/person_details_screen.dart';
import 'package:queue_management_system/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueList = ref
        .watch(queueControllerProvider)
        .where(
            (person) => person.completedAt == null || person.completedAt == 0)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Queue List',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: secondaryColor),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.theme.primaryColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [secondaryColor, secondaryColor],
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
            queueList.isEmpty
                ? const Center(child: Text("No one in the queue"))
                : Expanded(
                    child: ListView.builder(
                      itemCount: queueList.length,
                      itemBuilder: (context, index) {
                        final currentPerson = queueList[index];
                        return Card(
                          color: secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                          child: ListTile(
                            title: Text(
                              currentPerson.fullName,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.theme.primaryColor,
                              ),
                            ),
                            subtitle: Text(currentPerson.phoneNumber),
                            trailing: IconButton(
                              icon: Icon(
                                currentPerson.completedAt != null &&
                                        currentPerson.completedAt! > 0
                                    ? Icons.check_circle
                                    : Icons.check_circle_outline,
                                color: currentPerson.completedAt != null &&
                                        currentPerson.completedAt! > 0
                                    ? Colors.green
                                    : AppTheme.theme.primaryColor,
                              ),
                              onPressed: () async {
                                if (currentPerson.completedAt == null ||
                                    currentPerson.completedAt == 0) {
                                  await ref
                                      .read(queueControllerProvider.notifier)
                                      .markAsCompleted(currentPerson.id);

                                  Future.delayed(Duration.zero, () {
                                    context.goNamed('completedPerson');
                                  });
                                }
                              },
                            ),
                            leading: const FaIcon(
                              FontAwesomeIcons.user,
                              color: primaryColor,
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PersonDetailsScreen(person: currentPerson),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppTheme.theme.primaryColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.outdent,
                    color: secondaryColor),
                onPressed: () {
                  ref.read(authControllerProvider.notifier).signOut();
                  context.goNamed('login');
                },
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.chartColumn,
                    color: secondaryColor),
                onPressed: () {
                  context.goNamed('reports');
                },
              ),
              IconButton(
                icon: const Icon(Icons.check_circle, color: secondaryColor),
                onPressed: () {
                  context.goNamed('completedPerson');
                },
              ),
              IconButton(
                icon: const Icon(Icons.add, color: secondaryColor),
                onPressed: () {
                  context.goNamed('addPersonScreen');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

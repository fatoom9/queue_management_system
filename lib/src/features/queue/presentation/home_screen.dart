import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/common_widgets/button.dart';
import 'package:queue_management_system/src/constants/app_theme.dart';
import 'package:queue_management_system/src/features/queue/presentation/add_person_screen.dart';
import 'package:queue_management_system/src/features/queue/presentation/completedPerson.dart';
import 'package:queue_management_system/src/features/queue/presentation/controllers/queue_controller.dart';
import 'package:queue_management_system/src/features/queue/presentation/person_details_screen.dart';
import 'package:queue_management_system/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:queue_management_system/src/features/reports/application/reports_services.dart';
import 'package:queue_management_system/src/features/reports/presentation/reports_screen.dart';
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
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
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
                : ListView.builder(
                    itemCount: queueList.length,
                    shrinkWrap: true,
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
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (currentPerson.completedAt != null &&
                                  currentPerson.completedAt! > 0)
                                Text('')
                              else
                                Text("#${currentPerson.queueNumber}"),
                              IconButton(
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
                                      context.go('/completedPerson');
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                          leading: const FaIcon(
                            FontAwesomeIcons.person, //
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
          ],
        ),
      ),
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: FloatingActionButton(
              heroTag: "logoutFAB",
              onPressed: () {
                ref.read(authControllerProvider.notifier).signOut();
                context.go('/login');
              },
              backgroundColor: AppTheme.theme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: const FaIcon(
                FontAwesomeIcons.outdent, //
                color: secondaryColor,
              ),
              //child: const Icon(Icons.exit_to_app, color: Colors.white),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 40.0),
                child: FloatingActionButton(
                  heroTag: "reportFAB",
                  onPressed: () {
                    //ref.refresh(reportServicesFutureProvider);

                    context.goNamed('reports');
                  },
                  backgroundColor: AppTheme.theme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const FaIcon(
                    FontAwesomeIcons.chartColumn, //
                    color: secondaryColor,
                  ),
                  // child: const Icon(Icons.bar_chart, color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(right: 40.0),
                child: FloatingActionButton(
                  heroTag: "completedPersonFAB",
                  onPressed: () {
                    context.go('/completedPerson');
                  },
                  backgroundColor: AppTheme.theme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.check_circle, color: Colors.green),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(right: 40.0),
                child: FloatingActionButton(
                  heroTag: "addPersonFAB",
                  onPressed: () {
                    context.go('/addPersonScreen');
                  },
                  backgroundColor: AppTheme.theme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}

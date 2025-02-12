import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/common_widgets/button.dart';
import 'package:queue_management_system/src/constants/app_theme.dart';
import 'package:queue_management_system/src/features/queue/domain/models/person_details.dart';
import 'package:queue_management_system/src/features/queue/presentation/controllers/queue_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonDetailsScreen extends HookConsumerWidget {
  final PersonDetails person;

  const PersonDetailsScreen({super.key, required this.person});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          person.fullName,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppTheme.theme.scaffoldBackgroundColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.theme.primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [secondaryColor, secondaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(Icons.person, 'Full Name', person.fullName),
                  _buildDetailRow(Icons.timelapse, 'ID', person.id.toString()),
                  _buildDetailRow(
                      Icons.phone, 'Phone Number', person.phoneNumber),
                  if (!(person.completedAt != null && person.completedAt! > 0))
                    _buildDetailRow(Icons.confirmation_number, 'Queue Number',
                        '#${person.queueNumber}'),
                  _buildDetailRow(Icons.access_time, 'Added At',
                      _formatTimestamp(person.timestamp)),
                  _buildDetailRow(
                      Icons.add, 'Added by', person.addedBy.toString()),
                  if (person.notes?.isNotEmpty == true)
                    _buildDetailRow(Icons.note, 'Notes', person.notes!),
                  if (person.completedAt != null && person.completedAt! > 0)
                    _buildDetailRow(
                      Icons.person,
                      'Completed At',
                      _formatTimestamp(person.completedAt),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.theme.primaryColor), // Using primary color
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$title: $value',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.theme.primaryColor, // Using primary color
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(int? timestamp) {
    if (timestamp == null) return "N/A";
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }
}

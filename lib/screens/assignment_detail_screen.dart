// lib/screens/assignment_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/assignment_model.dart';
import '../utils/theme.dart';
import 'submit_assignment_screen.dart';
import 'package:intl/intl.dart';

class AssignmentDetailScreen extends StatelessWidget {
  final Assignment assignment;
  final Function(String) onSubmission;

  const AssignmentDetailScreen({
    super.key,
    required this.assignment,
    required this.onSubmission,
  });

  @override
  Widget build(BuildContext context) {
    final subjectColor = _getSubjectColor(assignment.subject);
    final isSubmitted =
        assignment.status == 'submitted' || assignment.status == 'graded';

    return Scaffold(
      appBar: AppBar(
        title: Text(assignment.title),
        backgroundColor: subjectColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [subjectColor.withOpacity(0.05), AppColors.background],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subject and due date
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: subjectColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      assignment.subject,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Due ${DateFormat('MMM d, y').format(assignment.dueDate)}',
                    style: TextStyle(
                      color:
                          assignment.isOverdue
                              ? AppColors.error
                              : AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                assignment.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),

              // Attachments
              if (assignment.attachments.isNotEmpty) ...[
                Text(
                  'Attachments:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...assignment.attachments.map(
                  (file) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: () {
                        // Open file preview
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.insert_drive_file),
                            const SizedBox(width: 8),
                            Text(
                              file,
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Submission status
              if (isSubmitted) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            assignment.status == 'graded'
                                ? Icons.grade
                                : Icons.check_circle,
                            color:
                                assignment.status == 'graded'
                                    ? AppColors.accentAmber
                                    : AppColors.success,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            assignment.status == 'graded'
                                ? 'GRADED (${assignment.grade}%)'
                                : 'SUBMITTED',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:
                                  assignment.status == 'graded'
                                      ? AppColors.accentAmber
                                      : AppColors.success,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Submitted on ${DateFormat('MMM d, y - h:mm a').format(assignment.submissionDate!)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.insert_drive_file),
                            const SizedBox(width: 8),
                            Text(
                              assignment.submissionFile!,
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (assignment.teacherFeedback != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          'Teacher Feedback:',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(assignment.teacherFeedback!),
                      ],
                    ],
                  ),
                ),
              ] else ...[
                // Submission button
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final submittedFile = await Navigator.push<String>(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => SubmitAssignmentScreen(
                                assignment: assignment,
                              ),
                        ),
                      );
                      if (submittedFile != null) {
                        onSubmission(submittedFile);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Assignment submitted successfully!'),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.upload),
                    label: const Text('SUBMIT ASSIGNMENT'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: subjectColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),

              // Warning if overdue
              if (assignment.isOverdue)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.error),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning, color: AppColors.error),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'This assignment is overdue. Late submissions may be penalized.',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getSubjectColor(String subject) {
    final colors = {
      'Mathematics': AppColors.secondary,
      'Physics': AppColors.accentBlue,
      'Chemistry': AppColors.accentPink,
      'Biology': AppColors.success,
      'English': AppColors.primaryLight,
      'History': AppColors.accentAmber,
    };
    return colors[subject] ?? AppColors.primary;
  }
}

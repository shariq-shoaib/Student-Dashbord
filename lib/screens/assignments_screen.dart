// lib/screens/assignments_screen.dart
import 'package:flutter/material.dart';
import '../models/assignment_model.dart';
import '../utils/app_design_system.dart';
import '../utils/theme.dart';
import 'assignment_detail_screen.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  List<Assignment> _assignments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAssignments();
  }

  Future<void> _loadAssignments() async {
    // In a real app, this would fetch from API
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _assignments = [
        Assignment(
          id: '1',
          subject: 'Mathematics',
          title: 'Linear Algebra Homework',
          description:
              'Solve problems 1-10 from chapter 3. Show all your work.',
          dueDate: DateTime.now().add(const Duration(days: 2)),
          postedDate: DateTime.now().subtract(const Duration(days: 3)),
          attachments: ['problem_set.pdf'],
          status: 'active',
        ),
        Assignment(
          id: '2',
          subject: 'Physics',
          title: 'Newton\'s Laws Lab Report',
          description: 'Write a 3-page report on your lab experiment results.',
          dueDate: DateTime.now().add(const Duration(days: 5)),
          postedDate: DateTime.now().subtract(const Duration(days: 1)),
          attachments: ['lab_guidelines.pdf'],
          status: 'active',
        ),
        Assignment(
          id: '3',
          subject: 'Chemistry',
          title: 'Periodic Table Quiz',
          description: 'Complete the online quiz about periodic table trends.',
          dueDate: DateTime.now().subtract(const Duration(days: 1)),
          postedDate: DateTime.now().subtract(const Duration(days: 7)),
          status: 'submitted',
          submissionFile: 'my_quiz_answers.pdf',
          submissionDate: DateTime.now().subtract(const Duration(days: 2)),
        ),
        Assignment(
          id: '4',
          subject: 'History',
          title: 'World War II Essay',
          description: '5-page essay on the causes of World War II.',
          dueDate: DateTime.now().add(const Duration(days: 7)),
          postedDate: DateTime.now(),
          attachments: ['essay_rubric.pdf'],
          status: 'upcoming',
        ),
        Assignment(
          id: '5',
          subject: 'English',
          title: 'Shakespeare Sonnet Analysis',
          description: 'Analyze one of Shakespeare\'s sonnets.',
          dueDate: DateTime.now().subtract(const Duration(days: 3)),
          postedDate: DateTime.now().subtract(const Duration(days: 10)),
          status: 'graded',
          grade: 88.5,
          submissionFile: 'sonnet_analysis.docx',
          submissionDate: DateTime.now().subtract(const Duration(days: 4)),
          teacherFeedback: 'Good analysis but could go deeper into metaphors.',
        ),
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppDesignSystem.appBar(context, 'My Assignments'),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary.withOpacity(0.05), AppColors.background],
          ),
        ),
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                  onRefresh: _loadAssignments,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildSectionHeader(
                        'Due Soon',
                        _assignments
                            .where(
                              (a) =>
                                  a.dueDate.difference(DateTime.now()).inDays <=
                                      3 &&
                                  a.status != 'graded',
                            )
                            .toList(),
                      ),
                      _buildSectionHeader(
                        'Recently Graded',
                        _assignments
                            .where((a) => a.status == 'graded')
                            .toList(),
                      ),
                      _buildSectionHeader('All Assignments', _assignments),
                    ],
                  ),
                ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, List<Assignment> assignments) {
    if (assignments.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
        ),
        ...assignments.map((assignment) => _buildAssignmentCard(assignment)),
      ],
    );
  }

  Widget _buildAssignmentCard(Assignment assignment) {
    final subjectColor = _getSubjectColor(assignment.subject);
    final isSubmitted =
        assignment.status == 'submitted' || assignment.status == 'graded';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _navigateToAssignmentDetail(assignment),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subject header with colored tag
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
              const SizedBox(height: 12),

              // Title and status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      assignment.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (assignment.isOverdue)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.error),
                      ),
                      child: Text(
                        'OVERDUE',
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    Text(
                      assignment.timeLeft,
                      style: TextStyle(
                        color:
                            assignment.dueDate
                                        .difference(DateTime.now())
                                        .inDays <
                                    3
                                ? AppColors.warning
                                : AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                assignment.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),

              // Status indicator
              if (isSubmitted)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
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
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            assignment.status == 'graded'
                                ? 'GRADED (${assignment.grade}%)'
                                : 'SUBMITTED',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  assignment.status == 'graded'
                                      ? AppColors.accentAmber
                                      : AppColors.success,
                            ),
                          ),
                        ],
                      ),
                      if (assignment.teacherFeedback != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Feedback: ${assignment.teacherFeedback}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ],
                  ),
                )
              else if (assignment.attachments.isNotEmpty)
                Wrap(
                  spacing: 8,
                  children: [
                    Icon(
                      Icons.attach_file,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    ...assignment.attachments.map(
                      (file) => Chip(
                        label: Text(file, style: const TextStyle(fontSize: 12)),
                        backgroundColor: AppColors.lightGrey,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 8),

              // Action button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _navigateToAssignmentDetail(assignment),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                  child: Text(
                    isSubmitted ? 'VIEW DETAILS' : 'VIEW & SUBMIT',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
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

  void _navigateToAssignmentDetail(Assignment assignment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => AssignmentDetailScreen(
              assignment: assignment,
              onSubmission: (file) => _handleSubmission(assignment, file),
            ),
      ),
    );
  }

  void _handleSubmission(Assignment assignment, String file) {
    setState(() {
      _assignments =
          _assignments.map((a) {
            if (a.id == assignment.id) {
              return Assignment(
                id: a.id,
                subject: a.subject,
                title: a.title,
                description: a.description,
                dueDate: a.dueDate,
                postedDate: a.postedDate,
                attachments: a.attachments,
                status: 'submitted',
                submissionFile: file,
                submissionDate: DateTime.now(),
              );
            }
            return a;
          }).toList();
    });
  }
}

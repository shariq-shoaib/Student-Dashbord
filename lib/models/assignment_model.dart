// lib/models/assignment_model.dart
class Assignment {
  final String id;
  final String subject;
  final String title;
  final String description;
  final DateTime dueDate;
  final DateTime postedDate;
  final List<String> attachments;
  final String status; // upcoming, active, submitted, graded
  final double? grade;
  final String? submissionFile;
  final DateTime? submissionDate;
  final String? teacherFeedback;

  Assignment({
    required this.id,
    required this.subject,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.postedDate,
    this.attachments = const [],
    this.status = 'upcoming',
    this.grade,
    this.submissionFile,
    this.submissionDate,
    this.teacherFeedback,
  });

  String get timeLeft {
    final difference = dueDate.difference(DateTime.now());
    if (difference.inDays > 0) return '${difference.inDays}d left';
    if (difference.inHours > 0) return '${difference.inHours}h left';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m left';
    return 'Due now';
  }

  bool get isOverdue =>
      dueDate.isBefore(DateTime.now()) &&
      status != 'submitted' &&
      status != 'graded';
}

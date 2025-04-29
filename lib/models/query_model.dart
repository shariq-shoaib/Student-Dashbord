// lib/models/query_model.dart
class Query {
  final String id;
  final String subject;
  final String question;
  final String? answer;
  final DateTime timestamp;
  final bool isResolved;

  Query({
    required this.id,
    required this.subject,
    required this.question,
    this.answer,
    required this.timestamp,
    this.isResolved = false,
  });

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
    return 'Just now';
  }
}

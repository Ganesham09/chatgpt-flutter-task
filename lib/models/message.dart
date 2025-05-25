import 'package:uuid/uuid.dart';

enum MessageRole {
  user,
  assistant,
  system,
}

class Message {
  final String id;
  final String content;
  final MessageRole role;
  final DateTime timestamp;

  Message({
    String? id,
    required this.content,
    required this.role,
    DateTime? timestamp,
  })  : id = id ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now();

  Message copyWith({
    String? content,
    MessageRole? role,
    DateTime? timestamp,
  }) {
    return Message(
      id: id,
      content: content ?? this.content,
      role: role ?? this.role,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'role': role.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      content: json['content'] as String,
      role: MessageRole.values.firstWhere(
        (e) => e.toString().split('.').last == json['role'],
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
} 
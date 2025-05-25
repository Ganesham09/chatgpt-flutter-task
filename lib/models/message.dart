import 'package:uuid/uuid.dart';

enum MessageRole {
  user,
  assistant,
}

class Message {
  final String id;
  final String content;
  final MessageRole role;
  final DateTime timestamp;
  final String? imageUrl;
  final String model;

  Message({
    String? id,
    required this.content,
    required this.role,
    DateTime? timestamp,
    this.imageUrl,
    required this.model,
  })  : id = id ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now();

  Message copyWith({
    String? content,
    MessageRole? role,
    DateTime? timestamp,
    String? imageUrl,
    String? model,
  }) {
    return Message(
      id: id,
      content: content ?? this.content,
      role: role ?? this.role,
      timestamp: timestamp ?? this.timestamp,
      imageUrl: imageUrl ?? this.imageUrl,
      model: model ?? this.model,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'role': role.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
      'imageUrl': imageUrl,
      'model': model,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      role: MessageRole.values.firstWhere(
        (e) => e.toString().split('.').last == json['role'],
      ),
      timestamp: DateTime.parse(json['timestamp']),
      imageUrl: json['imageUrl'],
      model: json['model'],
    );
  }
} 
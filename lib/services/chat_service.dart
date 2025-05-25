import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:chat_gpt_clone/models/message.dart';

final chatServiceProvider = Provider<ChatService>((ref) {
  return ChatService();
});

class ChatService {
  final String _apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
  final String _baseUrl = 'https://api.openai.com/v1';

  Future<String> getChatCompletion({
    required List<Message> messages,
    required String model,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': model,
          'messages': messages.map((m) => {
            'role': m.role.toString().split('.').last,
            'content': m.content,
          }).toList(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception('Failed to get chat completion: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error getting chat completion: $e');
    }
  }
} 
import 'package:dio/dio.dart';
import 'package:chat_gpt_clone/models/conversation.dart';
import 'package:chat_gpt_clone/models/message.dart';

class ApiService {
  final Dio _dio;
  final String _baseUrl;

  ApiService({String? baseUrl})
      : _baseUrl = baseUrl ?? 'http://localhost:3000/api',
        _dio = Dio() {
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
  }

  // Chat endpoints
  Future<List<Conversation>> getConversations() async {
    try {
      final response = await _dio.get('$_baseUrl/chat/conversations');
      return (response.data as List)
          .map((json) => Conversation.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get conversations: $e');
    }
  }

  Future<Conversation> getConversation(String id) async {
    try {
      final response = await _dio.get('$_baseUrl/chat/conversations/$id');
      return Conversation.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get conversation: $e');
    }
  }

  Future<Conversation> createConversation() async {
    try {
      final response = await _dio.post('$_baseUrl/chat/conversations');
      return Conversation.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create conversation: $e');
    }
  }

  Future<Conversation> updateConversationTitle(String id, String title) async {
    try {
      final response = await _dio.patch(
        '$_baseUrl/chat/conversations/$id/title',
        data: {'title': title},
      );
      return Conversation.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update conversation title: $e');
    }
  }

  Future<void> deleteConversation(String id) async {
    try {
      await _dio.delete('$_baseUrl/chat/conversations/$id');
    } catch (e) {
      throw Exception('Failed to delete conversation: $e');
    }
  }

  Future<Map<String, Message>> sendMessage(
    String conversationId,
    String content, {
    String? imageUrl,
    required String model,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/chat/conversations/$conversationId/messages',
        data: {
          'content': content,
          'imageUrl': imageUrl,
          'model': model,
        },
      );

      return {
        'userMessage': Message.fromJson(response.data['userMessage']),
        'aiMessage': Message.fromJson(response.data['aiMessage']),
      };
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  // Image upload endpoint
  Future<String> uploadImage(String imagePath) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imagePath),
      });

      final response = await _dio.post(
        '$_baseUrl/image/upload',
        data: formData,
      );

      return response.data['url'];
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
} 
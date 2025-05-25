import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences.dart';
import 'dart:convert';
import 'package:chat_gpt_clone/models/conversation.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

class StorageService {
  static const String _conversationsKey = 'conversations';

  Future<List<Conversation>> loadConversations() async {
    final prefs = await SharedPreferences.getInstance();
    final conversationsJson = prefs.getStringList(_conversationsKey) ?? [];
    
    return conversationsJson
        .map((json) => Conversation.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> saveConversation(Conversation conversation) async {
    final prefs = await SharedPreferences.getInstance();
    final conversations = await loadConversations();
    
    final index = conversations.indexWhere((c) => c.id == conversation.id);
    if (index != -1) {
      conversations[index] = conversation;
    } else {
      conversations.add(conversation);
    }

    final conversationsJson = conversations
        .map((c) => jsonEncode(c.toJson()))
        .toList();

    await prefs.setStringList(_conversationsKey, conversationsJson);
  }

  Future<void> deleteConversation(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final conversations = await loadConversations();
    
    conversations.removeWhere((c) => c.id == id);
    
    final conversationsJson = conversations
        .map((c) => jsonEncode(c.toJson()))
        .toList();

    await prefs.setStringList(_conversationsKey, conversationsJson);
  }
} 
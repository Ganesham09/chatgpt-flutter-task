import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_gpt_clone/models/conversation.dart';
import 'package:chat_gpt_clone/models/message.dart';
import 'package:chat_gpt_clone/services/api_service.dart';

final chatProvider = StateNotifierProvider<ChatNotifier, AsyncValue<List<Conversation>>>((ref) {
  return ChatNotifier(
    apiService: ref.watch(apiServiceProvider),
  );
});

final currentConversationProvider = StateProvider<Conversation?>((ref) => null);

final selectedModelProvider = StateProvider<String>((ref) => 'gpt-3.5-turbo');

class ChatNotifier extends StateNotifier<AsyncValue<List<Conversation>>> {
  final ApiService _apiService;

  ChatNotifier({
    required ApiService apiService,
  })  : _apiService = apiService,
        super(const AsyncValue.loading()) {
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    try {
      final conversations = await _apiService.getConversations();
      state = AsyncValue.data(conversations);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> sendMessage(String content, {String? imageUrl}) async {
    final currentConversation = ref.read(currentConversationProvider);
    final selectedModel = ref.read(selectedModelProvider);

    try {
      if (currentConversation == null) {
        // Create new conversation
        final newConversation = await _apiService.createConversation();
        ref.read(currentConversationProvider.notifier).state = newConversation;

        // Send message
        final messages = await _apiService.sendMessage(
          newConversation.id,
          content,
          imageUrl: imageUrl,
          model: selectedModel,
        );

        // Update conversation with new messages
        final updatedConversation = await _apiService.getConversation(newConversation.id);
        ref.read(currentConversationProvider.notifier).state = updatedConversation;
      } else {
        // Send message to existing conversation
        final messages = await _apiService.sendMessage(
          currentConversation.id,
          content,
          imageUrl: imageUrl,
          model: selectedModel,
        );

        // Update conversation with new messages
        final updatedConversation = await _apiService.getConversation(currentConversation.id);
        ref.read(currentConversationProvider.notifier).state = updatedConversation;
      }

      await _loadConversations();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteConversation(String id) async {
    try {
      await _apiService.deleteConversation(id);
      await _loadConversations();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateConversationTitle(String id, String title) async {
    try {
      await _apiService.updateConversationTitle(id, title);
      await _loadConversations();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
} 
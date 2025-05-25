import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_gpt_clone/models/conversation.dart';
import 'package:chat_gpt_clone/models/message.dart';
import 'package:chat_gpt_clone/services/chat_service.dart';
import 'package:chat_gpt_clone/services/storage_service.dart';

final chatProvider = StateNotifierProvider<ChatNotifier, AsyncValue<List<Conversation>>>((ref) {
  return ChatNotifier(
    chatService: ref.watch(chatServiceProvider),
    storageService: ref.watch(storageServiceProvider),
  );
});

final currentConversationProvider = StateProvider<Conversation?>((ref) => null);

final selectedModelProvider = StateProvider<String>((ref) => 'gpt-3.5-turbo');

class ChatNotifier extends StateNotifier<AsyncValue<List<Conversation>>> {
  final ChatService _chatService;
  final StorageService _storageService;

  ChatNotifier({
    required ChatService chatService,
    required StorageService storageService,
  })  : _chatService = chatService,
        _storageService = storageService,
        super(const AsyncValue.loading()) {
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    try {
      final conversations = await _storageService.loadConversations();
      state = AsyncValue.data(conversations);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> sendMessage(String content, {String? imageUrl}) async {
    final currentConversation = ref.read(currentConversationProvider);
    final selectedModel = ref.read(selectedModelProvider);

    if (currentConversation == null) {
      // Create new conversation
      final newConversation = Conversation();
      final userMessage = Message(
        content: content,
        role: MessageRole.user,
        imageUrl: imageUrl,
        model: selectedModel,
      );

      newConversation.messages.add(userMessage);
      ref.read(currentConversationProvider.notifier).state = newConversation;

      // Get AI response
      final response = await _chatService.getChatCompletion(
        messages: [userMessage],
        model: selectedModel,
      );

      final aiMessage = Message(
        content: response,
        role: MessageRole.assistant,
        model: selectedModel,
      );

      newConversation.messages.add(aiMessage);
      await _storageService.saveConversation(newConversation);
      await _loadConversations();
    } else {
      // Add to existing conversation
      final userMessage = Message(
        content: content,
        role: MessageRole.user,
        imageUrl: imageUrl,
        model: selectedModel,
      );

      currentConversation.messages.add(userMessage);
      ref.read(currentConversationProvider.notifier).state = currentConversation;

      // Get AI response
      final response = await _chatService.getChatCompletion(
        messages: currentConversation.messages,
        model: selectedModel,
      );

      final aiMessage = Message(
        content: response,
        role: MessageRole.assistant,
        model: selectedModel,
      );

      currentConversation.messages.add(aiMessage);
      await _storageService.saveConversation(currentConversation);
      await _loadConversations();
    }
  }

  Future<void> deleteConversation(String id) async {
    await _storageService.deleteConversation(id);
    await _loadConversations();
  }

  Future<void> updateConversationTitle(String id, String title) async {
    final conversations = state.value ?? [];
    final index = conversations.indexWhere((c) => c.id == id);
    if (index != -1) {
      final updatedConversation = conversations[index].copyWith(title: title);
      await _storageService.saveConversation(updatedConversation);
      await _loadConversations();
    }
  }
} 
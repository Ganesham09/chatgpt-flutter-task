import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_gpt_clone/providers/chat_provider.dart';
import 'package:chat_gpt_clone/widgets/message_bubble.dart';
import 'package:chat_gpt_clone/widgets/chat_input.dart';
import 'package:chat_gpt_clone/widgets/model_selector.dart';
import 'package:chat_gpt_clone/screens/conversation_history_screen.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversations = ref.watch(chatProvider);
    final currentConversation = ref.watch(currentConversationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatGPT Clone'),
        actions: [
          const ModelSelector(),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConversationHistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: conversations.when(
              data: (conversations) {
                if (currentConversation == null) {
                  return const Center(
                    child: Text('Start a new conversation'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: currentConversation.messages.length,
                  itemBuilder: (context, index) {
                    final message = currentConversation.messages[index];
                    return MessageBubble(message: message);
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
          const ChatInput(),
        ],
      ),
    );
  }
} 
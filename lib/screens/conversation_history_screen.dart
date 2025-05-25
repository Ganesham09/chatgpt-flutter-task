import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:chat_gpt_clone/providers/chat_provider.dart';
import 'package:chat_gpt_clone/models/conversation.dart';

class ConversationHistoryScreen extends ConsumerWidget {
  const ConversationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversations = ref.watch(chatProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversation History'),
      ),
      body: conversations.when(
        data: (conversations) {
          if (conversations.isEmpty) {
            return const Center(
              child: Text('No conversations yet'),
            );
          }

          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              return _ConversationTile(conversation: conversation);
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
    );
  }
}

class _ConversationTile extends ConsumerWidget {
  final Conversation conversation;

  const _ConversationTile({
    required this.conversation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM d, y • h:mm a');

    return ListTile(
      title: Text(
        conversation.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        dateFormat.format(conversation.updatedAt),
        style: theme.textTheme.bodySmall,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete Conversation'),
              content: const Text(
                'Are you sure you want to delete this conversation?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    ref
                        .read(chatProvider.notifier)
                        .deleteConversation(conversation.id);
                    Navigator.pop(context);
                  },
                  child: const Text('Delete'),
                ),
              ],
            ),
          );
        },
      ),
      onTap: () {
        ref.read(currentConversationProvider.notifier).state = conversation;
        Navigator.pop(context);
      },
    );
  }
} 
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_gpt_clone/providers/chat_provider.dart';

class ModelSelector extends ConsumerWidget {
  const ModelSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedModel = ref.watch(selectedModelProvider);

    return PopupMenuButton<String>(
      icon: const Icon(Icons.smart_toy),
      tooltip: 'Select Model',
      onSelected: (model) {
        ref.read(selectedModelProvider.notifier).state = model;
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'gpt-3.5-turbo',
          child: Text('GPT-3.5 Turbo'),
        ),
        const PopupMenuItem(
          value: 'gpt-4',
          child: Text('GPT-4'),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          selectedModel == 'gpt-3.5-turbo' ? 'GPT-3.5' : 'GPT-4',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
} 
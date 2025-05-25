import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chat_gpt_clone/providers/chat_provider.dart';
import 'package:chat_gpt_clone/services/image_service.dart';
import 'dart:io';

class ChatInput extends ConsumerStatefulWidget {
  const ChatInput({super.key});

  @override
  ConsumerState<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends ConsumerState<ChatInput> {
  final _textController = TextEditingController();
  final _imagePicker = ImagePicker();
  String? _imageUrl;
  bool _isUploading = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _isUploading = true;
        });

        final imageService = ref.read(imageServiceProvider);
        final uploadedUrl = await imageService.uploadImage(File(image.path));

        setState(() {
          _imageUrl = uploadedUrl;
          _isUploading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $e')),
        );
      }
    }
  }

  void _handleSubmitted() {
    final text = _textController.text.trim();
    if (text.isEmpty && _imageUrl == null) return;

    ref.read(chatProvider.notifier).sendMessage(
          text,
          imageUrl: _imageUrl,
        );

    _textController.clear();
    setState(() {
      _imageUrl = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_imageUrl != null)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    _imageUrl!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _imageUrl = null;
                      });
                    },
                  ),
                ),
              ],
            ),
          if (_isUploading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.image),
                onPressed: _isUploading ? null : _pickImage,
              ),
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _isUploading ? null : _handleSubmitted,
              ),
            ],
          ),
        ],
      ),
    );
  }
} 
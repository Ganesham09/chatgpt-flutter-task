import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_gpt_clone/services/api_service.dart';
import 'dart:io';

final imageServiceProvider = Provider<ImageService>((ref) {
  return ImageService(apiService: ref.watch(apiServiceProvider));
});

class ImageService {
  final ApiService _apiService;

  ImageService({required ApiService apiService}) : _apiService = apiService;

  Future<String> uploadImage(File imageFile) async {
    try {
      return await _apiService.uploadImage(imageFile.path);
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }
} 
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

final imageServiceProvider = Provider<ImageService>((ref) {
  return ImageService();
});

class ImageService {
  final String _cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
  final String _apiKey = dotenv.env['CLOUDINARY_API_KEY'] ?? '';
  final String _apiSecret = dotenv.env['CLOUDINARY_API_SECRET'] ?? '';
  final Dio _dio = Dio();

  Future<String> uploadImage(File imageFile) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final signature = _generateSignature(timestamp);

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imageFile.path),
        'api_key': _apiKey,
        'timestamp': timestamp,
        'signature': signature,
      });

      final response = await _dio.post(
        'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data['secure_url'];
      } else {
        throw Exception('Failed to upload image: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  String _generateSignature(int timestamp) {
    // TODO: Implement proper signature generation using crypto
    // This is a placeholder implementation
    return 'placeholder_signature';
  }
} 
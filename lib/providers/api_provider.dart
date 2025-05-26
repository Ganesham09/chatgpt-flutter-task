import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_gpt_clone/services/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
}); 
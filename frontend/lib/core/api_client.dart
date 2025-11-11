import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;
import 'secure_storage.dart';

/// Singleton API client for making HTTP requests
/// Automatically handles authentication tokens and platform-specific base URLs
class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  
  ApiClient._internal() {
    // Get base URL from environment variable or use platform-specific defaults
    final envBase =
        const String.fromEnvironment('API_BASE_URL', defaultValue: '');
    
    // Determine base URL based on platform
    final base = envBase.isNotEmpty
        ? envBase
        : kIsWeb
            ? '${Uri.base.scheme}://${Uri.base.host}:${Uri.base.port}'
            : (Platform.isAndroid
                ? 'http://10.0.2.2:8000' // Android emulator special IP
                : 'http://127.0.0.1:8000'); // iOS/Desktop localhost
    
    // Initialize Dio with base configuration
    _dio = Dio(BaseOptions(
      baseUrl: base,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Accept': 'application/json'},
    ));
    
    // Add interceptor to automatically attach auth token to requests
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await SecureStorage.readToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  late final Dio _dio;
  Dio get dio => _dio;
}

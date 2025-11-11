import 'package:dio/dio.dart';
import '../../../core/api_client.dart';
import '../../../core/secure_storage.dart';

class AuthRepository {
  final Dio _dio = ApiClient().dio;

  Future<Map<String, dynamic>> register(
      {required String name,
      required String email,
      required String password}) async {
    final res = await _dio.post('/api/register', data: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password,
    });
    final data = Map<String, dynamic>.from(res.data as Map);
    final token = data['token'] as String?;
    if (token != null) await SecureStorage.writeToken(token);
    return data;
  }

  Future<Map<String, dynamic>> login(
      {required String email, required String password}) async {
    final res = await _dio.post('/api/login', data: {
      'email': email,
      'password': password,
    });
    final data = Map<String, dynamic>.from(res.data as Map);
    final token = data['token'] as String?;
    if (token != null) await SecureStorage.writeToken(token);
    return data;
  }

  Future<void> logout() async {
    try {
      await _dio.post('/api/logout');
    } finally {
      await SecureStorage.clearToken();
    }
  }

  Future<bool> isAuthenticated() async {
    return (await SecureStorage.readToken()) != null;
  }
}

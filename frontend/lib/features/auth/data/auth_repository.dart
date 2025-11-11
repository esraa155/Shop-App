import 'package:dio/dio.dart';
import '../../../core/api_client.dart';
import '../../../core/secure_storage.dart';

class AuthRepository {
  final Dio _dio = ApiClient().dio;

  Future<Map<String, dynamic>> register({
      required String name,
      required String email,
      required String password,
      String? phone,
      String? address,
      String? dateOfBirth,
      String? city,
      String? country,
  }) async {
    final data = {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password,
    };
    if (phone != null && phone.isNotEmpty) data['phone'] = phone;
    if (address != null && address.isNotEmpty) data['address'] = address;
    if (dateOfBirth != null && dateOfBirth.isNotEmpty) data['date_of_birth'] = dateOfBirth;
    if (city != null && city.isNotEmpty) data['city'] = city;
    if (country != null && country.isNotEmpty) data['country'] = country;
    
    final res = await _dio.post('/api/register', data: data);
    final responseData = Map<String, dynamic>.from(res.data as Map);
    final token = responseData['token'] as String?;
    if (token != null) await SecureStorage.writeToken(token);
    return responseData;
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

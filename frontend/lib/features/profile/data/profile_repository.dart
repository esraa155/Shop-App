import 'package:dio/dio.dart';
import '../../../core/api_client.dart';

/// User profile model
class UserProfile {
  final int id;
  final String name;
  final String email;
  final String? avatar;
  final String? phone;
  final String? address;
  final String? dateOfBirth;
  final String? city;
  final String? country;
  final String? createdAt;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.phone,
    this.address,
    this.dateOfBirth,
    this.city,
    this.country,
    this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
        avatar: json['avatar'] as String?,
        phone: json['phone'] as String?,
        address: json['address'] as String?,
        dateOfBirth: json['date_of_birth'] as String?,
        city: json['city'] as String?,
        country: json['country'] as String?,
        createdAt: json['created_at'] as String?,
      );
}

/// Repository for user profile operations
class ProfileRepository {
  final Dio _dio = ApiClient().dio;

  /// Get current user's profile information
  Future<UserProfile> getProfile() async {
    final res = await _dio.get('/api/profile');
    return UserProfile.fromJson(res.data as Map<String, dynamic>);
  }

  /// Update user's profile information
  Future<UserProfile> updateProfile({
    String? name,
    String? email,
    String? avatar,
    String? phone,
    String? address,
    String? dateOfBirth,
    String? city,
    String? country,
  }) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (email != null) data['email'] = email;
    if (avatar != null) data['avatar'] = avatar;
    if (phone != null) data['phone'] = phone.isEmpty ? null : phone;
    if (address != null) data['address'] = address.isEmpty ? null : address;
    if (dateOfBirth != null) data['date_of_birth'] = dateOfBirth.isEmpty ? null : dateOfBirth;
    if (city != null) data['city'] = city.isEmpty ? null : city;
    if (country != null) data['country'] = country.isEmpty ? null : country;

    final res = await _dio.put('/api/profile', data: data);
    return UserProfile.fromJson(res.data as Map<String, dynamic>);
  }

  /// Change user's password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await _dio.post('/api/profile/change-password', data: {
      'current_password': currentPassword,
      'password': newPassword,
      'password_confirmation': confirmPassword,
    });
  }
}


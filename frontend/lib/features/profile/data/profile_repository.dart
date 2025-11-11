import 'package:dio/dio.dart';
import '../../../core/api_client.dart';

/// User profile model
class UserProfile {
  final int id;
  final String name;
  final String email;
  final String? avatar;
  final String? createdAt;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
        avatar: json['avatar'] as String?,
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
  }) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (email != null) data['email'] = email;
    if (avatar != null) data['avatar'] = avatar;

    final res = await _dio.put('/api/profile', data: data);
    return UserProfile.fromJson(res.data as Map<String, dynamic>);
  }
}


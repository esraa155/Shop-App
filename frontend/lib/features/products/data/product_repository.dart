import 'package:dio/dio.dart';
import '../../../core/api_client.dart';

class Product {
  final int id;
  final String name;
  final String? category;
  final String? description;
  final String? specifications;
  final double price;
  final int stock;
  final String? imageUrl;
  final bool isActive;
  const Product(
      {required this.id,
      required this.name,
      this.category,
      this.description,
      this.specifications,
      required this.price,
      this.stock = 0,
      this.imageUrl,
      required this.isActive});
  factory Product.fromJson(Map<String, dynamic> j) => Product(
        id: j['id'] as int,
        name: j['name'] as String,
        category: j['category'] as String?,
        description: j['description'] as String?,
        specifications: j['specifications'] as String?,
        price: (j['price'] as num).toDouble(),
        stock: (j['stock'] as int?) ?? 0,
        imageUrl: j['image_url'] as String?,
        isActive: j['is_active'] as bool? ?? true,
      );
}

class ProductRepository {
  final Dio _dio = ApiClient().dio;
  Future<List<Product>> list({int page = 1, int perPage = 20}) async {
    final res = await _dio.get('/api/products',
        queryParameters: {'page': page, 'per_page': perPage});
    final data = res.data is Map && (res.data as Map).containsKey('data')
        ? (res.data['data'] as List)
        : (res.data as List);
    return data
        .map((e) => Product.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<Set<int>> listFavoritesIds() async {
    final res = await _dio.get('/api/favorites');
    final data = res.data is Map && (res.data as Map).containsKey('data')
        ? (res.data['data'] as List)
        : (res.data as List);
    return data
        .map((e) => Product.fromJson(Map<String, dynamic>.from(e as Map)).id)
        .toSet();
  }

  Future<bool> toggleFavorite(int productId) async {
    final res = await _dio.post('/api/favorites/toggle/$productId');
    return (res.data['favorited'] as bool?) ?? false;
  }
}

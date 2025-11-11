import 'package:dio/dio.dart';
import '../../../core/api_client.dart';
import '../../products/data/product_repository.dart';

class CartItem {
  final int id;
  final Product? product;
  final int quantity;
  final double lineTotal;
  const CartItem(
      {required this.id,
      required this.product,
      required this.quantity,
      required this.lineTotal});
  factory CartItem.fromJson(Map<String, dynamic> j) => CartItem(
        id: j['id'] as int,
        product: j['product'] != null
            ? Product.fromJson(Map<String, dynamic>.from(j['product'] as Map))
            : null,
        quantity: (j['quantity'] as num).toInt(),
        lineTotal: (j['line_total'] as num).toDouble(),
      );
}

class CartRepository {
  final Dio _dio = ApiClient().dio;

  Future<(List<CartItem> items, double subtotal)> getCart() async {
    final res = await _dio.get('/api/cart');
    final items = (res.data['items'] as List)
        .map((e) => CartItem.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    final subtotal = (res.data['subtotal'] as num).toDouble();
    return (items, subtotal);
  }

  Future<CartItem> addToCart({required int productId, int quantity = 1}) async {
    final res = await _dio.post('/api/cart/add',
        data: {'product_id': productId, 'quantity': quantity});
    return CartItem.fromJson(Map<String, dynamic>.from(res.data as Map));
  }

  Future<void> removeFromCart({required int cartItemId}) async {
    await _dio.delete('/api/cart/remove/$cartItemId');
  }

  Future<void> updateQuantity(
      {required int cartItemId, required int quantity}) async {
    await _dio
        .patch('/api/cart/update/$cartItemId', data: {'quantity': quantity});
  }

  Future<void> checkout() async {
    await _dio.post('/api/checkout');
  }
}

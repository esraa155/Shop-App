import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/cart_repository.dart';
import '../../products/bloc/products_bloc.dart';

sealed class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class CartRequested extends CartEvent {}

final class CartAddPressed extends CartEvent {
  final int productId;
  final int qty;
  CartAddPressed(this.productId, {this.qty = 1});
  @override
  List<Object?> get props => [productId, qty];
}

final class CartRemovePressed extends CartEvent {
  final int cartItemId;
  CartRemovePressed(this.cartItemId);
  @override
  List<Object?> get props => [cartItemId];
}

final class CartUpdateQuantityPressed extends CartEvent {
  final int cartItemId;
  final int quantity;
  CartUpdateQuantityPressed(this.cartItemId, this.quantity);
  @override
  List<Object?> get props => [cartItemId, quantity];
}

final class CartCheckoutPressed extends CartEvent {}

sealed class CartState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class CartLoading extends CartState {}

final class CartLoaded extends CartState {
  final List<CartItem> items;
  final double subtotal;
  CartLoaded({required this.items, required this.subtotal});
  @override
  List<Object?> get props => [items, subtotal];
}

final class CartError extends CartState {
  final String message;
  CartError(this.message);
  @override
  List<Object?> get props => [message];
}

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _repo;
  ProductsBloc? _productsBloc;
  
  void setProductsBloc(ProductsBloc bloc) {
    _productsBloc = bloc;
  }
  
  CartBloc(this._repo) : super(CartLoading()) {
    on<CartRequested>((event, emit) async {
      await _refresh(emit);
    });
    on<CartAddPressed>((event, emit) async {
      try {
        final cartItem = await _repo.addToCart(productId: event.productId, quantity: event.qty);
        // Update product stock in ProductsBloc if available
        if (_productsBloc != null && cartItem.product != null) {
          _productsBloc!.add(ProductStockUpdated(event.productId, cartItem.product!.stock));
        }
        await _refresh(emit);
      } catch (e) {
        emit(CartError('Failed to add to cart'));
      }
    });
    on<CartRemovePressed>((event, emit) async {
      try {
        // Get cart item before removing to know which product to update
        final currentState = state;
        int? productId;
        int? quantity;
        if (currentState is CartLoaded && currentState.items.isNotEmpty) {
          try {
            final item = currentState.items.firstWhere(
              (item) => item.id == event.cartItemId,
            );
            productId = item.product?.id;
            quantity = item.quantity;
          } catch (_) {
            // Item not found, continue with removal
          }
        }
        
        await _repo.removeFromCart(cartItemId: event.cartItemId);
        
        // Update product stock in ProductsBloc if available
        if (_productsBloc != null && productId != null && quantity != null) {
          // Get current product stock and add back the quantity
          final productsState = _productsBloc!.state;
          if (productsState is ProductsLoaded) {
            try {
              final product = productsState.products.firstWhere(
                (p) => p.id == productId,
              );
              final newStock = product.stock + quantity;
              _productsBloc!.add(ProductStockUpdated(productId, newStock));
            } catch (_) {
              // Product not found, skip stock update
            }
          }
        }
        
        await _refresh(emit);
      } catch (e) {
        emit(CartError('Failed to remove item'));
      }
    });
    on<CartCheckoutPressed>((event, emit) async {
      try {
        await _repo.checkout();
        await _refresh(emit);
      } catch (e) {
        emit(CartError('Checkout failed'));
      }
    });
    on<CartUpdateQuantityPressed>((event, emit) async {
      try {
        // Get cart item before updating to know which product and old quantity
        final currentState = state;
        int? productId;
        int? oldQuantity;
        if (currentState is CartLoaded && currentState.items.isNotEmpty) {
          try {
            final item = currentState.items.firstWhere(
              (item) => item.id == event.cartItemId,
            );
            productId = item.product?.id;
            oldQuantity = item.quantity;
          } catch (_) {
            // Item not found, continue with update
          }
        }
        
        await _repo.updateQuantity(
            cartItemId: event.cartItemId, quantity: event.quantity);
        
        // Update product stock in ProductsBloc if available
        if (_productsBloc != null && productId != null && oldQuantity != null) {
          final quantityDifference = event.quantity - oldQuantity;
          final productsState = _productsBloc!.state;
          if (productsState is ProductsLoaded) {
            try {
              final product = productsState.products.firstWhere(
                (p) => p.id == productId,
              );
              final newStock = product.stock - quantityDifference;
              _productsBloc!.add(ProductStockUpdated(productId, newStock));
            } catch (_) {
              // Product not found, skip stock update
            }
          }
        }
        
        await _refresh(emit);
      } catch (e) {
        emit(CartError('Failed to update quantity'));
      }
    });
  }

  Future<void> _refresh(Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final (items, subtotal) = await _repo.getCart();
      emit(CartLoaded(items: items, subtotal: subtotal));
    } catch (e) {
      emit(CartError('Failed to load cart'));
    }
  }
}

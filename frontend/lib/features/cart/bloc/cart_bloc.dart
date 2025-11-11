import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/cart_repository.dart';

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
  CartBloc(this._repo) : super(CartLoading()) {
    on<CartRequested>((event, emit) async {
      await _refresh(emit);
    });
    on<CartAddPressed>((event, emit) async {
      try {
        await _repo.addToCart(productId: event.productId, quantity: event.qty);
        await _refresh(emit);
      } catch (e) {
        emit(CartError('Failed to add to cart'));
      }
    });
    on<CartRemovePressed>((event, emit) async {
      try {
        await _repo.removeFromCart(cartItemId: event.cartItemId);
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
        await _repo.updateQuantity(
            cartItemId: event.cartItemId, quantity: event.quantity);
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

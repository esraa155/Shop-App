import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/product_repository.dart';
import 'package:flutter/foundation.dart'; // listEquals

// Events
sealed class ProductsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// أضفنا `silent` ليكون reload صامت
final class ProductsRequested extends ProductsEvent {
  final bool silent;
  ProductsRequested({this.silent = false});

  @override
  List<Object?> get props => [silent];
}

final class ProductFavoriteToggled extends ProductsEvent {
  final int productId;
  ProductFavoriteToggled(this.productId);
  @override
  List<Object?> get props => [productId];
}

final class ProductStockUpdated extends ProductsEvent {
  final int productId;
  final int newStock;
  ProductStockUpdated(this.productId, this.newStock);
  @override
  List<Object?> get props => [productId, newStock];
}

// States
sealed class ProductsState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class ProductsLoading extends ProductsState {}

final class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final Set<int> favorites;
  ProductsLoaded({required this.products, required this.favorites});
  @override
  List<Object?> get props => [products, favorites];
}

final class ProductsError extends ProductsState {}

// Bloc
class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductRepository _repo;
  final Set<int> _favorites = {};

  ProductsBloc(this._repo) : super(ProductsLoading()) {
    // Reload products
    on<ProductsRequested>((event, emit) async {
      if (!event.silent) emit(ProductsLoading());

      try {
        final items = await _repo.list();
        final favs = await _repo.listFavoritesIds();
        _favorites
          ..clear()
          ..addAll(favs);

        if (event.silent && state is ProductsLoaded) {
          final currentProducts = (state as ProductsLoaded).products;
          if (listEquals(currentProducts, items)) {
            return; // البيانات لم تتغير، لا نرسل state جديد
          }
        }

        emit(ProductsLoaded(products: items, favorites: {..._favorites}));
      } catch (e) {
        emit(ProductsError());
      }
    });

    // Toggle favorite
    on<ProductFavoriteToggled>((event, emit) async {
      try {
        final favorited = await _repo.toggleFavorite(event.productId);
        if (favorited) {
          _favorites.add(event.productId);
        } else {
          _favorites.remove(event.productId);
        }
        if (state is ProductsLoaded) {
          final s = state as ProductsLoaded;
          emit(
              ProductsLoaded(products: s.products, favorites: {..._favorites}));
        }
      } catch (_) {}
    });

    // Update stock
    on<ProductStockUpdated>((event, emit) {
      if (state is ProductsLoaded) {
        final s = state as ProductsLoaded;
        final updatedProducts = s.products.map((product) {
          if (product.id == event.productId) {
            return Product(
              id: product.id,
              name: product.name,
              category: product.category,
              description: product.description,
              specifications: product.specifications,
              price: product.price,
              stock: event.newStock,
              imageUrl: product.imageUrl,
              isActive: product.isActive,
            );
          }
          return product;
        }).toList();
        emit(ProductsLoaded(
            products: updatedProducts, favorites: {..._favorites}));
      }
    });
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/product_repository.dart';

sealed class ProductsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class ProductsRequested extends ProductsEvent {}

final class ProductFavoriteToggled extends ProductsEvent {
  final int productId;
  ProductFavoriteToggled(this.productId);
  @override
  List<Object?> get props => [productId];
}

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

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductRepository _repo;
  final Set<int> _favorites = {};
  ProductsBloc(this._repo) : super(ProductsLoading()) {
    on<ProductsRequested>((event, emit) async {
      emit(ProductsLoading());
      try {
        final items = await _repo.list();
        final favs = await _repo.listFavoritesIds();
        _favorites
          ..clear()
          ..addAll(favs);
        emit(ProductsLoaded(products: items, favorites: {..._favorites}));
      } catch (e) {
        emit(ProductsError());
      }
    });
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
  }
}

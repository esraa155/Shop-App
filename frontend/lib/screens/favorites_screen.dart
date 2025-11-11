import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/products/bloc/products_bloc.dart';
import '../l10n/app_localizations.dart';

/// Favorites screen displaying user's favorite products
/// Allows users to view and remove favorites
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.favorites)),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          // Optimize loading: show previous favorites while loading
          if (state is ProductsLoading) {
            // Check if we have previous loaded state to maintain continuity
            final previousState = context.read<ProductsBloc>().state;
            if (previousState is ProductsLoaded) {
              // Display previous favorites while loading new data
              final favIds = previousState.favorites;
              final favProducts = previousState.products
                  .where((p) => favIds.contains(p.id))
                  .toList();
              if (favProducts.isEmpty) {
                return Center(child: Text(l10n.noFavoritesYet));
              }
              return ListView.builder(
                itemCount: favProducts.length,
                itemBuilder: (ctx, i) {
                  final p = favProducts[i];
                  return ListTile(
                    leading: CircleAvatar(
                        child: Text(p.name.isNotEmpty ? p.name[0] : '?')),
                    title: Text(p.name),
                    subtitle:
                        Text('${l10n.price}: ${p.price.toStringAsFixed(2)}'),
                    trailing: Tooltip(
                      message: l10n.removeFromFavorites,
                      child: IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () {
                          context
                              .read<ProductsBloc>()
                              .add(ProductFavoriteToggled(p.id));
                        },
                      ),
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          } else if (state is ProductsLoaded) {
            // Filter products to show only favorites
            final favIds = state.favorites;
            final favProducts =
                state.products.where((p) => favIds.contains(p.id)).toList();
            
            // Show empty state if no favorites
            if (favProducts.isEmpty) {
              return Center(child: Text(l10n.noFavoritesYet));
            }
            
            // Display favorites list
            return ListView.builder(
              itemCount: favProducts.length,
              itemBuilder: (ctx, i) {
                final p = favProducts[i];
                return ListTile(
                  leading: CircleAvatar(
                      child: Text(p.name.isNotEmpty ? p.name[0] : '?')),
                  title: Text(p.name),
                  subtitle:
                      Text('${l10n.price}: ${p.price.toStringAsFixed(2)}'),
                  trailing: Tooltip(
                    message: l10n.removeFromFavorites,
                    child: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {
                        // Toggle favorite status
                        context
                            .read<ProductsBloc>()
                            .add(ProductFavoriteToggled(p.id));
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            // Error state: show error message
            return Center(child: Text(l10n.failedToLoad));
          }
        },
      ),
    );
  }
}


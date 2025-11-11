import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/products/bloc/products_bloc.dart';
import '../features/cart/bloc/cart_bloc.dart';
import '../l10n/app_localizations.dart';
import '../utils/locale_storage.dart';
import '../widgets/cart_icon_with_badge.dart';
import '../widgets/expandable_product_tile.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';
import 'auth/login_register_screen.dart';
import '../main.dart' show AppWithLocaleState;

/// Main home screen displaying the list of products
/// Features: Product list, favorites, cart, language selection, logout
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load products and cart items when screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProductsBloc>().add(ProductsRequested());
        context.read<CartBloc>().add(CartRequested());
      }
    });
  }

  /// Shows a bottom sheet for language selection
  /// Updates app locale and saves preference
  static void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('العربية'), // Arabic
              onTap: () async {
                await LocaleStorage.write('ar');
                // Get the AppWithLocale state to update locale
                final appState = context.findAncestorStateOfType<AppWithLocaleState>();
                if (appState != null) {
                  appState.setLocale(const Locale('ar'));
                }
                if (!ctx.mounted) return;
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('English'),
              onTap: () async {
                await LocaleStorage.write('en');
                // Get the AppWithLocale state to update locale
                final appState = context.findAncestorStateOfType<AppWithLocaleState>();
                if (appState != null) {
                  appState.setLocale(const Locale('en'));
                }
                if (!ctx.mounted) return;
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.products),
        actions: [
          Tooltip(
            message: l10n.profile,
            child: IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ProfileScreen())),
            ),
          ),
          Tooltip(
            message: l10n.selectLanguage,
            child: IconButton(
              icon: const Icon(Icons.language),
              onPressed: () => _showLanguagePicker(context),
            ),
          ),
          Tooltip(
            message: l10n.viewFavorites,
            child: IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const FavoritesScreen())),
            ),
          ),
          Tooltip(
            message: l10n.logout,
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await context.read<AuthRepository>().logout();
                // reset blocs
                context.read<ProductsBloc>().add(ProductsRequested());
                if (!context.mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (_) => const LoginRegisterScreen()),
                    (r) => false);
              },
            ),
          ),
          const CartIconWithBadge(),
        ],
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          // Optimize loading state: show previous data while loading new data
          // This prevents flickering and improves UX during navigation
          if (state is ProductsLoading) {
            // Check if we have previous loaded state to maintain continuity
            final previousState = context.read<ProductsBloc>().state;
            if (previousState is ProductsLoaded) {
              // Display previous data while loading to prevent blank screen
              return ListView.builder(
                itemCount: previousState.products.length,
                itemBuilder: (ctx, i) {
                  final p = previousState.products[i];
                  final fav = previousState.favorites.contains(p.id);
                  return ExpandableProductTile(
                    product: p,
                    isFavorite: fav,
                  );
                },
              );
            }
            return const SizedBox.shrink();
          } else if (state is ProductsLoaded) {
            // Show empty state if no products available
            if (state.products.isEmpty) {
              return Center(child: Text(l10n.noProducts));
            }
            
            // Display products list with expandable tiles
            // Products are already sorted alphabetically by backend
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (ctx, i) {
                final p = state.products[i];
                final fav = state.favorites.contains(p.id);
                return ExpandableProductTile(
                  product: p,
                  isFavorite: fav,
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


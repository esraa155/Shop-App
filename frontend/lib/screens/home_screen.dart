import 'dart:async';
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
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _reloadTimer;

  @override
  void initState() {
    super.initState();

    // تحميل أولي للمنتجات وCart
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProductsBloc>().add(ProductsRequested());
        context.read<CartBloc>().add(CartRequested());
      }
    });

    // reload صامت كل ثانية
    _reloadTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        final productsBloc = context.read<ProductsBloc>();
        productsBloc.add(ProductsRequested(silent: true));
      }
    });
  }

  @override
  void dispose() {
    _reloadTimer?.cancel();
    super.dispose();
  }

  /// Bottom sheet لاختيار اللغة
  static void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('العربية'),
              onTap: () async {
                await LocaleStorage.write('ar');
                final appState =
                    context.findAncestorStateOfType<AppWithLocaleState>();
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
                final appState =
                    context.findAncestorStateOfType<AppWithLocaleState>();
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
          if (state is ProductsLoading) {
            final previousState = context.read<ProductsBloc>().state;
            if (previousState is ProductsLoaded) {
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
            if (state.products.isEmpty) {
              return Center(child: Text(l10n.noProducts));
            }

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
            return Center(child: Text(l10n.failedToLoad));
          }
        },
      ),
    );
  }
}

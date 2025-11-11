import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/cart/bloc/cart_bloc.dart';
import '../l10n/app_localizations.dart';
import '../screens/cart_screen.dart';

class CartIconWithBadge extends StatelessWidget {
  const CartIconWithBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
      int totalQuantity = 0;
      if (state is CartLoaded) {
        for (final it in state.items) {
          totalQuantity += it.quantity;
        }
      }
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Tooltip(
            message: l10n?.viewCart ?? 'View Cart',
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                if (context.mounted) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => const CartScreen()))
                      .then((_) {
                    if (context.mounted) {
                      context.read<CartBloc>().add(CartRequested());
                    }
                  });
                }
              },
            ),
          ),
          if (totalQuantity > 0)
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$totalQuantity',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      );
    });
  }
}


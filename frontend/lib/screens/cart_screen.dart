import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/cart/bloc/cart_bloc.dart';
import '../l10n/app_localizations.dart';
import 'payment_screen.dart';

/// Cart screen displaying user's shopping cart items
/// Features: View items, update quantities, remove items, checkout
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.cart)),
      body: BlocProvider.value(
        value: context.read<CartBloc>()..add(CartRequested()),
        child: BlocConsumer<CartBloc, CartState>(
          listener: (context, state) {
            // Show error messages if cart operations fail
            if (state is CartError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            // Optimize loading: show previous cart data while loading
            // Prevents blank screen during navigation
            if (state is CartLoading) {
              // Check if we have previous loaded state to maintain continuity
              final previousState = context.read<CartBloc>().state;
              if (previousState is CartLoaded) {
                // Display previous cart data while loading new data
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: previousState.items.length,
                        itemBuilder: (ctx, i) {
                          final item = previousState.items[i];
                          return Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                      item.product?.name ?? l10n.noProducts),
                                  subtitle: Text(
                                      '${l10n.qty}: ${item.quantity} • ${item.lineTotal.toStringAsFixed(2)}'),
                                ),
                              ),
                              Tooltip(
                                message: l10n.quantity + ' -',
                                child: IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    final newQty = item.quantity - 1;
                                    context.read<CartBloc>().add(newQty < 1
                                        ? CartRemovePressed(item.id)
                                        : CartUpdateQuantityPressed(
                                            item.id, newQty));
                                  },
                                ),
                              ),
                              Tooltip(
                                message: l10n.quantity + ' +',
                                child: IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () => context.read<CartBloc>().add(
                                      CartUpdateQuantityPressed(
                                          item.id, item.quantity + 1)),
                                ),
                              ),
                              Tooltip(
                                message: l10n.removeFromFavorites,
                                child: IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () => context
                                      .read<CartBloc>()
                                      .add(CartRemovePressed(item.id)),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Text(
                              '${l10n.subtotal}: ${previousState.subtotal.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          const Spacer(),
                          FilledButton(
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => const PaymentScreen())),
                            child: Text(l10n.checkout),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            }
            if (state is CartLoaded) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.items.length,
                      itemBuilder: (ctx, i) {
                        final item = state.items[i];
                        return Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                title:
                                    Text(item.product?.name ?? l10n.noProducts),
                                subtitle: Text(
                                    '${l10n.qty}: ${item.quantity} • ${item.lineTotal.toStringAsFixed(2)}'),
                              ),
                            ),
                            Tooltip(
                              message: l10n.quantity + ' -',
                              child: IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  final newQty = item.quantity - 1;
                                  context.read<CartBloc>().add(newQty < 1
                                      ? CartRemovePressed(item.id)
                                      : CartUpdateQuantityPressed(
                                          item.id, newQty));
                                },
                              ),
                            ),
                            Tooltip(
                              message: l10n.quantity + ' +',
                              child: IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () => context.read<CartBloc>().add(
                                    CartUpdateQuantityPressed(
                                        item.id, item.quantity + 1)),
                              ),
                            ),
                            Tooltip(
                              message: l10n.removeFromFavorites,
                              child: IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => context
                                    .read<CartBloc>()
                                    .add(CartRemovePressed(item.id)),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Text(
                            '${l10n.subtotal}: ${state.subtotal.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        const Spacer(),
                        FilledButton(
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => const PaymentScreen())),
                          child: Text(l10n.checkout),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return Center(child: Text(l10n.failedToLoadCart));
          },
        ),
      ),
    );
  }
}


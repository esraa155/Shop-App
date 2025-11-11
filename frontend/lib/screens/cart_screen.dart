import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/cart/bloc/cart_bloc.dart';
import '../l10n/app_localizations.dart';
import 'payment_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CartBloc>().add(CartRequested());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.cart)),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is CartLoading) {
            final previousState = context.read<CartBloc>().state;
            if (previousState is CartLoaded) {
              return _buildCartList(previousState, l10n);
            }
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CartLoaded) {
            return _buildCartList(state, l10n);
          }

          return Center(child: Text(l10n.failedToLoadCart));
        },
      ),
    );
  }

  Widget _buildCartList(CartLoaded state, AppLocalizations l10n) {
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
                      title: Text(item.product?.name ?? l10n.noProducts),
                      subtitle: Text(
                        '${l10n.qty}: ${item.quantity} • ${item.lineTotal.toStringAsFixed(2)}',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    tooltip: l10n.quantity + ' -',
                    onPressed: () {
                      final newQty = item.quantity - 1;
                      context.read<CartBloc>().add(
                            newQty < 1
                                ? CartRemovePressed(item.id)
                                : CartUpdateQuantityPressed(item.id, newQty),
                          );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    tooltip: l10n.quantity + ' +',
                    onPressed: () => context.read<CartBloc>().add(
                          CartUpdateQuantityPressed(item.id, item.quantity + 1),
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: l10n.removeFromFavorites,
                    onPressed: () => context
                        .read<CartBloc>()
                        .add(CartRemovePressed(item.id)),
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
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PaymentScreen()),
                ),
                child: Text(l10n.checkout),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

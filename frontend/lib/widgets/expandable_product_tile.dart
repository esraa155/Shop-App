import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/products/data/product_repository.dart';
import '../features/products/bloc/products_bloc.dart';
import '../features/cart/bloc/cart_bloc.dart';
import '../l10n/app_localizations.dart';
import 'quantity_picker.dart';

/// Expandable product tile widget that displays product information
/// and allows users to view details, add to cart, and manage favorites
/// Details are shown in the same page without navigation
class ExpandableProductTile extends StatefulWidget {
  final Product product;
  final bool isFavorite;

  const ExpandableProductTile({
    super.key,
    required this.product,
    required this.isFavorite,
  });

  @override
  State<ExpandableProductTile> createState() => _ExpandableProductTileState();
}

class _ExpandableProductTileState extends State<ExpandableProductTile> {
  /// Tracks whether the product details section is expanded
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final p = widget.product;
    final fav = widget.isFavorite;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Text(p.name.isNotEmpty ? p.name[0] : '?'),
            ),
            title: Text(p.name),
            subtitle: Text('${l10n.price}: ${p.price.toStringAsFixed(2)}'),
            trailing: Wrap(
              spacing: 8,
              children: [
                Tooltip(
                  message: fav ? l10n.removeFromFavorites : l10n.addToFavorites,
                  child: IconButton(
                    icon: Icon(
                      fav ? Icons.favorite : Icons.favorite_border,
                      color: fav ? Colors.red : null,
                    ),
                    onPressed: () => context
                        .read<ProductsBloc>()
                        .add(ProductFavoriteToggled(p.id)),
                  ),
                ),
                Tooltip(
                  message: _isExpanded ? l10n.hideDetails : l10n.showDetails,
                  child: IconButton(
                    icon: Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                    ),
                    onPressed: () {
                      setState(() => _isExpanded = !_isExpanded);
                    },
                  ),
                ),
              ],
            ),
            onTap: () {
              setState(() => _isExpanded = !_isExpanded);
            },
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (p.category != null && p.category!.isNotEmpty) ...[
                    Row(
                      children: [
                        Icon(Icons.category, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Text(
                          '${l10n.category}: ${p.category}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (p.description != null && p.description!.isNotEmpty) ...[
                    Text(
                      l10n.description,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      p.description!,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (p.specifications != null &&
                      p.specifications!.isNotEmpty) ...[
                    Text(
                      l10n.specifications,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      p.specifications!,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Row(
                    children: [
                      Icon(Icons.inventory, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        '${l10n.stock}: ${p.stock}',
                        style: TextStyle(
                          color: p.stock > 0 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Tooltip(
                          message: p.stock <= 0
                              ? l10n.outOfStock
                              : l10n.addToCart,
                          child: FilledButton.icon(
                            onPressed: p.stock <= 0
                                ? null
                                : () async {
                                    // Validate stock availability before adding to cart
                                    if (p.stock <= 0) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              l10n.cannotPurchaseOutOfStock),
                                          duration: const Duration(
                                              milliseconds: 2000),
                                        ),
                                      );
                                      return;
                                    }
                                    
                                    // Add product to cart with quantity 1
                                    context
                                        .read<CartBloc>()
                                        .add(CartAddPressed(p.id, qty: 1));
                                    
                                    // Wait for cart update to complete
                                    await Future.delayed(
                                        const Duration(milliseconds: 300));
                                    
                                    // Refresh cart to get updated count
                                    if (context.mounted) {
                                      context
                                          .read<CartBloc>()
                                          .add(CartRequested());
                                    }
                                    
                                    if (!context.mounted) return;
                                    
                                    // Show success message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(l10n.addedToCart),
                                        duration:
                                            const Duration(milliseconds: 800),
                                      ),
                                    );
                                  },
                            icon: const Icon(Icons.add_shopping_cart),
                            label: Text(p.stock <= 0
                                ? l10n.outOfStock
                                : l10n.addToCart),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Tooltip(
                        message: p.stock <= 0
                            ? l10n.outOfStock
                            : l10n.quantity,
                        child: IconButton(
                          icon: const Icon(Icons.tune),
                          onPressed: p.stock <= 0
                              ? null
                              : () async {
                                  if (p.stock <= 0) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            l10n.cannotPurchaseOutOfStock),
                                        duration: const Duration(
                                            milliseconds: 2000),
                                      ),
                                    );
                                    return;
                                  }
                                  // Get current quantity in cart for this product
                                  int currentQty = 0;
                                  final cartState =
                                      context.read<CartBloc>().state;
                                  if (cartState is CartLoaded) {
                                    try {
                                      final existingItem = cartState.items
                                          .firstWhere(
                                        (item) => item.product?.id == p.id,
                                      );
                                      currentQty = existingItem.quantity;
                                    } catch (e) {
                                      // Product not in cart yet
                                      currentQty = 0;
                                    }
                                  }

                                  // Show quantity picker dialog with stock limit
                                  final qty = await pickQuantity(
                                    context,
                                    initialQty: currentQty > 0 ? currentQty : 1,
                                    maxQty: p.stock,
                                  );
                                  
                                  if (qty != null && qty > 0) {
                                    // Validate selected quantity against stock
                                    if (qty > p.stock) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              '${l10n.stock}: ${p.stock}'),
                                          duration: const Duration(
                                              milliseconds: 2000),
                                        ),
                                      );
                                      return;
                                    }
                                    
                                    // Calculate quantity difference to add
                                    final qtyToAdd = currentQty > 0
                                        ? (qty - currentQty)
                                        : qty;
                                    
                                    if (qtyToAdd != 0) {
                                      // Add or update quantity in cart
                                      context.read<CartBloc>().add(
                                          CartAddPressed(p.id, qty: qtyToAdd));
                                      
                                      // Wait for cart update
                                      await Future.delayed(
                                          const Duration(milliseconds: 300));
                                      
                                      // Refresh cart state
                                      if (context.mounted) {
                                        context
                                            .read<CartBloc>()
                                            .add(CartRequested());
                                      }
                                      
                                      if (!context.mounted) return;
                                      
                                      // Show success message
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(qtyToAdd > 0
                                              ? l10n.addedQtyToCartWith(
                                                  qtyToAdd)
                                              : 'Quantity updated to $qty'),
                                          duration: const Duration(
                                              milliseconds: 900),
                                        ),
                                      );
                                    }
                                  }
                                },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}


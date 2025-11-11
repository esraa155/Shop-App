import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

/// Shows a dialog for selecting product quantity
/// 
/// [context] - Build context for showing the dialog
/// [initialQty] - Starting quantity value (default: 1)
/// [maxQty] - Maximum allowed quantity based on stock (optional)
/// 
/// Returns the selected quantity or null if cancelled
Future<int?> pickQuantity(
  BuildContext context, {
  int initialQty = 1,
  int? maxQty,
}) async {
  int q = initialQty;
  final l10n = AppLocalizations.of(context)!;
  
  return showDialog<int>(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(l10n.quantity),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Quantity selector with increment/decrement buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        // Decrease quantity but not below 1
                        if (q > 1) {
                          setState(() => q -= 1);
                        }
                      },
                    ),
                    Text('$q', style: const TextStyle(fontSize: 18)),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        // Increase quantity but not above maxQty if specified
                        if (maxQty == null || q < maxQty) {
                          setState(() => q += 1);
                        }
                      },
                    ),
                  ],
                ),
                // Display stock limit if provided
                if (maxQty != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${l10n.stock}: $maxQty',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, q),
                child: Text(l10n.add),
              ),
            ],
          );
        },
      );
    },
  );
}


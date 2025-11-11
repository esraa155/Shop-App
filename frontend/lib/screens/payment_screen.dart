import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/cart/bloc/cart_bloc.dart';
import '../l10n/app_localizations.dart';

/// Payment screen for processing orders
/// Handles shipping information and payment method selection
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Controller for card number input with automatic formatting
  final _cardNumberController = TextEditingController();

  // Payment method: 'cod' for cash on delivery, 'card' for credit/debit card
  String _paymentMethod = 'cod';

  // Shipping information fields
  String _fullName = '';
  String _phoneNumber = '';
  String _city = '';
  String _street = '';
  String _building = '';

  // Card payment fields
  String _cardNumber = '';
  String? _expiryMonth;
  String? _expiryYear;
  String _cvv = '';
  String _cardHolderName = '';

  @override
  void dispose() {
    // Clean up controller to prevent memory leaks
    _cardNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.payment)),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          final subtotal = state is CartLoaded ? state.subtotal : 0.0;
          final isLoading = false;

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ========== Shipping Information Section ==========
                Text(l10n.shippingAddress,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: l10n.fullName,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.person)),
                  onChanged: (v) => _fullName = v,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? l10n.required : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: l10n.phoneNumber,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.phone)),
                  keyboardType: TextInputType.phone,
                  onChanged: (v) => _phoneNumber = v,
                  validator: (v) {
                    if (v == null || v.isEmpty) return l10n.required;
                    if (v.length < 10) return l10n.invalidPhone;
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: l10n.city,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.location_city)),
                  onChanged: (v) => _city = v,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? l10n.required : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: l10n.street,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.streetview)),
                  onChanged: (v) => _street = v,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? l10n.required : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: l10n.building,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.home)),
                  onChanged: (v) => _building = v,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? l10n.required : null,
                ),
                const SizedBox(height: 24),
                // ========== Payment Method Section ==========
                Text(l10n.paymentMethod,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _paymentMethod,
                  items: [
                    DropdownMenuItem(
                        value: 'cod', child: Text(l10n.cashOnDelivery)),
                    DropdownMenuItem(
                        value: 'card', child: Text(l10n.creditDebitCard)),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _paymentMethod = v);
                  },
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                ),
                // ========== Card Payment Details Section ==========
                // Only show card details when card payment is selected
                if (_paymentMethod == 'card') ...[
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _cardNumberController,
                    decoration: InputDecoration(
                        labelText: l10n.cardNumber,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.credit_card)),
                    keyboardType: TextInputType.number,
                    maxLength: 16,
                    onChanged: (v) {
                      // Filter out non-digit characters and enforce 16-digit limit
                      final digitsOnly = v.replaceAll(RegExp(r'[^0-9]'), '');
                      if (digitsOnly.length <= 16) {
                        _cardNumber = digitsOnly;
                        // Update controller if text doesn't match filtered value
                        if (_cardNumberController.text != digitsOnly) {
                          _cardNumberController.value = TextEditingValue(
                            text: digitsOnly,
                            selection: TextSelection.collapsed(
                                offset: digitsOnly.length),
                          );
                        }
                      } else {
                        // Revert to previous valid value if exceeds limit
                        _cardNumberController.value = TextEditingValue(
                          text: _cardNumber,
                          selection: TextSelection.collapsed(
                              offset: _cardNumber.length),
                        );
                      }
                    },
                    validator: (v) {
                      if (v == null || v.isEmpty) return l10n.required;
                      if (v.length < 16) return 'Card number must be 16 digits';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  // Expiry Date and CVV in a single row with better layout
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Expiry Date Section (Month + Year)
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.expiryDate,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      labelText: 'Month',
                                      border: const OutlineInputBorder(),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 16,
                                      ),
                                    ),
                                    value: _expiryMonth,
                                    items: List.generate(12, (index) {
                                      final month = (index + 1)
                                          .toString()
                                          .padLeft(2, '0');
                                      return DropdownMenuItem(
                                        value: month,
                                        child: Text(month),
                                      );
                                    }),
                                    onChanged: (v) {
                                      setState(() {
                                        _expiryMonth = v;
                                        // Reset year when month changes to prevent invalid dates
                                        _expiryYear = null;
                                      });
                                    },
                                    validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return 'Required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      labelText: 'Year',
                                      border: const OutlineInputBorder(),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 16,
                                      ),
                                    ),
                                    value: _expiryYear,
                                    items: () {
                                      final items =
                                          <DropdownMenuItem<String>>[];
                                      final currentYear = DateTime.now().year;
                                      final currentMonth = DateTime.now().month;

                                      // Filter years based on selected month
                                      if (_expiryMonth != null) {
                                        final selectedMonth =
                                            int.parse(_expiryMonth!);
                                        // If selected month is in the past, start from next year
                                        final startYear =
                                            (selectedMonth < currentMonth)
                                                ? currentYear + 1
                                                : currentYear;

                                        for (int yearOffset = 0;
                                            yearOffset < 20;
                                            yearOffset++) {
                                          final year = (startYear + yearOffset)
                                              .toString()
                                              .substring(2);
                                          items.add(DropdownMenuItem(
                                            value: year,
                                            child: Text(year),
                                          ));
                                        }
                                      } else {
                                        // Show all years from current if no month selected
                                        for (int yearOffset = 0;
                                            yearOffset < 20;
                                            yearOffset++) {
                                          final year =
                                              (currentYear + yearOffset)
                                                  .toString()
                                                  .substring(2);
                                          items.add(DropdownMenuItem(
                                            value: year,
                                            child: Text(year),
                                          ));
                                        }
                                      }
                                      return items;
                                    }(),
                                    onChanged: (v) =>
                                        setState(() => _expiryYear = v),
                                    validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return 'Required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // CVV Section
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: l10n.cvv,
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.lock),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          maxLength: 3,
                          onChanged: (v) => _cvv = v,
                          validator: (v) {
                            if (v == null || v.isEmpty) return l10n.required;
                            if (v.length < 3) return 'Invalid CVV';
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: l10n.cardHolderName,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.person_outline)),
                    onChanged: (v) => _cardHolderName = v,
                    validator: (v) {
                      if (_paymentMethod == 'card' && (v == null || v.isEmpty))
                        return l10n.required;
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 24),
                // ========== Order Summary Section ==========
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order Summary',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      if (state is CartLoaded)
                        ...state.items.map((item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.product?.name ?? 'Unknown',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  Text(
                                    '${item.quantity} x ${item.product?.price.toStringAsFixed(2) ?? '0.00'}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            )),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(l10n.subtotal,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                          Text(subtotal.toStringAsFixed(2),
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(l10n.total,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700)),
                          Text(subtotal.toStringAsFixed(2),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Tooltip(
                  message: l10n.payNow,
                  child: FilledButton.icon(
                    onPressed: isLoading
                        ? null
                        : () async {
                            // Validate form before submission
                            if (!_formKey.currentState!.validate()) return;

                            // Process checkout through cart bloc
                            context.read<CartBloc>().add(CartCheckoutPressed());

                            if (!context.mounted) return;

                            // Show success message
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(l10n.paymentSuccessful)));

                            // Navigate back to cart screen
                            Navigator.of(context).pop();
                          },
                    icon: const Icon(Icons.lock),
                    label: Text(isLoading ? l10n.pleaseWait : l10n.payNow),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../core/app_localizations.dart';
import '../providers/app_state.dart';
import '../widgets/common_header.dart';

class CartCheckoutScreen extends StatelessWidget {
  const CartCheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isAr = context.isAr;

    return Scaffold(
      appBar: AlEuroAppBar(title: context.tr('cart_title')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (state.cart.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  children: [
                    const Icon(Icons.shopping_bag_outlined, size: 48, color: AlEuroColors.warmGray),
                    const SizedBox(height: 12),
                    Text(context.tr('cart_empty'), style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ),
            )
          else ...[
            ...state.cart.map(
              (item) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  title: Text(item.part.getName(isAr), style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${item.part.price.toStringAsFixed(0)} ${context.tr('currency')} • OEM: ${item.part.oemNumber}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => state.updateCartQuantity(item.part.id, -1),
                      ),
                      Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () => state.updateCartQuantity(item.part.id, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _priceRow(context.tr('subtotal'), '${state.cartSubtotal.toStringAsFixed(0)} ${context.tr('currency')}'),
                    const SizedBox(height: 8),
                    _priceRow(context.tr('shipping'), '35 ${context.tr('currency')}'),
                    const Divider(height: 24),
                    _priceRow(
                      context.tr('total'),
                      '${(state.cartSubtotal + 35).toStringAsFixed(0)} ${context.tr('currency')}',
                      isBold: true,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => state.placeOrder(),
                      child: Text(context.tr('checkout_btn')),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),

          // قسم تتبع الطلب المباشر (Order Tracking Stepper)
          Text(context.tr('order_tracking'), style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('#EU-8842 • Mercedes-Benz E-Class Parts', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildTrackingStep(context, 0, context.tr('step_placed'), state.activeOrderStep >= 0),
                  _buildTrackingStep(context, 1, context.tr('step_processing'), state.activeOrderStep >= 1),
                  _buildTrackingStep(context, 2, context.tr('step_shipping'), state.activeOrderStep >= 2),
                  _buildTrackingStep(context, 3, context.tr('step_delivered'), state.activeOrderStep >= 3, isLast: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String val, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text(
          val,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isBold ? 18 : 14,
            color: isBold ? AlEuroColors.ivory : AlEuroColors.warmGray,
          ),
        ),
      ],
    );
  }

  Widget _buildTrackingStep(BuildContext context, int index, String title, bool isCompleted, {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted ? AlEuroColors.burgundy : AlEuroColors.darkGray,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, size: 14, color: AlEuroColors.ivory),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 28,
                color: isCompleted ? AlEuroColors.burgundy : AlEuroColors.darkGray,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
              color: isCompleted ? AlEuroColors.ivory : AlEuroColors.warmGray,
            ),
          ),
        ),
      ],
    );
  }
}

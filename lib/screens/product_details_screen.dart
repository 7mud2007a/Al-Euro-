import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../core/app_localizations.dart';
import '../models/models.dart';
import '../providers/app_state.dart';
import '../widgets/common_header.dart';
import 'exchange_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  final SparePart part;
  const ProductDetailsScreen({super.key, required this.part});

  @override
  Widget build(BuildContext context) {
    final isAr = context.isAr;
    final state = context.watch<AppState>();

    return Scaffold(
      appBar: AlEuroAppBar(title: part.getName(isAr), showBack: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. سلايدر الصور
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 240,
              color: AlEuroColors.black,
              child: Image.network(
                part.imageUrls.first,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(Icons.build_circle_outlined, size: 70, color: AlEuroColors.warmGray),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // 2. العنوان والسعر والتوفر
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  part.getName(isAr),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AlEuroColors.burgundy,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${part.price.toStringAsFixed(0)} ${context.tr('currency')}',
                  style: const TextStyle(
                    color: AlEuroColors.ivory,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(part.getDescription(isAr), style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 20),

          // 3. جدول المواصفات الفنية (OEM، الشركة، الضمان)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _specRow(context.tr('oem_number'), part.oemNumber),
                  const Divider(),
                  _specRow(context.tr('manufacturer'), part.manufacturer),
                  const Divider(),
                  _specRow(context.tr('warranty'), part.getWarranty(isAr)),
                  const Divider(),
                  _specRow(
                    context.tr('condition'),
                    part.inStock ? context.tr('in_stock') : context.tr('out_of_stock'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),

          // 4. السيارات المتوافقة (Compatible Vehicles)
          Text(context.tr('compatible_vehicles'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: part.compatibleCars
                .map(
                  (c) => Chip(
                    backgroundColor: AlEuroColors.black,
                    side: const BorderSide(color: AlEuroColors.darkGray),
                    avatar: const Icon(Icons.check_circle_outline, size: 16, color: AlEuroColors.ivory),
                    label: Text(c.toString(), style: const TextStyle(color: AlEuroColors.ivory, fontSize: 12)),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 30),

          // 5. أزرار الإجراءات (Add to Cart & Request Exchange)
          ElevatedButton.icon(
            onPressed: part.inStock
                ? () {
                    state.addToCart(part);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AlEuroColors.burgundy,
                        content: Text(context.tr('added_to_cart')),
                      ),
                    );
                  }
                : null,
            icon: const Icon(Icons.shopping_bag_outlined),
            label: Text(context.tr('add_to_cart')),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ExchangeScreen(prefilledPart: part)),
              );
            },
            icon: const Icon(Icons.swap_horiz_rounded),
            label: Text(context.tr('request_exchange')),
          ),
        ],
      ),
    );
  }

  Widget _specRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AlEuroColors.warmGray, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}

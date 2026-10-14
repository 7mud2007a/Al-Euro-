import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../core/app_localizations.dart';
import '../models/models.dart';
import '../providers/app_state.dart';
import '../screens/product_details_screen.dart';

class ProductCard extends StatelessWidget {
  final SparePart part;
  const ProductCard({super.key, required this.part});

  String _conditionLabel(BuildContext context, PartCondition c) {
    switch (c) {
      case PartCondition.newPart:
        return context.tr('cond_new');
      case PartCondition.used:
        return context.tr('cond_used');
      case PartCondition.original:
        return context.tr('cond_original');
      case PartCondition.aftermarket:
        return context.tr('cond_aftermarket');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = context.isAr;
    final state = context.watch<AppState>();

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductDetailsScreen(part: part)),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // صورة القطعة + شارة الحالة + زر المفضلة
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      color: AlEuroColors.charcoal,
                      child: Image.network(
                        part.imageUrls.first,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.settings_suggest_outlined,
                          size: 48,
                          color: AlEuroColors.warmGray,
                        ),
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    top: 8,
                    start: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AlEuroColors.black.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AlEuroColors.darkGray, width: 0.8),
                      ),
                      child: Text(
                        _conditionLabel(context, part.condition),
                        style: const TextStyle(color: AlEuroColors.ivory, fontSize: 10),
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    top: 4,
                    end: 4,
                    child: IconButton(
                      icon: Icon(
                        state.favoriteIds.contains(part.id)
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        color: state.favoriteIds.contains(part.id)
                            ? AlEuroColors.burgundy
                            : AlEuroColors.ivory,
                      ),
                      onPressed: () => state.toggleFavorite(part.id),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                '${part.manufacturer} • OEM: ${part.oemNumber}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11),
              ),
              const SizedBox(height: 4),
              Text(
                part.getName(isAr),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14, height: 1.25),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // إبراز السعر بلون الـ Burgundy الفاخر أو الـ Ivory الواضح
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AlEuroColors.burgundy.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AlEuroColors.burgundy, width: 1),
                    ),
                    child: Text(
                      '${part.price.toStringAsFixed(0)} ${context.tr('currency')}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: AlEuroColors.ivory,
                      ),
                    ),
                  ),
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: part.inStock ? AlEuroColors.burgundy : AlEuroColors.darkGray,
                      foregroundColor: AlEuroColors.ivory,
                      minimumSize: const Size(38, 38),
                    ),
                    onPressed: part.inStock
                        ? () {
                            state.addToCart(part);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: AlEuroColors.burgundy,
                                content: Text(
                                  context.tr('added_to_cart'),
                                  style: const TextStyle(color: AlEuroColors.ivory),
                                ),
                              ),
                            );
                          }
                        : null,
                    icon: const Icon(Icons.add_shopping_cart_rounded, size: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

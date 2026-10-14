import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../core/app_localizations.dart';
import '../data/mock_data.dart';
import '../providers/app_state.dart';
import '../widgets/common_header.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onNavigateToParts;
  const HomeScreen({super.key, required this.onNavigateToParts});

  static const List<Map<String, dynamic>> _quickCategories = [
    {'key': 'cat_engine', 'icon': Icons.engineering_outlined},
    {'key': 'cat_brakes', 'icon': Icons.album_outlined},
    {'key': 'cat_suspension', 'icon': Icons.LinearScale},
    {'key': 'cat_electrical', 'icon': Icons.bolt_outlined},
    {'key': 'cat_filters', 'icon': Icons.filter_alt_outlined},
    {'key': 'cat_oils', 'icon': Icons.water_drop_outlined},
    {'key': 'cat_tires', 'icon': Icons.tire_repair_outlined},
    {'key': 'cat_accessories', 'icon': Icons.auto_awesome_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final featured = MockData.parts.where((p) => p.isFeatured).toList();
    final bestSellers = MockData.parts.where((p) => p.isBestSeller).toList();

    return Scaffold(
      appBar: const AlEuroAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. شريط البحث العلوي
          TextField(
            onChanged: (q) {
              state.setSearchQuery(q);
            },
            onSubmitted: (_) => onNavigateToParts(),
            decoration: InputDecoration(
              hintText: context.tr('search_hint'),
              prefixIcon: const Icon(Icons.search, color: AlEuroColors.warmGray),
              suffixIcon: IconButton(
                icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AlEuroColors.warmGray),
                onPressed: onNavigateToParts,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // 2. شريط "سيارتي في الكراج" للتوافق السريع
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AlEuroColors.black,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AlEuroColors.darkGray),
            ),
            child: Row(
              children: [
                const Icon(Icons.directions_car_outlined, color: AlEuroColors.ivory),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr('my_garage_active'),
                        style: const TextStyle(color: AlEuroColors.warmGray, fontSize: 11),
                      ),
                      Text(
                        state.savedGarageCar?.toString() ?? context.tr('no_car_selected'),
                        style: const TextStyle(color: AlEuroColors.ivory, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    state.toggleFilterByMyGarageCar(true);
                    onNavigateToParts();
                  },
                  child: Text(
                    context.tr('my_car_only'),
                    style: const TextStyle(color: AlEuroColors.ivory, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 3. كاروسيل العروض الترويجية (Promo Banner Carousel)
          SizedBox(
            height: 148,
            child: PageView(
              children: [
                _buildPromoCard(
                  context,
                  title: context.tr('promo_title_1'),
                  subtitle: context.tr('promo_sub_1'),
                  tag: 'OEM GARANTIE',
                ),
                _buildPromoCard(
                  context,
                  title: context.tr('promo_title_2'),
                  subtitle: context.tr('promo_sub_2'),
                  tag: 'EXCHANGE PRO',
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // 4. التصنيفات السريعة الـ 8 (Quick Categories)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.tr('categories'), style: Theme.of(context).textTheme.titleLarge),
              TextButton(
                onPressed: () {
                  state.setCategory('cat_all');
                  onNavigateToParts();
                },
                child: Text(context.tr('view_all'), style: const TextStyle(color: AlEuroColors.warmGray)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _quickCategories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.95,
            ),
            itemBuilder: (context, index) {
              final cat = _quickCategories[index];
              final key = cat['key'] as String;
              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  state.setCategory(key);
                  onNavigateToParts();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AlEuroColors.black,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AlEuroColors.darkGray, width: 0.8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(cat['icon'] as IconData, color: AlEuroColors.ivory, size: 26),
                      const SizedBox(height: 6),
                      Text(
                        context.tr(key),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 11, color: AlEuroColors.ivory),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // 5. القطع المميزة (Featured Parts)
          Text(context.tr('featured_parts'), style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          SizedBox(
            height: 265,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: featured.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) => SizedBox(
                width: 200,
                child: ProductCard(part: featured[index]),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 6. الأكثر مبيعاً (Best Sellers)
          Text(context.tr('best_sellers'), style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: bestSellers.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.68,
            ),
            itemBuilder: (context, i) => ProductCard(part: bestSellers[i]),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCard(BuildContext context, {required String title, required String subtitle, required String tag}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AlEuroColors.black, AlEuroColors.charcoal],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AlEuroColors.darkGray, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: AlEuroColors.burgundy,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              tag,
              style: const TextStyle(color: AlEuroColors.ivory, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
          ),
          const SizedBox(height: 10),
          Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
          const SizedBox(height: 6),
          Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../core/app_localizations.dart';
import '../providers/app_state.dart';
import '../widgets/common_header.dart';
import '../widgets/product_card.dart';
import '../widgets/filter_bottom_sheet.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final filteredParts = state.computeFilteredParts();

    return Scaffold(
      appBar: AlEuroAppBar(title: context.tr('nav_parts')),
      body: Column(
        children: [
          // شريط البحث + زر فتح نافذة الفلترة السفلية
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: state.setSearchQuery,
                    decoration: InputDecoration(
                      hintText: context.tr('search_hint'),
                      prefixIcon: const Icon(Icons.search, color: AlEuroColors.warmGray),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(110, 50),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const FilterBottomSheet(),
                    );
                  },
                  icon: const Icon(Icons.tune_rounded, size: 18),
                  label: Text(context.tr('filter_btn')),
                ),
              ],
            ),
          ),

          // شريط الفلاتر المختارة كشرائح قابلة للإزالة (Removable Filter Chips + My Car Toggle)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                if (state.savedGarageCar != null)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: FilterChip(
                      selected: state.filterByMyGarageCar,
                      selectedColor: AlEuroColors.burgundy,
                      backgroundColor: AlEuroColors.black,
                      checkmarkColor: AlEuroColors.ivory,
                      label: Text(
                        '${context.tr('my_car_only')} (${state.savedGarageCar!.model})',
                        style: TextStyle(
                          color: state.filterByMyGarageCar ? AlEuroColors.ivory : AlEuroColors.warmGray,
                          fontSize: 12,
                        ),
                      ),
                      onSelected: (val) => state.toggleFilterByMyGarageCar(val),
                    ),
                  ),
                if (state.selectedBrand != null)
                  _removableChip(
                    label: '${state.selectedBrand} ${state.selectedModel ?? ''} ${state.selectedYear ?? ''}',
                    onDeleted: () => state.clearSingleFilter('car'),
                  ),
                if (state.selectedCategory != 'cat_all')
                  _removableChip(
                    label: context.tr(state.selectedCategory),
                    onDeleted: () => state.clearSingleFilter('category'),
                  ),
                if (state.selectedCondition != null)
                  _removableChip(
                    label: state.selectedCondition!.name.toUpperCase(),
                    onDeleted: () => state.clearSingleFilter('condition'),
                  ),
                if (state.selectedManufacturer != null)
                  _removableChip(
                    label: state.selectedManufacturer!,
                    onDeleted: () => state.clearSingleFilter('manufacturer'),
                  ),
                if (state.inStockOnly)
                  _removableChip(
                    label: context.tr('in_stock_only'),
                    onDeleted: () => state.clearSingleFilter('stock'),
                  ),
              ],
            ),
          ),

          // شبكة عرض القطع المطابقة
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredParts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.68,
              ),
              itemBuilder: (context, index) => ProductCard(part: filteredParts[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _removableChip({required String label, required VoidCallback onDeleted}) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: InputChip(
        label: Text(label, style: const TextStyle(color: AlEuroColors.ivory, fontSize: 12)),
        backgroundColor: AlEuroColors.burgundy,
        deleteIconColor: AlEuroColors.ivory,
        onDeleted: onDeleted,
      ),
    );
  }
}

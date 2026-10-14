import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../core/app_localizations.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../providers/app_state.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? _brand;
  String? _model;
  int? _year;
  String _category = 'cat_all';
  PartCondition? _condition;
  RangeValues _priceRange = const RangeValues(0, 3000);
  String? _manufacturer;
  bool _inStockOnly = false;
  String _sortBy = 'sort_newest';

  @override
  void initState() {
    super.initState();
    final s = context.read<AppState>();
    _brand = s.selectedBrand;
    _model = s.selectedModel;
    _year = s.selectedYear;
    _category = s.selectedCategory;
    _condition = s.selectedCondition;
    _priceRange = s.priceRange;
    _manufacturer = s.selectedManufacturer;
    _inStockOnly = s.inStockOnly;
    _sortBy = s.sortBy;
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final liveResultsCount = state
        .computeFilteredParts(
          brand: _brand,
          model: _model,
          year: _year,
          category: _category,
          condition: _condition,
          price: _priceRange,
          manufacturer: _manufacturer,
          stockOnly: _inStockOnly,
          sort: _sortBy,
        )
        .length;

    final modelsForBrand = _brand != null
        ? MockData.carHierarchy[_brand]!.keys.toList()
        : <String>[];
    final yearsForModel = (_brand != null && _model != null)
        ? MockData.carHierarchy[_brand]![_model]!
        : <int>[];

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      maxChildSize: 0.95,
      minChildSize: 0.6,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border.all(color: AlEuroColors.darkGray, width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: AlEuroColors.warmGray,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(context.tr('filter_btn'), style: Theme.of(context).textTheme.titleLarge),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _brand = null;
                        _model = null;
                        _year = null;
                        _category = 'cat_all';
                        _condition = null;
                        _priceRange = const RangeValues(0, 3000);
                        _manufacturer = null;
                        _inStockOnly = false;
                        _sortBy = 'sort_newest';
                      });
                    },
                    child: Text(
                      context.tr('reset'),
                      style: const TextStyle(color: AlEuroColors.warmGray),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    // 1. القوائم المنسدلة المتسلسلة (Cascading Dropdowns: Brand -> Model -> Year)
                    Text(context.tr('car_brand'), style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _brand,
                      hint: Text(context.tr('car_brand')),
                      items: MockData.carHierarchy.keys
                          .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          _brand = val;
                          _model = null;
                          _year = null;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _model,
                            hint: Text(context.tr('car_model')),
                            items: modelsForBrand
                                .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                                .toList(),
                            onChanged: _brand == null
                                ? null
                                : (val) {
                                    setState(() {
                                      _model = val;
                                      _year = null;
                                    });
                                  },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: _year,
                            hint: Text(context.tr('car_year')),
                            items: yearsForModel
                                .map((y) => DropdownMenuItem(value: y, child: Text('$y')))
                                .toList(),
                            onChanged: _model == null
                                ? null
                                : (val) => setState(() => _year = val),
                          ),
                        ),
                      ],
                    ),
                    if (_brand != null && _model != null && _year != null) ...[
                      const SizedBox(height: 8),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: TextButton.icon(
                          onPressed: () {
                            state.saveGarageCar(
                              GarageCar(brand: _brand!, model: _model!, year: _year!),
                            );
                          },
                          icon: const Icon(Icons.garage_outlined, color: AlEuroColors.ivory, size: 18),
                          label: Text(
                            context.tr('add_car_to_garage'),
                            style: const TextStyle(color: AlEuroColors.ivory, fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),

                    // 2. حالة القطعة (Condition Chips)
                    Text(context.tr('condition'), style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildConditionChip(PartCondition.newPart, context.tr('cond_new')),
                        _buildConditionChip(PartCondition.original, context.tr('cond_original')),
                        _buildConditionChip(PartCondition.used, context.tr('cond_used')),
                        _buildConditionChip(PartCondition.aftermarket, context.tr('cond_aftermarket')),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // 3. نطاق السعر (Price Range Slider)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(context.tr('price_range'), style: Theme.of(context).textTheme.titleMedium),
                        Text(
                          '${_priceRange.start.round()} - ${_priceRange.end.round()} ${context.tr('currency')}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    RangeSlider(
                      values: _priceRange,
                      min: 0,
                      max: 3000,
                      divisions: 30,
                      activeColor: AlEuroColors.burgundy,
                      inactiveColor: AlEuroColors.darkGray,
                      onChanged: (values) => setState(() => _priceRange = values),
                    ),
                    const SizedBox(height: 12),

                    // 4. الشركة المصنعة (Part Manufacturer Brand)
                    Text(context.tr('manufacturer'), style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: MockData.manufacturers.map((m) {
                        final selected = _manufacturer == m;
                        return ChoiceChip(
                          label: Text(m),
                          selected: selected,
                          selectedColor: AlEuroColors.burgundy,
                          backgroundColor: AlEuroColors.black,
                          labelStyle: TextStyle(
                            color: selected ? AlEuroColors.ivory : AlEuroColors.warmGray,
                          ),
                          onSelected: (val) => setState(() => _manufacturer = val ? m : null),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // 5. التوفر في المخزون فقط (Availability)
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(context.tr('in_stock_only')),
                      activeColor: AlEuroColors.burgundy,
                      value: _inStockOnly,
                      onChanged: (val) => setState(() => _inStockOnly = val),
                    ),
                    const SizedBox(height: 12),

                    // 6. الترتيب حسب (Sort By)
                    Text(context.tr('sort_by'), style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _sortBy,
                      items: [
                        DropdownMenuItem(value: 'sort_newest', child: Text(context.tr('sort_newest'))),
                        DropdownMenuItem(value: 'sort_best_selling', child: Text(context.tr('sort_best_selling'))),
                        DropdownMenuItem(value: 'sort_price_low', child: Text(context.tr('sort_price_low'))),
                        DropdownMenuItem(value: 'sort_price_high', child: Text(context.tr('sort_price_high'))),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _sortBy = val);
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              // زر التطبيق مع عداد النتائج الحي (Apply with Live Results Count)
              ElevatedButton(
                onPressed: () {
                  state.updateFilters(
                    brand: _brand,
                    model: _model,
                    year: _year,
                    category: _category,
                    condition: _condition,
                    priceRange: _priceRange,
                    manufacturer: _manufacturer,
                    inStockOnly: _inStockOnly,
                    sortBy: _sortBy,
                  );
                  Navigator.pop(context);
                },
                child: Text(
                  context.tr('apply_results', params: {'count': '$liveResultsCount'}),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConditionChip(PartCondition cond, String label) {
    final isSelected = _condition == cond;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AlEuroColors.burgundy, // Burgundy exclusively for selected filter chips
      backgroundColor: AlEuroColors.black,
      labelStyle: TextStyle(
        color: isSelected ? AlEuroColors.ivory : AlEuroColors.warmGray,
      ),
      onSelected: (val) => setState(() => _condition = val ? cond : null),
    );
  }
}

class GarageCar {
  final String brand;
  final String model;
  final int year;

  const GarageCar({required this.brand, required this.model, required this.year});

  @override
  String toString() => '$brand $model ($year)';

  bool matches(String? filterBrand, String? filterModel, int? filterYear) {
    if (filterBrand != null && filterBrand != brand) return false;
    if (filterModel != null && filterModel != model) return false;
    if (filterYear != null && filterYear != year) return false;
    return true;
  }
}

enum PartCondition { newPart, used, original, aftermarket }

class SparePart {
  final String id;
  final String nameAr;
  final String nameEn;
  final String categoryKey; // e.g., cat_brakes, cat_engine
  final String descriptionAr;
  final String descriptionEn;
  final String oemNumber;
  final String manufacturer;
  final PartCondition condition;
  final double price;
  final bool inStock;
  final String warrantyAr;
  final String warrantyEn;
  final List<GarageCar> compatibleCars;
  final List<String> imageUrls;
  final bool isFeatured;
  final bool isBestSeller;
  final DateTime createdAt;

  const SparePart({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.categoryKey,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.oemNumber,
    required this.manufacturer,
    required this.condition,
    required this.price,
    required this.inStock,
    required this.warrantyAr,
    required this.warrantyEn,
    required this.compatibleCars,
    required this.imageUrls,
    this.isFeatured = false,
    this.isBestSeller = false,
    required this.createdAt,
  });

  String getName(bool isAr) => isAr ? nameAr : nameEn;
  String getDescription(bool isAr) => isAr ? descriptionAr : descriptionEn;
  String getWarranty(bool isAr) => isAr ? warrantyAr : warrantyEn;
}

enum NotificationCategory { offers, orders, alerts }

class AppNotification {
  final String id;
  final String titleAr;
  final String titleEn;
  final String bodyAr;
  final String bodyEn;
  final DateTime date;
  final NotificationCategory category;
  bool isRead;

  AppNotification({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.bodyAr,
    required this.bodyEn,
    required this.date,
    required this.category,
    this.isRead = false,
  });

  String getTitle(bool isAr) => isAr ? titleAr : titleEn;
  String getBody(bool isAr) => isAr ? bodyAr : bodyEn;
}

class CartItem {
  final SparePart part;
  int quantity;
  CartItem({required this.part, this.quantity = 1});
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../data/mock_data.dart';

class AppState extends ChangeNotifier {
  Locale _locale = const Locale('ar');
  bool _isDarkMode = true;
  bool _hasCompletedFirstLaunch = false;
  bool _isAuthenticated = false;

  // كراجي (My Garage)
  GarageCar? _savedGarageCar = const GarageCar(
    brand: 'Mercedes-Benz',
    model: 'E-Class W213',
    year: 2021,
  );
  bool _filterByMyGarageCar = false;

  // حالة الفلاتر (Core Filtering System)
  String _searchQuery = '';
  String _selectedCategory = 'cat_all';
  String? _selectedBrand;
  String? _selectedModel;
  int? _selectedYear;
  PartCondition? _selectedCondition;
  RangeValues _priceRange = const RangeValues(0, 3000);
  String? _selectedManufacturer;
  bool _inStockOnly = false;
  String _sortBy = 'sort_newest';

  // السلة والإشعارات والمفضلة
  final List<CartItem> _cart = [];
  final List<AppNotification> _notifications = List.from(MockData.initialNotifications);
  final Set<String> _favoriteIds = {'p1'};
  int _activeOrderStep = 1; // 0: Placed, 1: Processing, 2: Shipping, 3: Delivered

  Locale get locale => _locale;
  bool get isDarkMode => _isDarkMode;
  bool get hasCompletedFirstLaunch => _hasCompletedFirstLaunch;
  bool get isAuthenticated => _isAuthenticated;
  GarageCar? get savedGarageCar => _savedGarageCar;
  bool get filterByMyGarageCar => _filterByMyGarageCar;

  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String? get selectedBrand => _selectedBrand;
  String? get selectedModel => _selectedModel;
  int? get selectedYear => _selectedYear;
  PartCondition? get selectedCondition => _selectedCondition;
  RangeValues get priceRange => _priceRange;
  String? get selectedManufacturer => _selectedManufacturer;
  bool get inStockOnly => _inStockOnly;
  String get sortBy => _sortBy;

  List<CartItem> get cart => _cart;
  List<AppNotification> get notifications => _notifications;
  Set<String> get favoriteIds => _favoriteIds;
  int get activeOrderStep => _activeOrderStep;

  int get unreadNotificationsCount => _notifications.where((n) => !n.isRead).length;

  double get cartSubtotal => _cart.fold(0, (sum, item) => sum + (item.part.price * item.quantity));

  Future<void> initPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLang = prefs.getString('app_lang');
    _hasCompletedFirstLaunch = prefs.getBool('first_launch_done') ?? false;
    if (savedLang != null) {
      _locale = Locale(savedLang);
    }
    notifyListeners();
  }

  Future<void> setLanguage(String langCode) async {
    _locale = Locale(langCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_lang', langCode);
    await prefs.setBool('first_launch_done', true);
    _hasCompletedFirstLaunch = true;
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void completeLogin() {
    _isAuthenticated = true;
    notifyListeners();
  }

  void saveGarageCar(GarageCar? car) {
    _savedGarageCar = car;
    if (car == null) _filterByMyGarageCar = false;
    notifyListeners();
  }

  void toggleFilterByMyGarageCar(bool value) {
    _filterByMyGarageCar = value;
    if (value && _savedGarageCar != null) {
      _selectedBrand = _savedGarageCar!.brand;
      _selectedModel = _savedGarageCar!.model;
      _selectedYear = _savedGarageCar!.year;
    } else if (!value) {
      _selectedBrand = null;
      _selectedModel = null;
      _selectedYear = null;
    }
    notifyListeners();
  }

  // تحديث الفلاتر
  void setSearchQuery(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  void setCategory(String cat) {
    _selectedCategory = cat;
    notifyListeners();
  }

  void updateFilters({
    String? brand,
    String? model,
    int? year,
    String? category,
    PartCondition? condition,
    RangeValues? priceRange,
    String? manufacturer,
    bool? inStockOnly,
    String? sortBy,
  }) {
    _selectedBrand = brand;
    _selectedModel = model;
    _selectedYear = year;
    if (category != null) _selectedCategory = category;
    _selectedCondition = condition;
    if (priceRange != null) _priceRange = priceRange;
    _selectedManufacturer = manufacturer;
    if (inStockOnly != null) _inStockOnly = inStockOnly;
    if (sortBy != null) _sortBy = sortBy;
    notifyListeners();
  }

  void clearSingleFilter(String filterType) {
    switch (filterType) {
      case 'car':
        _selectedBrand = null;
        _selectedModel = null;
        _selectedYear = null;
        _filterByMyGarageCar = false;
        break;
      case 'category':
        _selectedCategory = 'cat_all';
        break;
      case 'condition':
        _selectedCondition = null;
        break;
      case 'manufacturer':
        _selectedManufacturer = null;
        break;
      case 'stock':
        _inStockOnly = false;
        break;
      case 'price':
        _priceRange = const RangeValues(0, 3000);
        break;
    }
    notifyListeners();
  }

  void resetAllFilters() {
    _selectedCategory = 'cat_all';
    _selectedBrand = null;
    _selectedModel = null;
    _selectedYear = null;
    _selectedCondition = null;
    _priceRange = const RangeValues(0, 3000);
    _selectedManufacturer = null;
    _inStockOnly = false;
    _filterByMyGarageCar = false;
    _sortBy = 'sort_newest';
    notifyListeners();
  }

  // حساب النتائج الفورية (يُستخدم في القائمة وفي زر Apply داخل Bottom Sheet)
  List<SparePart> computeFilteredParts({
    String? brand,
    String? model,
    int? year,
    String? category,
    PartCondition? condition,
    RangeValues? price,
    String? manufacturer,
    bool? stockOnly,
    String? sort,
  }) {
    final b = brand ?? _selectedBrand;
    final m = model ?? _selectedModel;
    final y = year ?? _selectedYear;
    final cat = category ?? _selectedCategory;
    final cond = condition ?? _selectedCondition;
    final pr = price ?? _priceRange;
    final man = manufacturer ?? _selectedManufacturer;
    final stk = stockOnly ?? _inStockOnly;
    final srt = sort ?? _sortBy;

    List<SparePart> list = MockData.parts.where((part) {
      if (_searchQuery.trim().isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchName = part.nameAr.toLowerCase().contains(q) ||
            part.nameEn.toLowerCase().contains(q) ||
            part.oemNumber.toLowerCase().contains(q);
        if (!matchName) return false;
      }
      if (cat != 'cat_all' && part.categoryKey != cat) return false;
      if (b != null || m != null || y != null) {
        final fits = part.compatibleCars.any((car) => car.matches(b, m, y));
        if (!fits) return false;
      }
      if (cond != null && part.condition != cond) return false;
      if (part.price < pr.start || part.price > pr.end) return false;
      if (man != null && part.manufacturer != man) return false;
      if (stk && !part.inStock) return false;
      return true;
    }).toList();

    switch (srt) {
      case 'sort_price_low':
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'sort_price_high':
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'sort_best_selling':
        list.sort((a, b) => (b.isBestSeller ? 1 : 0).compareTo(a.isBestSeller ? 1 : 0));
        break;
      case 'sort_newest':
      default:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }
    return list;
  }

  // إدارة السلة
  void addToCart(SparePart part) {
    final index = _cart.indexWhere((item) => item.part.id == part.id);
    if (index >= 0) {
      _cart[index].quantity++;
    } else {
      _cart.add(CartItem(part: part));
    }
    notifyListeners();
  }

  void updateCartQuantity(String partId, int delta) {
    final index = _cart.indexWhere((item) => item.part.id == partId);
    if (index >= 0) {
      _cart[index].quantity += delta;
      if (_cart[index].quantity <= 0) {
        _cart.removeAt(index);
      }
      notifyListeners();
    }
  }

  void placeOrder() {
    _cart.clear();
    _activeOrderStep = 1;
    _notifications.insert(
      0,
      AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        titleAr: 'تم تأكيد طلبك الجديد بنجاح',
        titleEn: 'Your New Order Has Been Confirmed',
        bodyAr: 'فريق اليورو يقوم الآن بفحص وتجهيز قطع الغيار الخاصة بك للشحن.',
        bodyEn: 'Al Euro team is now inspecting and packing your spare parts for dispatch.',
        date: DateTime.now(),
        category: NotificationCategory.orders,
      ),
    );
    notifyListeners();
  }

  // إدارة الإشعارات ولوحة الإدارة
  void markNotificationRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index >= 0) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void markAllNotificationsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void sendAdminBroadcastNotification({
    required String titleAr,
    required String titleEn,
    required String bodyAr,
    required String bodyEn,
    required NotificationCategory category,
  }) {
    _notifications.insert(
      0,
      AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        titleAr: titleAr,
        titleEn: titleEn,
        bodyAr: bodyAr,
        bodyEn: bodyEn,
        date: DateTime.now(),
        category: category,
        isRead: false,
      ),
    );
    notifyListeners();
  }

  void toggleFavorite(String partId) {
    if (_favoriteIds.contains(partId)) {
      _favoriteIds.remove(partId);
    } else {
      _favoriteIds.add(partId);
    }
    notifyListeners();
  }
}

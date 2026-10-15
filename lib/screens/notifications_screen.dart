import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../core/app_localizations.dart';
import '../models/models.dart';
import '../providers/app_state.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NotificationCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isAr = context.isAr;

    final list = _selectedCategory == null
        ? state.notifications
        : state.notifications.where((n) => n.category == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('notifications_title')),
        actions: [
          TextButton(
            onPressed: state.markAllNotificationsRead,
            child: Text(
              context.tr('mark_all_read'),
              style: const TextStyle(color: AlEuroColors.ivory, fontSize: 12),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // شرائح تقسيم الإشعارات (Offers / Order Updates / Alerts)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildTabChip(null, context.tr('tab_all')),
                const SizedBox(width: 8),
                _buildTabChip(NotificationCategory.offers, context.tr('tab_offers')),
                const SizedBox(width: 8),
                _buildTabChip(NotificationCategory.orders, context.tr('tab_orders')),
                const SizedBox(width: 8),
                _buildTabChip(NotificationCategory.alerts, context.tr('tab_alerts')),
              ],
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? Center(child: Text(context.tr('no_notifications')))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = list[index];
                      return Card(
                        child: ListTile(
                          onTap: () => state.markNotificationRead(item.id),
                          leading: CircleAvatar(
                            backgroundColor: item.isRead ? AlEuroColors.darkGray : AlEuroColors.burgundy,
                            child: Icon(
                              _iconForCat(item.category),
                              color: AlEuroColors.ivory,
                              size: 20,
                            ),
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.getTitle(isAr),
                                  style: TextStyle(
                                    fontWeight: item.isRead ? FontWeight.normal : FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (!item.isRead)
                                Container(
                                  width: 9,
                                  height: 9,
                                  decoration: const BoxDecoration(
                                    color: AlEuroColors.burgundy,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(item.getBody(isAr)),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  IconData _iconForCat(NotificationCategory cat) {
    switch (cat) {
      case NotificationCategory.offers:
        return Icons.local_offer_outlined;
      case NotificationCategory.orders:
        return Icons.local_shipping_outlined;
      case NotificationCategory.alerts:
        return Icons.notifications_active_outlined;
    }
  }

  Widget _buildTabChip(NotificationCategory? cat, String label) {
    final selected = _selectedCategory == cat;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      selectedColor: AlEuroColors.burgundy,
      backgroundColor: AlEuroColors.black,
      labelStyle: TextStyle(color: selected ? AlEuroColors.ivory : AlEuroColors.warmGray),
      onSelected: (_) => setState(() => _selectedCategory = cat),
    );
  }
}

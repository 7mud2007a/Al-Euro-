import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../core/app_localizations.dart';
import '../models/models.dart';
import '../providers/app_state.dart';
import '../widgets/common_header.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _adminTitleCtrl = TextEditingController();
  final TextEditingController _adminBodyCtrl = TextEditingController();
  NotificationCategory _adminCategory = NotificationCategory.offers;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      appBar: AlEuroAppBar(title: context.tr('profile_title')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. بطاقة معلومات العميل
          const Card(
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: AlEuroColors.burgundy,
                child: Icon(Icons.person_outline, color: AlEuroColors.ivory, size: 28),
              ),
              title: Text('خالد المنصور | Khaled Al-Mansour', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('+966 50 123 4567 • VIP Garage Member'),
            ),
          ),
          const SizedBox(height: 16),

          // 2. كراجي (My Garage - Saved Car)
          Card(
            child: ListTile(
              leading: const Icon(Icons.garage_outlined, color: AlEuroColors.ivory),
              title: Text(context.tr('my_garage')),
              subtitle: Text(state.savedGarageCar?.toString() ?? context.tr('no_car_selected')),
              trailing: const Icon(Icons.check_circle, color: AlEuroColors.burgundy),
            ),
          ),
          const SizedBox(height: 10),

          // 3. مبدل اللغة الفوري (Profile > Language Switcher - Instant RTL/LTR)
          Card(
            child: ListTile(
              leading: const Icon(Icons.language_rounded, color: AlEuroColors.ivory),
              title: Text(context.tr('language')),
              trailing: SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'ar', label: Text('العربية')),
                  ButtonSegment(value: 'en', label: Text('EN')),
                ],
                selected: {state.locale.languageCode},
                onSelectionChanged: (set) => state.setLanguage(set.first),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) return AlEuroColors.burgundy;
                    return AlEuroColors.black;
                  }),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // 4. تبديل الوضع الداكن / الفاتح (Dark Charcoal vs Light Ivory)
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.dark_mode_outlined, color: AlEuroColors.ivory),
              title: Text(context.tr('theme_mode')),
              activeColor: AlEuroColors.burgundy,
              value: state.isDarkMode,
              onChanged: (_) => state.toggleTheme(),
            ),
          ),
          const SizedBox(height: 24),

          // 5. لوحة الإدارة المدمجة لإرسال الإشعارات الفورية للعملاء (Admin Notification Panel)
          Text(context.tr('admin_panel'), style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<NotificationCategory>(
                    value: _adminCategory,
                    decoration: InputDecoration(labelText: context.tr('admin_segment')),
                    items: [
                      DropdownMenuItem(value: NotificationCategory.offers, child: Text(context.tr('seg_offers'))),
                      DropdownMenuItem(value: NotificationCategory.orders, child: Text(context.tr('seg_orders'))),
                      DropdownMenuItem(value: NotificationCategory.alerts, child: Text(context.tr('seg_all'))),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _adminCategory = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _adminTitleCtrl,
                    decoration: InputDecoration(labelText: context.tr('notif_title_input')),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _adminBodyCtrl,
                    decoration: InputDecoration(labelText: context.tr('notif_body_input')),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_adminTitleCtrl.text.trim().isEmpty) return;
                      state.sendAdminBroadcastNotification(
                        titleAr: _adminTitleCtrl.text,
                        titleEn: _adminTitleCtrl.text,
                        bodyAr: _adminBodyCtrl.text,
                        bodyEn: _adminBodyCtrl.text,
                        category: _adminCategory,
                      );
                      _adminTitleCtrl.clear();
                      _adminBodyCtrl.clear();
                    },
                    icon: const Icon(Icons.send_rounded),
                    label: Text(context.tr('send_notification_btn')),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

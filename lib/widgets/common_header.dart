import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../core/app_localizations.dart';
import '../providers/app_state.dart';
import '../screens/notifications_screen.dart';

class AlEuroAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBack;

  const AlEuroAppBar({super.key, this.title, this.showBack = false});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final unread = state.unreadNotificationsCount;

    return AppBar(
      automaticallyImplyLeading: showBack,
      titleSpacing: 16,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: AlEuroColors.warmGray.withOpacity(0.6), width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              title ?? context.tr('app_name'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    letterSpacing: context.isAr ? 0 : 2.2,
                  ),
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 12),
          child: IconButton(
            tooltip: context.tr('notifications_title'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_none_rounded, size: 27),
                if (unread > 0)
                  PositionedDirectional(
                    top: -4,
                    end: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: AlEuroColors.burgundy, // Burgundy exclusively for badge
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AlEuroColors.ivory, width: 1),
                      ),
                      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                      child: Text(
                        '$unread',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AlEuroColors.ivory,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

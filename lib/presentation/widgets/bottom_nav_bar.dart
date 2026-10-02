import 'package:flutter/material.dart';

import '../../app/router.dart';
import '../../l10n/generated/app_localizations.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key, required this.selectedTab});

  final String selectedTab;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final items = [
      _BottomNavItem(
        icon: Icons.home_rounded,
        label: strings.today,
        active: selectedTab == 'today',
        onTap: () => _navigate(context, AppRouter.home),
      ),
      _BottomNavItem(
        icon: Icons.calendar_month_rounded,
        label: strings.calendar,
        active: selectedTab == 'calendar',
        onTap: () => _navigate(context, AppRouter.calendar),
      ),
      _BottomNavItem(icon: Icons.menu_book_rounded, label: strings.readings),
      // _BottomNavItem(icon: Icons.favorite_border_rounded, label: 'Devotions'),
      _BottomNavItem(
        icon: Icons.settings_outlined,
        label: strings.settings,
        active: selectedTab == 'settings',
        onTap: () => _navigate(context, AppRouter.settingsPage),
      ),
    ];

    return Container(
      height: 88,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EDE4),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
    );
  }

  void _navigate(BuildContext context, String route) {
    if (ModalRoute.of(context)?.settings.name == route) return;
    Navigator.of(context).pushReplacementNamed(route);
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.label,
    this.active = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      selected: active,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 26,
                color: active
                    ? const Color(0xFF0A2F27)
                    : const Color(0xFF567068),
              ),
              const SizedBox(height: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                  color: active
                      ? const Color(0xFF0A2F27)
                      : const Color(0xFF567068),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

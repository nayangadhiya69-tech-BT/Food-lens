import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/app_text_style.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Body of the [StatefulShellRoute]: keeps the four tab branches alive
/// and shows the custom bottom nav from the HTML design
/// (white bar, hairline top border, icon + label, brand color when active).
class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _BottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: _goBranch,
      ),
    );
  }

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // When re-selecting the already-active tab, jump to its root
      // (matches the usual iOS/Android tab-bar behaviour).
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;

  final ValueChanged<int> onTap;
  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Material(
      color: AppColors.surface,
      child: SafeArea(
        top: false,
        child: Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.line)),
          ),
          child: Row(
            children: [
              _NavItem(
                label: l10n.navHome,
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                selected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                label: l10n.navMyDay,
                icon: Icons.wb_sunny_outlined,
                activeIcon: Icons.wb_sunny_rounded,
                selected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavItem(
                label: l10n.navHistory,
                icon: Icons.access_time_rounded,
                activeIcon: Icons.access_time_rounded,
                selected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              _NavItem(
                label: l10n.navProfile,
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                selected: currentIndex == 3,
                onTap: () => onTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;

  final IconData icon;
  final IconData activeIcon;
  final bool selected;
  final VoidCallback onTap;
  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.brand : AppColors.inkTertiary;

    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.only(
              top: dynamicHeight(10),
              bottom: dynamicHeight(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(selected ? activeIcon : icon, size: 24, color: color),
                SizedBox(height: dynamicHeight(3)),
                Text(
                  label,
                  style: AppTextStyle.create(
                    fontSize: 11,
                    weight: FontWeights.semibold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class NavItem {
  final int index;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;

  const NavItem({
    required this.index,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
  });
}

const navItems = [
  NavItem(
    index: 0,
    activeIcon: Icons.home,
    inactiveIcon: Icons.home_outlined,
    label: "홈",
  ),
  NavItem(
    index: 1,
    activeIcon: Icons.person,
    inactiveIcon: Icons.person_outline,
    label: "메뉴1",
  ),
  NavItem(
    index: 2,
    activeIcon: Icons.settings,
    inactiveIcon: Icons.settings_outlined,
    label: "설정",
  ),
];

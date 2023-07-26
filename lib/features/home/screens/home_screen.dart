import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/features/home/screens/widgets/active_icon.dart';
import 'package:social_app/theme/pallete.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
    required this.navigationShell,
  }) : super(
            key: key ?? const ValueKey<String>('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        backgroundColor: Palette.background,
        // backgroundColor: Colors.amber,
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        indicatorColor: Colors.transparent,

        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
        destinations: const [
          NavigationDestination(
            selectedIcon: ActiveIcon(
              icon: Icons.home_outlined,
            ),
            icon: Icon(
              Icons.home_outlined,
              color: Colors.grey,
            ),
            label: "Profile",
          ),
          // NavigationDestination(
          //   selectedIcon: ActiveIcon(
          //     icon: Icons.leaderboard_outlined,
          //   ),
          //   icon: Icon(Icons.leaderboard_outlined),
          //   label: "Leaderboard",
          // ),
          // NavigationDestination(
          //   selectedIcon: ActiveIcon(
          //     icon: Icons.chat_outlined,
          //   ),
          //   icon: Icon(Icons.chat_outlined),
          //   label: "Chat",
          // ),
           NavigationDestination(
            selectedIcon: ActiveIcon(
              icon: Icons.message,
            ),
            icon: Icon(
              Icons.message,
              color: Colors.grey,
            ),
            label: "Contact",
          ),
          NavigationDestination(
            selectedIcon: ActiveIcon(
              icon: Icons.person_outline,
            ),
            icon: Icon(
              Icons.person_outline,
              color: Colors.grey,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

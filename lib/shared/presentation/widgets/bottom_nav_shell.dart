import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_wallet/core/theme/app_colors.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

/// The shell widget for the bottom navigation bar.
///
/// Wraps the main tabs and provides the persistent bottom navigation
/// and the floating action button (FAB).
class BottomNavShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const BottomNavShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        backgroundColor: AppColors.white,
        indicatorColor: AppColors.primaryGreen.withValues(alpha: 0.1),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: AppColors.primaryGreen),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.contacts_outlined),
            selectedIcon: Icon(Icons.contacts, color: AppColors.primaryGreen),
            label: 'Contacts',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(
              Icons.account_balance_wallet,
              color: AppColors.primaryGreen,
            ),
            label: 'Wallet',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings, color: AppColors.primaryGreen),
            label: 'Settings',
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.white,
        activeForegroundColor: AppColors.white,
        activeBackgroundColor: AppColors.primaryGreen,
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        elevation: 8.0,
        shape: const CircleBorder(),
        children: [
          SpeedDialChild(
            child: const Icon(Icons.qr_code_scanner, color: AppColors.white),
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: AppColors.white,
            label: 'Scan Card',
            labelStyle: const TextStyle(fontSize: 14),
            onTap: () => context.push('/contacts/scan'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.edit, color: AppColors.white),
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: AppColors.white,
            label: 'Add Manually',
            labelStyle: const TextStyle(fontSize: 14),
            onTap: () => context.push('/contacts/add'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.contacts, color: AppColors.white),
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: AppColors.white,
            label: 'Import Contacts',
            labelStyle: const TextStyle(fontSize: 14),
            onTap: () => context.push('/contacts/import'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.share, color: AppColors.white),
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: AppColors.white,
            label: 'Share My QR',
            labelStyle: const TextStyle(fontSize: 14),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('QR Code sharing coming soon!')),
              );
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

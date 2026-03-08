import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.abyssBlue,
        toolbarHeight: 64,
        title: GestureDetector(
          onTap: () => context.go('/'),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('⚙️', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Text(
                  'MANATEK',
                  style: GoogleFonts.orbitron(
                    fontSize: isMobile ? 14 : 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.bioTeal,
                    letterSpacing: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(
            height: 2,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, AppColors.bioTeal, Colors.transparent],
              ),
            ),
          ),
        ),
        actions: isMobile
            ? [
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu, color: AppColors.bioTeal),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                ),
              ]
            : _buildNavItems(context),
      ),
      endDrawer: isMobile ? _buildDrawer(context) : null,
      body: child,
    );
  }

  List<Widget> _buildNavItems(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    return [
      _NavItem(label: 'SIGHTINGS', path: '/sightings', active: location == '/sightings'),
      _NavItem(label: 'FIELD GUIDE', path: '/field-guide', active: location == '/field-guide'),
      _NavItem(label: 'NEWS', path: '/news', active: location == '/news'),
      _NavItem(label: 'DEFENSE', path: '/defense', active: location == '/defense'),
      _NavItem(label: 'ABOUT', path: '/about', active: location == '/about'),
      const SizedBox(width: 16),
    ];
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.abyssBlue,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'NAVIGATION',
                style: GoogleFonts.orbitron(
                  color: AppColors.bioTeal,
                  fontSize: 14,
                  letterSpacing: 2,
                ),
              ),
            ),
            const Divider(color: AppColors.surfaceLight),
            _DrawerItem(label: 'HOME', path: '/', context: context),
            _DrawerItem(label: 'SIGHTINGS', path: '/sightings', context: context),
            _DrawerItem(label: 'FIELD GUIDE', path: '/field-guide', context: context),
            _DrawerItem(label: 'NEWS', path: '/news', context: context),
            _DrawerItem(label: 'DEFENSE', path: '/defense', context: context),
            _DrawerItem(label: 'ABOUT', path: '/about', context: context),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final String path;
  final bool active;

  const _NavItem({required this.label, required this.path, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton(
        onPressed: () => context.go(path),
        child: Text(
          label,
          style: GoogleFonts.shareTechMono(
            fontSize: 13,
            color: active ? AppColors.bioTeal : AppColors.chromeSilver,
            letterSpacing: 1.5,
            fontWeight: active ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String label;
  final String path;
  final BuildContext context;

  const _DrawerItem({required this.label, required this.path, required this.context});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        label,
        style: GoogleFonts.shareTechMono(
          color: AppColors.chromeSilver,
          fontSize: 14,
          letterSpacing: 1.5,
        ),
      ),
      onTap: () {
        Navigator.of(context).pop();
        GoRouter.of(context).go(path);
      },
    );
  }
}

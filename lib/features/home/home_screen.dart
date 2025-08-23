import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:city_guide/gen_l10n/app_localizations.dart';
import '../../app/theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(loc.homeExploreFethiye, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12, runSpacing: 12,
            children: [
              _QuickAction(icon: Icons.place, label: loc.quickPlaces, onTap: () => context.go('/places')),
              _QuickAction(icon: Icons.event, label: loc.quickEvents, onTap: () => context.go('/events')),
              _QuickAction(icon: Icons.favorite, label: loc.quickFavorites, onTap: () => context.go('/favorites')),
              _QuickAction(icon: Icons.dark_mode, label: loc.quickTheme, onTap: () {
                themeModeNotifier.value = themeModeNotifier.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
              }),
              _QuickAction(icon: Icons.add_location_alt, label: 'Submit Place', onTap: () => context.push('/submit_place')),
              _QuickAction(icon: Icons.add_alert, label: 'Submit Event', onTap: () => context.push('/submit_event')),
              _QuickAction(icon: Icons.admin_panel_settings, label: 'Admin', onTap: () => context.push('/admin')),
            ],
          ),
          const SizedBox(height: 24),
          Text(loc.tipsTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(loc.tipsBody),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 150, height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.surfaceVariant,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(height: 6),
            Text(label),
          ],
        ),
      ),
    );
  }
}


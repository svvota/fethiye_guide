import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:city_guide/gen_l10n/app_localizations.dart';
import '../../app/theme.dart';
import '../../app/app.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _clearHttpCache(BuildContext context) async {
    final box = await Hive.openBox('httpCache');
    final before = box.length;
    await box.clear();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cache cleared ($before → 0)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.settingsTitle)),
      body: ListView(
        children: [
          // Theme
          SwitchListTile(
            title: Text(loc.darkMode),
            value: themeModeNotifier.value == ThemeMode.dark,
            onChanged: (v) =>
                themeModeNotifier.value = v ? ThemeMode.dark : ThemeMode.light,
          ),

          // Language
          ListTile(
            title: Text(loc.language),
            subtitle: Text(loc.languageValue),
            trailing: DropdownButton<Locale>(
              value: localeNotifier.value ?? const Locale('en'),
              items: const [
                DropdownMenuItem(value: Locale('en'), child: Text('English')),
                DropdownMenuItem(value: Locale('tr'), child: Text('Türkçe')),
              ],
              onChanged: (value) => localeNotifier.value = value,
            ),
          ),

          const Divider(),

          // Debug Tools entry
          ListTile(
            leading: const Icon(Icons.bug_report),
            title: const Text('Debug Tools'),
            subtitle:
                const Text('Source (local/cache/network), counts, cache age'),
            onTap: () => context.push('/debug'),
          ),

          // Clear HTTP cache
          ListTile(
            leading: const Icon(Icons.delete_sweep),
            title: const Text('Clear HTTP cache'),
            subtitle: const Text('Wipe Hive "httpCache" to force fresh fetch'),
            onTap: () => _clearHttpCache(context),
          ),
        ],
      ),
    );
  }
}

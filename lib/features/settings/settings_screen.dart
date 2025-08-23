import 'package:flutter/material.dart';
import 'package:city_guide/gen_l10n/app_localizations.dart';
import '../../app/theme.dart';
import '../../app/app.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.settingsTitle)),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(loc.darkMode),
            value: themeModeNotifier.value == ThemeMode.dark,
            onChanged: (v) => themeModeNotifier.value = v ? ThemeMode.dark : ThemeMode.light,
          ),
          ListTile(
            title: Text(loc.language),
            subtitle: Text(loc.languageValue),
            trailing: DropdownButton<Locale>(
              value: localeNotifier.value ?? const Locale('en'),
              items: const [
                DropdownMenuItem(value: Locale('en'), child: Text('English')),
                DropdownMenuItem(value: Locale('tr'), child: Text('Türkçe')),
              ],
              onChanged: (loc) => localeNotifier.value = loc,
            ),
          ),
        ],
      ),
    );
  }
}


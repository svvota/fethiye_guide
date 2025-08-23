import 'package:flutter/material.dart';

final themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);

final lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
  useMaterial3: true,
);

final darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.dark),
  useMaterial3: true,
);


import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class LocalLoader {
  static Future<List<dynamic>> loadList(String assetPath) async {
    final s = await rootBundle.loadString(assetPath);
    final data = jsonDecode(s);
    if (data is List) return data;
    return [];
  }
}


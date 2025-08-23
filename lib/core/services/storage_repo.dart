import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class StorageRepo {
  Future<File> _file(String name) async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$name');
  }

  Future<List<Map<String, dynamic>>> readJsonList(String name) async {
    final f = await _file(name);
    if (!await f.exists()) return [];
    final s = await f.readAsString();
    final data = jsonDecode(s);
    if (data is List) return data.cast<Map<String, dynamic>>();
    return [];
  }

  Future<void> appendJsonItem(String name, Map<String, dynamic> obj) async {
    final f = await _file(name);
    List<dynamic> list = [];
    if (await f.exists()) {
      final s = await f.readAsString();
      final data = jsonDecode(s);
      if (data is List) list = data;
    }
    list.add(obj);
    await f.writeAsString(jsonEncode(list), flush: true);
  }
}


import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RemoteClient {
  final Dio _dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 8), receiveTimeout: const Duration(seconds: 8)));

  Future<List<dynamic>> fetchJsonList(String url, {String cacheKey = 'cache', Duration ttl = const Duration(hours: 6)}) async {
    final box = await Hive.openBox('httpCache');
    final now = DateTime.now().millisecondsSinceEpoch;
    final cached = box.get(cacheKey);
    if (cached != null) {
      final m = cached as Map;
      if (now - (m['ts'] as int) < ttl.inMilliseconds) {
        return (jsonDecode(m['data']) as List);
      }
    }
    final resp = await _dio.get(url);
    if (resp.statusCode == 200) {
      final data = resp.data is String ? jsonDecode(resp.data) : resp.data;
      if (data is List) {
        await box.put(cacheKey, {"ts": now, "data": jsonEncode(data)});
        return data;
      }
    }
    throw Exception('Network error');
  }
}


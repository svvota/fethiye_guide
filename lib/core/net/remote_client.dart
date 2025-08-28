import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:dio_web_adapter/dio_web_adapter.dart';

class RemoteClient {
  late final Dio _dio;

  RemoteClient() {
    _dio = Dio(
      BaseOptions(
        // Shorten while testing; bump later
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),

        // Firebase Hosting returns proper JSON; ResponseType.json is fine.
        // If you ever see double-decoding issues, switch to ResponseType.plain.
        responseType: ResponseType.json,
      ),
    );

    if (kIsWeb) {
      // IMPORTANT for Flutter web: use the browser adapter (CORS-friendly)
      _dio.httpClientAdapter = BrowserHttpClientAdapter();
    }
  }

  Future<List<dynamic>> fetchJsonList(
    String url, {
    String cacheKey = 'cache',
    Duration ttl = const Duration(
        minutes: 1), // fast iteration; change to hours:6 for prod
  }) async {
    final box = await Hive.openBox('httpCache');
    final now = DateTime.now().millisecondsSinceEpoch;

    // Serve fresh-enough cache
    final cached = box.get(cacheKey);
    if (cached != null) {
      try {
        final m = cached as Map;
        final age = now - (m['ts'] as int);
        if (age < ttl.inMilliseconds) {
          final list = jsonDecode(m['data'] as String) as List;
          // print('CACHE[$cacheKey]: ${list.length} items (age ${age}ms)');
          return list;
        }
      } catch (_) {
        // corrupted cache → drop it
        await box.delete(cacheKey);
      }
    }

    // Network fetch
    final resp = await _dio.get(url);
    if (resp.statusCode == 200) {
      final data = resp.data is String ? jsonDecode(resp.data) : resp.data;
      if (data is List) {
        await box.put(cacheKey, {"ts": now, "data": jsonEncode(data)});
        // print('NETWORK[$cacheKey]: ${data.length} items');
        return data;
      }
      throw Exception('Remote data at $url is not a JSON List.');
    }

    throw Exception('Network error ${resp.statusCode} for $url');
  }
}

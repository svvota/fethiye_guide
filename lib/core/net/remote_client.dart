import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:dio_web_adapter/dio_web_adapter.dart';

typedef ProvenanceCb = void Function(String source, int? cacheAgeMs);
// source: 'cache' or 'network'; cacheAgeMs only set when source == 'cache'

class RemoteClient {
  late final Dio _dio;

  RemoteClient() {
    _dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
      responseType: ResponseType.json,
    ));
    if (kIsWeb) {
      _dio.httpClientAdapter = BrowserHttpClientAdapter();
    }
  }

  Future<List<dynamic>> fetchJsonList(
    String url, {
    String cacheKey = 'cache',
    Duration ttl = const Duration(minutes: 1),
    ProvenanceCb? diag, // <--- new
  }) async {
    final box = await Hive.openBox('httpCache');
    final now = DateTime.now().millisecondsSinceEpoch;
    final cached = box.get(cacheKey);

    if (cached != null) {
      try {
        final m = cached as Map;
        final ageMs = now - (m['ts'] as int);
        if (ageMs < ttl.inMilliseconds) {
          final list = jsonDecode(m['data'] as String) as List;
          diag?.call('cache', ageMs);
          return list;
        }
      } catch (_) {
        await box.delete(cacheKey);
      }
    }

    final resp = await _dio.get(url);
    if (resp.statusCode == 200) {
      final data = resp.data is String ? jsonDecode(resp.data) : resp.data;
      if (data is List) {
        await box.put(cacheKey, {"ts": now, "data": jsonEncode(data)});
        diag?.call('network', 0);
        return data;
      }
      throw Exception('Remote data at $url is not a JSON List.');
    }
    throw Exception('Network error ${resp.statusCode} for $url');
  }
}

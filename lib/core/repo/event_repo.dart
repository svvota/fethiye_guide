import '../models/event_item.dart';
import '../services/local_loader.dart';
import '../services/storage_repo.dart';
import '../net/remote_client.dart';
import '../app_config.dart';
import '../diag/data_diagnostics.dart';

class EventRepo {
  final _storage = StorageRepo();

  Future<List<EventItem>> getEvents() async {
    List raw = await LocalLoader.loadList('assets/data/events.json');
    bool usedLocal = true;

    if (AppConfig.dataSource == DataSource.remotePreferred &&
        AppConfig.eventsUrl != null) {
      try {
        raw = await RemoteClient().fetchJsonList(
          AppConfig.eventsUrl!,
          cacheKey: 'events',
          diag: (source, ageMs) {
            usedLocal = false;
            DataDiagnostics.I.setEvents(
              source: source,
              count: raw.length,
              cacheAgeMs: ageMs,
            );
          },
        );
      } catch (e) {
        // keep local
      }
    }

    if (usedLocal) {
      DataDiagnostics.I
          .setEvents(source: 'local', count: raw.length, cacheAgeMs: null);
    }

    final sub = await _storage.readJsonList('event_submissions.json');
    final approved = await _storage.readJsonList('approved_events.json');
    final all = [...raw, ...approved, ...sub];

    // FIX: safely cast each element to Map<String,dynamic>
    return all
        .map((e) => EventItem.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }
}

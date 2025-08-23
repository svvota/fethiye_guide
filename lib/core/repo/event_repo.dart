import '../models/event_item.dart';
import '../services/local_loader.dart';
import '../services/storage_repo.dart';
import '../net/remote_client.dart';
import '../app_config.dart';

class EventRepo {
  final _storage = StorageRepo();

  Future<List<EventItem>> getEvents() async {
    List raw = await LocalLoader.loadList('assets/data/events.json');
    if (AppConfig.dataSource == DataSource.remotePreferred && AppConfig.eventsUrl != null) {
      try { raw = await RemoteClient().fetchJsonList(AppConfig.eventsUrl!, cacheKey: 'events'); } catch (_) {}
    }
    final sub = await _storage.readJsonList('event_submissions.json');
    final approved = await _storage.readJsonList('approved_events.json');
    final all = [...raw, ...approved, ...sub];
    return all.map((e) => EventItem.fromJson(e)).toList().cast<EventItem>();
  }
}


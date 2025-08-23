import '../models/place.dart';
import '../services/local_loader.dart';
import '../services/storage_repo.dart';
import '../net/remote_client.dart';
import '../app_config.dart';

class PlaceRepo {
  final _storage = StorageRepo();

  Future<List<Place>> getPlaces() async {
    List raw = await LocalLoader.loadList('assets/data/places.json');
    if (AppConfig.dataSource == DataSource.remotePreferred && AppConfig.placesUrl != null) {
      try { raw = await RemoteClient().fetchJsonList(AppConfig.placesUrl!, cacheKey: 'places'); } catch (_) {}
    }
    final sub = await _storage.readJsonList('place_submissions.json');
    final approved = await _storage.readJsonList('approved_places.json');
    final all = [...raw, ...approved, ...sub];
    return all.map((e) => Place.fromJson(e)).toList().cast<Place>();
  }
}


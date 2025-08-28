import '../models/place.dart';
import '../services/local_loader.dart';
import '../services/storage_repo.dart';
import '../net/remote_client.dart';
import '../app_config.dart';
import '../diag/data_diagnostics.dart';

class PlaceRepo {
  final _storage = StorageRepo();

  Future<List<Place>> getPlaces() async {
    List raw = await LocalLoader.loadList('assets/data/places.json');
    bool usedLocal = true;

    if (AppConfig.dataSource == DataSource.remotePreferred &&
        AppConfig.placesUrl != null) {
      try {
        raw = await RemoteClient().fetchJsonList(
          AppConfig.placesUrl!,
          cacheKey: 'places',
          diag: (source, ageMs) {
            usedLocal = false;
            DataDiagnostics.I.setPlaces(
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
          .setPlaces(source: 'local', count: raw.length, cacheAgeMs: null);
    }

    final sub = await _storage.readJsonList('place_submissions.json');
    final approved = await _storage.readJsonList('approved_places.json');
    final all = [...raw, ...approved, ...sub];

    // FIX: safely cast each element to Map<String,dynamic>
    return all
        .map((e) => Place.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }
}

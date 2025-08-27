import 'package:shared_preferences/shared_preferences.dart';

class FavoritesStore {
  static const _kPlacesKey = 'fav_places';
  static const _kEventsKey = 'fav_events';

  Future<Set<String>> getPlaceFavs() async {
    final p = await SharedPreferences.getInstance();
    return (p.getStringList(_kPlacesKey) ?? const <String>[]).toSet();
  }

  Future<Set<String>> getEventFavs() async {
    final p = await SharedPreferences.getInstance();
    return (p.getStringList(_kEventsKey) ?? const <String>[]).toSet();
  }

  Future<void> togglePlace(String id) async {
    final p = await SharedPreferences.getInstance();
    final set = (p.getStringList(_kPlacesKey) ?? const <String>[]).toSet();
    if (set.contains(id)) {
      set.remove(id);
    } else {
      set.add(id);
    }
    await p.setStringList(_kPlacesKey, set.toList());
  }

  Future<void> toggleEvent(String id) async {
    final p = await SharedPreferences.getInstance();
    final set = (p.getStringList(_kEventsKey) ?? const <String>[]).toSet();
    if (set.contains(id)) {
      set.remove(id);
    } else {
      set.add(id);
    }
    await p.setStringList(_kEventsKey, set.toList());
  }
}

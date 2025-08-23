import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:city_guide/gen_l10n/app_localizations.dart';
import '../../core/models/place.dart';
import '../../core/models/event_item.dart';
import '../../core/repo/place_repo.dart';
import '../../core/repo/event_repo.dart';
import '../../core/services/favorites_store.dart';
import '../../shared/widgets/place_card.dart';
import '../../shared/widgets/event_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _favStore = FavoritesStore();
  late Future<List<Place>> _placesF;
  late Future<List<EventItem>> _eventsF;
  Set<String> favPlaces = {};
  Set<String> favEvents = {};

  @override
  void initState() {
    super.initState();
    _placesF = PlaceRepo().getPlaces();
    _eventsF = EventRepo().getEvents();
    _loadFavs();
  }

  Future<void> _loadFavs() async {
    favPlaces = await _favStore.getPlaceFavs();
    favEvents = await _favStore.getEventFavs();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.favoritesTitle)),
      body: RefreshIndicator(
        onRefresh: () async => _loadFavs(),
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Text(loc.favoritesPlacesHeader, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            FutureBuilder<List<Place>>(
              future: _placesF,
              builder: (context, snap) {
                if (!snap.hasData) return const Center(child: Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator()));
                final favList = snap.data!.where((p) => favPlaces.contains(p.id)).toList();
                if (favList.isEmpty) return Text(loc.noFavoritePlaces);
                return Column(
                  children: favList.map((p) => PlaceCard(place: p, onTap: () => context.push('/place/${p.id}'))).toList(),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(loc.favoritesEventsHeader, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            FutureBuilder<List<EventItem>>(
              future: _eventsF,
              builder: (context, snap) {
                if (!snap.hasData) return const Center(child: Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator()));
                final favList = snap.data!.where((e) => favEvents.contains(e.id)).toList();
                if (favList.isEmpty) return Text(loc.noFavoriteEvents);
                return Column(
                  children: favList.map((e) => EventCard(event: e, onTap: () => context.push('/event/${e.id}'))).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:city_guide/gen_l10n/app_localizations.dart';
import '../../core/models/place.dart';
import '../../core/repo/place_repo.dart';
import '../../shared/widgets/place_card.dart';
import '../../core/services/location_service.dart';

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({super.key});

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  late Future<List<Place>> _future;
  String query = '';
  String selectedCategory = 'ALL';
  List<String> categories = const [];
  bool nearMe = false;
  String sort = 'name';
  double userLat = 0, userLon = 0;
  int radiusKm = 10;
  final List<int> radiusOptions = const [2,5,10,20];

  @override
  void initState() {
    super.initState();
    _future = PlaceRepo().getPlaces();
    _future.then((list) {
      final s = <String>{ for (final p in list) p.category };
      setState(() => categories = ['ALL', ...s]);
    });
  }

  Future<void> _toggleNearMe() async {
    final pos = await LocationService().getPosition();
    if (pos != null) {
      if (mounted) {
        setState(() { 
          nearMe = !nearMe; 
          userLat = pos.latitude; 
          userLon = pos.longitude; 
        });
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location unavailable')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.placesTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: loc.searchPlacesHint),
              onChanged: (v) => setState(() => query = v.toLowerCase()),
            ),
          ),
          if (categories.isNotEmpty)
            SizedBox(
              height: 48,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final c = categories[i];
                  final isAll = c == 'ALL';
                  final label = isAll ? loc.categoryAll : c;
                  final selected = selectedCategory == c;
                  return FilterChip(
                    selected: selected,
                    label: Text(label),
                    onSelected: (_) => setState(() => selectedCategory = c),
                  );
                },
              ),
            ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: sort,
                    items: const [
                      DropdownMenuItem(value: 'name', child: Text('Sort by name')),
                      DropdownMenuItem(value: 'distance', child: Text('Sort by distance')),
                    ],
                    onChanged: (v) => setState(() => sort = v ?? 'name'),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.tonal(
                  onPressed: () async {
                    await _toggleNearMe();
                  },
                  child: Text(nearMe ? 'Near me: ON' : 'Near me: OFF'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (nearMe)
            SizedBox(
              height: 40,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, i) {
                  final r = radiusOptions[i];
                  final selected = r == radiusKm;
                  return ChoiceChip(label: Text('$r km'), selected: selected, onSelected: (_) => setState(() => radiusKm = r));
                },
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemCount: radiusOptions.length,
              ),
            ),
          const SizedBox(height: 8),
          Expanded(
            child: FutureBuilder<List<Place>>(
              future: _future,
              builder: (context, snap) {
                if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                var list = snap.data!;
                if (query.isNotEmpty) {
                  list = list.where((p) => p.name.toLowerCase().contains(query) || p.category.toLowerCase().contains(query)).toList();
                }
                if (selectedCategory != 'ALL') {
                  list = list.where((p) => p.category == selectedCategory).toList();
                }
                if (nearMe) {
                  list = list.where((p) {
                    final d = LocationService.distanceInKm(userLat, userLon, p.lat, p.lon);
                    return d <= radiusKm.toDouble();
                  }).toList();
                }
                if (list.isEmpty) return Center(child: Text(loc.noPlacesMatch));
                if (sort == 'distance' && (userLat != 0 || userLon != 0)) {
                  list.sort((a, b) {
                    final da = LocationService.distanceInKm(userLat, userLon, a.lat, a.lon);
                    final db = LocationService.distanceInKm(userLat, userLon, b.lat, b.lon);
                    return da.compareTo(db);
                  });
                } else {
                  list.sort((a, b) => a.name.compareTo(b.name));
                }
                return RefreshIndicator(
                  onRefresh: () async { setState(() {}); },
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (_, i) => PlaceCard(
                      place: list[i],
                      onTap: () => context.push('/place/${list[i].id}'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


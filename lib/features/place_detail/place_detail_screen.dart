import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:city_guide/gen_l10n/app_localizations.dart';
import '../../core/models/place.dart';
import '../../core/repo/place_repo.dart';
import '../../core/services/favorites_store.dart';
import '../../shared/widgets/map_preview.dart';

class PlaceDetailScreen extends StatefulWidget {
  final String id;
  const PlaceDetailScreen({super.key, required this.id});

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  final _favStore = FavoritesStore();
  Set<String> favs = {};

  @override
  void initState() {
    super.initState();
    _loadFavs();
  }

  Future<void> _loadFavs() async {
    favs = await _favStore.getPlaceFavs();
    if (mounted) setState(() {});
  }

  Future<void> _toggleFav(String id) async {
    await _favStore.togglePlace(id);
    await _loadFavs();
  }

  Future<void> _openMaps(String address) async {
    final q = Uri.encodeComponent(address);
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$q');
    if (await canLaunchUrl(uri)) { await launchUrl(uri, mode: LaunchMode.externalApplication); }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return FutureBuilder<List<Place>>(
      future: PlaceRepo().getPlaces(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final place = snap.data!.firstWhere((p) => p.id == widget.id);
        final isFav = favs.contains(place.id);
        return Scaffold(
          appBar: AppBar(
            title: Text(place.name),
            actions: [
              IconButton(
                tooltip: isFav ? 'Remove favorite' : 'Add favorite',
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_outline),
                onPressed: () => _toggleFav(place.id),
              ),
            ],
          ),
          body: ListView(
            children: [
              Hero(
                tag: 'place_${place.id}',
                child: Image.network(place.imageUrl, height: 220, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(height: 220, color: Colors.grey.shade300)),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(place.category, style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 8),
                    Text(place.description),
                    const SizedBox(height: 12),
                    Row(children: [const Icon(Icons.place), const SizedBox(width: 6), Expanded(child: Text(place.address))]),
                    const SizedBox(height: 16),
                    MapPreview(lat: place.lat, lon: place.lon, label: place.name),
                    const SizedBox(height: 16),
                    FilledButton.icon(onPressed: () => _openMaps(place.address), icon: const Icon(Icons.map), label: Text(loc.openInMaps)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


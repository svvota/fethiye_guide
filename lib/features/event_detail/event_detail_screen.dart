import 'package:flutter/material.dart';
import '../../core/models/event_item.dart';
import '../../core/repo/event_repo.dart';
import '../../core/services/favorites_store.dart';

class EventDetailScreen extends StatefulWidget {
  final String id;
  const EventDetailScreen({super.key, required this.id});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  final _favStore = FavoritesStore();
  Set<String> favs = {};

  @override
  void initState() {
    super.initState();
    _loadFavs();
  }

  Future<void> _loadFavs() async {
    favs = await _favStore.getEventFavs();
    if (mounted) setState(() {});
  }

  Future<void> _toggleFav(String id) async {
    await _favStore.toggleEvent(id);
    await _loadFavs();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EventItem>>(
      future: EventRepo().getEvents(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final event = snap.data!.firstWhere((e) => e.id == widget.id);
        final isFav = favs.contains(event.id);
        return Scaffold(
          appBar: AppBar(
            title: Text(event.title),
            actions: [
              IconButton(
                tooltip: isFav ? 'Remove favorite' : 'Add favorite',
                icon: Icon(isFav ? Icons.bookmark : Icons.bookmark_outline),
                onPressed: () => _toggleFav(event.id),
              ),
            ],
          ),
          body: ListView(
            children: [
              Hero(
                tag: 'event_${event.id}',
                child: Image.network(event.imageUrl, height: 220, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(height: 220, color: Colors.grey.shade300)),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.location, style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 8),
                    Text(event.description),
                    const SizedBox(height: 12),
                    Row(children: [const Icon(Icons.event), const SizedBox(width: 6), Text(event.date.toLocal().toString())]),
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


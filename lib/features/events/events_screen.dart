import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:city_guide/gen_l10n/app_localizations.dart';
import '../../core/models/event_item.dart';
import '../../core/repo/event_repo.dart';
import '../../shared/widgets/event_card.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late Future<List<EventItem>> _future;
  String query = '';
  String selectedCategory = 'ALL';
  List<String> categories = const [];

  @override
  void initState() {
    super.initState();
    _future = EventRepo().getEvents();
    _future.then((list) {
      final s = <String>{for (final e in list) e.category};
      setState(() => categories = ['ALL', ...s]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.eventsTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: loc.searchEventsHint),
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
          Expanded(
            child: FutureBuilder<List<EventItem>>(
              future: _future,
              builder: (context, snap) {
                if (!snap.hasData)
                  return const Center(child: CircularProgressIndicator());
                var list = snap.data!;
                if (query.isNotEmpty) {
                  list = list
                      .where((e) =>
                          e.title.toLowerCase().contains(query) ||
                          e.location.toLowerCase().contains(query))
                      .toList();
                }
                if (selectedCategory != 'ALL') {
                  list = list
                      .where((e) => e.category == selectedCategory)
                      .toList();
                }
                if (list.isEmpty) return Center(child: Text(loc.noEventsMatch));
                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (_, i) => EventCard(
                      event: list[i],
                      onTap: () => context.push('/event/${list[i].id}'),
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

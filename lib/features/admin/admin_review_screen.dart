import 'package:flutter/material.dart';
import '../../core/services/storage_repo.dart';

class AdminReviewScreen extends StatefulWidget {
  const AdminReviewScreen({super.key});

  @override
  State<AdminReviewScreen> createState() => _AdminReviewScreenState();
}

class _AdminReviewScreenState extends State<AdminReviewScreen> {
  final _store = StorageRepo();
  List<Map<String, dynamic>> placeSubs = [];
  List<Map<String, dynamic>> eventSubs = [];
  List<Map<String, dynamic>> approvedPlaces = [];
  List<Map<String, dynamic>> approvedEvents = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    placeSubs = await _store.readJsonList('place_submissions.json');
    eventSubs = await _store.readJsonList('event_submissions.json');
    approvedPlaces = await _store.readJsonList('approved_places.json');
    approvedEvents = await _store.readJsonList('approved_events.json');
    if (mounted) setState(() {});
  }

  Future<void> _approve(String type, Map<String, dynamic> obj) async {
    await _store.appendJsonItem(type == 'place' ? 'approved_places.json' : 'approved_events.json', obj);
    setState(() {
      if (type == 'place') placeSubs.remove(obj); else eventSubs.remove(obj);
    });
  }

  Future<void> _decline(String type, Map<String, dynamic> obj) async {
    setState(() {
      if (type == 'place') placeSubs.remove(obj); else eventSubs.remove(obj);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Review')),
      body: RefreshIndicator(
        onRefresh: () async => _load(),
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            const Text('Pending Places', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...placeSubs.map((p) => Card(
              child: ListTile(
                title: Text(p['name'] ?? 'Unnamed'),
                subtitle: Text(p['address'] ?? ''),
                trailing: Wrap(spacing: 8, children: [
                  IconButton(icon: const Icon(Icons.close), onPressed: () => _decline('place', p)),
                  IconButton(icon: const Icon(Icons.check), onPressed: () => _approve('place', p)),
                ]),
              ),
            )),
            const SizedBox(height: 16),
            const Text('Pending Events', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...eventSubs.map((e) => Card(
              child: ListTile(
                title: Text(e['title'] ?? 'Untitled'),
                subtitle: Text(e['location'] ?? ''),
                trailing: Wrap(spacing: 8, children: [
                  IconButton(icon: const Icon(Icons.close), onPressed: () => _decline('event', e)),
                  IconButton(icon: const Icon(Icons.check), onPressed: () => _approve('event', e)),
                ]),
              ),
            )),
            const SizedBox(height: 16),
            const Divider(),
            const Text('Approved (Local)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ...approvedPlaces.map((p) => ListTile(title: Text('Place: ${p['name']}'))),
            ...approvedEvents.map((e) => ListTile(title: Text('Event: ${e['title']}'))),
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/repo/place_repo.dart';
import '../../core/repo/event_repo.dart';
import '../../core/diag/data_diagnostics.dart';

class DebugTools extends StatefulWidget {
  const DebugTools({super.key});
  @override
  State<DebugTools> createState() => _DebugToolsState();
}

class _DebugToolsState extends State<DebugTools> {
  String placesLine = '—';
  String eventsLine = '—';

  String _fmtAge(int? ms) {
    if (ms == null) return '—';
    final s = (ms / 1000).toStringAsFixed(1);
    return '${s}s';
    // You could format to minutes if > 60s
  }

  Future<void> _probe() async {
    setState(() {
      placesLine = '…';
      eventsLine = '…';
    });

    final pr = await PlaceRepo().getPlaces();
    final er = await EventRepo().getEvents();

    final diag = DataDiagnostics.I;
    setState(() {
      placesLine =
          'source: ${diag.placesSource} • count: ${diag.placesCount} • cacheAge: ${_fmtAge(diag.placesCacheAgeMs)}';
      eventsLine =
          'source: ${diag.eventsSource} • count: ${diag.eventsCount} • cacheAge: ${_fmtAge(diag.eventsCacheAgeMs)}';
    });

    // Optional: also show what UI received after merges
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Rendered: places=${pr.length}, events=${er.length}')),
    );
  }

  Future<void> _clearCache() async {
    final box = await Hive.openBox('httpCache');
    final before = box.length;
    await box.clear();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('HTTP cache cleared ($before → 0)')),
    );
  }

  @override
  void initState() {
    super.initState();
    _probe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug Tools')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Places', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(placesLine),
          const SizedBox(height: 12),
          const Text('Events', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(eventsLine),
          const SizedBox(height: 20),
          Wrap(spacing: 12, children: [
            FilledButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Probe'),
              onPressed: _probe,
            ),
            FilledButton.icon(
              icon: const Icon(Icons.delete_sweep),
              label: const Text('Clear HTTP cache'),
              onPressed: _clearCache,
            ),
          ]),
        ]),
      ),
    );
  }
}

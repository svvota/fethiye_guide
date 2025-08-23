import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../core/services/storage_repo.dart';
import '../../core/services/location_service.dart';

class SubmitPlaceScreen extends StatefulWidget {
  const SubmitPlaceScreen({super.key});

  @override
  State<SubmitPlaceScreen> createState() => _SubmitPlaceScreenState();
}

class _SubmitPlaceScreenState extends State<SubmitPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _desc = TextEditingController();
  final _addr = TextEditingController();
  final _cat = TextEditingController(text: 'User');
  final _img = TextEditingController(text: 'https://picsum.photos/1200/600');
  double? _lat;
  double? _lon;
  bool _saving = false;

  Future<void> _useCurrentLocation() async {
    final pos = await LocationService().getPosition();
    if (pos != null) {
      setState(() { _lat = pos.latitude; _lon = pos.longitude; });
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location unavailable')));
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final obj = {
      "id": const Uuid().v4(),
      "name": _name.text.trim(),
      "description": _desc.text.trim(),
      "address": _addr.text.trim(),
      "imageUrl": _img.text.trim(),
      "category": _cat.text.trim(),
      "lat": _lat ?? 0.0,
      "lon": _lon ?? 0.0
    };
    await StorageRepo().appendJsonItem('place_submissions.json', obj);
    if (!mounted) return;
    setState(() => _saving = false);
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submit Place')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Name'), validator: (v) => v!.isEmpty ? 'Required' : null),
            TextFormField(controller: _desc, decoration: const InputDecoration(labelText: 'Description'), maxLines: 3, validator: (v) => v!.isEmpty ? 'Required' : null),
            TextFormField(controller: _addr, decoration: const InputDecoration(labelText: 'Address'), validator: (v) => v!.isEmpty ? 'Required' : null),
            TextFormField(controller: _cat, decoration: const InputDecoration(labelText: 'Category')),
            TextFormField(controller: _img, decoration: const InputDecoration(labelText: 'Image URL')),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: Text(_lat == null ? 'No location set' : 'Lat: ${_lat!.toStringAsFixed(4)}, Lon: ${_lon!.toStringAsFixed(4)}')),
              TextButton.icon(onPressed: _useCurrentLocation, icon: const Icon(Icons.my_location), label: const Text('Use current')),
            ]),
            const SizedBox(height: 12),
            FilledButton(onPressed: _saving ? null : _save, child: _saving ? const CircularProgressIndicator() : const Text('Submit')),
          ],
        ),
      ),
    );
  }
}


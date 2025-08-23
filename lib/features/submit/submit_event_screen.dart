import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../core/services/storage_repo.dart';

class SubmitEventScreen extends StatefulWidget {
  const SubmitEventScreen({super.key});

  @override
  State<SubmitEventScreen> createState() => _SubmitEventScreenState();
}

class _SubmitEventScreenState extends State<SubmitEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _loc = TextEditingController();
  final _img = TextEditingController(text: 'https://picsum.photos/1200/600');
  final _cat = TextEditingController(text: 'General');
  DateTime _date = DateTime.now().add(const Duration(days: 1));
  bool _saving = false;

  Future<void> _pickDate() async {
    final d = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
    if (d != null) setState(() => _date = d);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final obj = {
      "id": const Uuid().v4(),
      "title": _title.text.trim(),
      "description": _desc.text.trim(),
      "date": _date.toIso8601String(),
      "location": _loc.text.trim(),
      "imageUrl": _img.text.trim(),
      "category": _cat.text.trim()
    };
    await StorageRepo().appendJsonItem('event_submissions.json', obj);
    if (!mounted) return;
    setState(() => _saving = false);
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submit Event')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(controller: _title, decoration: const InputDecoration(labelText: 'Title'), validator: (v) => v!.isEmpty ? 'Required' : null),
            TextFormField(controller: _desc, decoration: const InputDecoration(labelText: 'Description'), maxLines: 3, validator: (v) => v!.isEmpty ? 'Required' : null),
            Row(children: [
              Expanded(child: Text('Date: ${_date.toLocal().toString().split(' ').first}')),
              TextButton(onPressed: _pickDate, child: const Text('Change'))
            ]),
            TextFormField(controller: _loc, decoration: const InputDecoration(labelText: 'Location'), validator: (v) => v!.isEmpty ? 'Required' : null),
            TextFormField(controller: _cat, decoration: const InputDecoration(labelText: 'Category')),
            TextFormField(controller: _img, decoration: const InputDecoration(labelText: 'Image URL')),
            const SizedBox(height: 12),
            FilledButton(onPressed: _saving ? null : _save, child: _saving ? const CircularProgressIndicator() : const Text('Submit')),
          ],
        ),
      ),
    );
  }
}


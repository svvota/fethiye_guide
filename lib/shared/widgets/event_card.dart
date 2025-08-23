import 'package:flutter/material.dart';
import '../../core/models/event_item.dart';

class EventCard extends StatelessWidget {
  final EventItem event;
  final VoidCallback? onTap;
  const EventCard({super.key, required this.event, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16/9,
              child: Hero(
                tag: 'event_${event.id}',
                child: Image.network(event.imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade300)),
              ),
            ),
            ListTile(
              title: Text(event.title),
              subtitle: Text('${event.location} • ${event.date.toLocal().toString().split(' ').first}'),
              trailing: const Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }
}


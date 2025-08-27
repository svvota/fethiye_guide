import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MapPreview extends StatelessWidget {
  final double lat;
  final double lon;
  final String label;
  final int zoom;
  const MapPreview({super.key, required this.lat, required this.lon, required this.label, this.zoom = 13});

  String get _imgUrl {
    return 'https://staticmap.openstreetmap.de/staticmap.php?center=\$lat,\$lon&zoom=\$zoom&size=800x400&markers=\$lat,\$lon,red-pushpin';
    // For production volume, consider a paid static maps service.
  }

  Future<void> _openMaps() async {
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=\$lat,\$lon (\$label)');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openMaps,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 16/9,
              child: Image.network(_imgUrl, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade300,
                  alignment: Alignment.center,
                  child: const Icon(Icons.map, size: 48),
                ),
              ),
            ),
            Positioned(
              right: 8, bottom: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black54, borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.open_in_new, color: Colors.white, size: 16),
                    SizedBox(width: 6),
                    Text('Open Map', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


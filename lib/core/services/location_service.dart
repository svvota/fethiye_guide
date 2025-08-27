import 'dart:math' as dm;
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position?> getPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  static double distanceInKm(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371;
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = (dm.sin(dLat/2) * dm.sin(dLat/2)) +
      dm.cos(_deg2rad(lat1)) * dm.cos(_deg2rad(lat2)) *
      (dm.sin(dLon/2) * dm.sin(dLon/2));
    final c = 2 * dm.atan2(dm.sqrt(a), dm.sqrt(1-a));
    return R * c;
  }
}

double _deg2rad(double d) => d * (3.141592653589793 / 180.0);


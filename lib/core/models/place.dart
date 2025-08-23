class Place {
  final String id;
  final String name;
  final String description;
  final String address;
  final String imageUrl;
  final String category;
  final double lat;
  final double lon;

  const Place({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.imageUrl,
    required this.category,
    required this.lat,
    required this.lon,
  });

  factory Place.fromJson(Map<String, dynamic> j) => Place(
    id: j['id'],
    name: j['name'],
    description: j['description'],
    address: j['address'],
    imageUrl: j['imageUrl'],
    category: j['category'],
    lat: (j['lat'] ?? 0).toDouble(),
    lon: (j['lon'] ?? 0).toDouble(),
  );
}


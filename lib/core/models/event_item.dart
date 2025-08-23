class EventItem {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final String imageUrl;
  final String category;

  const EventItem({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.imageUrl,
    required this.category,
  });

  factory EventItem.fromJson(Map<String, dynamic> j) => EventItem(
    id: j['id'],
    title: j['title'],
    description: j['description'],
    date: DateTime.parse(j['date']),
    location: j['location'],
    imageUrl: j['imageUrl'],
    category: j['category'] ?? 'General',
  );
}


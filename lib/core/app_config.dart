enum DataSource { localOnly, remotePreferred }

class AppConfig {
  static DataSource dataSource = DataSource.remotePreferred;

  static String? placesUrl = 'https://fethiye-city-guide.web.app/places.json';
  static String? eventsUrl = 'https://fethiye-city-guide.web.app/events.json';
}

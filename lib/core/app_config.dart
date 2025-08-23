enum DataSource { localOnly, remotePreferred }

class AppConfig {
  static DataSource dataSource = DataSource.localOnly;
  static String? placesUrl;
  static String? eventsUrl;
}


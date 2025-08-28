// lib/core/diag/data_diagnostics.dart
class DataDiagnostics {
  static final DataDiagnostics I = DataDiagnostics._();
  DataDiagnostics._();

  // places
  String placesSource = '—'; // local | cache | network | error
  int placesCount = -1;
  int? placesCacheAgeMs;

  // events
  String eventsSource = '—';
  int eventsCount = -1;
  int? eventsCacheAgeMs;

  void setPlaces(
      {required String source, required int count, int? cacheAgeMs}) {
    placesSource = source;
    placesCount = count;
    placesCacheAgeMs = cacheAgeMs;
  }

  void setEvents(
      {required String source, required int count, int? cacheAgeMs}) {
    eventsSource = source;
    eventsCount = count;
    eventsCacheAgeMs = cacheAgeMs;
  }
}

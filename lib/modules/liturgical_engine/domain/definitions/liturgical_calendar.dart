import 'celebration_definition.dart';

/// Represents a liturgical calendar, which provides a key and a method to retrieve celebrations for a given year.
abstract interface class LiturgicalCalendar {
  String get key;

  /// Returns an iterable of [CelebrationDefinition] objects for the specified year, representing the celebrations in that year.
  Iterable<CelebrationDefinition> celebrationsForYear(int year);
}

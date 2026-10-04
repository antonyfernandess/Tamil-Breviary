import '../domain/entities/liturgical_day.dart';
import '../domain/entities/liturgical_year.dart';

/// Interface for the LiturgicalEngine, defining methods to retrieve liturgical days and years.
abstract interface class LiturgicalEngine {
  LiturgicalDay getDay(DateTime date);
  LiturgicalYear getYear(int year);
}

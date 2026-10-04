import '../../domain/entities/liturgical_day.dart';
import '../../domain/entities/liturgical_year.dart';

abstract interface class CalendarService {
  LiturgicalDay getDay(DateTime date);
  LiturgicalYear getYear(int year);
}

import '../../domain/entities/liturgical_day.dart';
import '../../domain/entities/liturgical_year.dart';
import '../liturgical_engine.dart';
import 'calendar_service.dart';

class CalendarServiceImpl implements CalendarService {
  final LiturgicalEngine engine;

  CalendarServiceImpl({required this.engine});

  @override
  LiturgicalDay getDay(DateTime date) => engine.getDay(date);

  @override
  LiturgicalYear getYear(int year) => engine.getYear(year);
}

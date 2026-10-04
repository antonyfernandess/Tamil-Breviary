import 'calendar_settings.dart';

class CalendarContext {
  final int year;
  final CalendarSettings settings;

  const CalendarContext({
    required this.year,
    required this.settings,
  });
}

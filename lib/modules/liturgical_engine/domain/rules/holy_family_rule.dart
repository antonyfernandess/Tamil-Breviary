import '../calculations/liturgical_date.dart';
import 'calendar_rule.dart';
import '../value_objects/calendar_context.dart';

class HolyFamilyRule implements CalendarRule {
  const HolyFamilyRule();

  @override
  DateTime resolve(CalendarContext context) {
    final december25 = DateTime.utc(context.year, 12, 25);
    if (december25.weekday == DateTime.sunday) {
      return DateTime.utc(context.year, 12, 30);
    }
    for (var offset = 1; offset <= 7; offset++) {
      final candidate = LiturgicalDate.addDays(december25, offset);
      if (candidate.weekday == DateTime.sunday) return candidate;
    }
    return DateTime.utc(context.year, 12, 30);
  }
}

import 'calendar_rule.dart';
import '../calculations/liturgical_anchors.dart';
import '../value_objects/calendar_context.dart';

/// Resolves a date as an offset (in days) from Easter Sunday.
/// Use negative [offsetDays] for dates before Easter (e.g. Ash
/// Wednesday, Palm Sunday) and positive for dates after (e.g.
/// Ascension, Pentecost).
class EasterBasedRule implements CalendarRule {
  final int offsetDays;

  const EasterBasedRule({required this.offsetDays});

  @override
  DateTime resolve(CalendarContext context) {
    final easterSunday = LiturgicalAnchors.forYear(
      context.year,
      context.settings,
    ).easter;
    return DateTime.utc(
      easterSunday.year,
      easterSunday.month,
      easterSunday.day + offsetDays,
    );
  }
}

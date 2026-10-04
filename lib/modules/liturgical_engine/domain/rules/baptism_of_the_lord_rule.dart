import '../calculations/liturgical_anchors.dart';
import '../value_objects/calendar_context.dart';
import 'calendar_rule.dart';

class BaptismOfTheLordRule implements CalendarRule {
  const BaptismOfTheLordRule();

  @override
  DateTime resolve(CalendarContext context) {
    return LiturgicalAnchors.forYear(
      context.year,
      context.settings,
    ).baptismOfTheLord;
  }
}

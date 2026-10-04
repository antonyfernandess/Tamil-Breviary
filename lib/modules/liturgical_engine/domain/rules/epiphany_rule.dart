import '../value_objects/calendar_context.dart';
import '../calculations/liturgical_anchors.dart';
import 'calendar_rule.dart';

class EpiphanyRule implements CalendarRule {
  const EpiphanyRule();

  @override
  DateTime resolve(CalendarContext context) {
    return LiturgicalAnchors.forYear(
      context.year,
      context.settings,
    ).epiphany;
  }
}

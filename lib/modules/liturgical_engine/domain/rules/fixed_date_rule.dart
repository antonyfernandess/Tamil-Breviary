import '../value_objects/calendar_context.dart';
import 'calendar_rule.dart';

/// A celebration that falls on the same month/day every year.
///
/// The result is always a UTC date. If the day does not exist in the given
/// year (e.g. 29 February in a common year) the last day of the month is
/// used instead of letting [DateTime] silently roll over into March.
class FixedDateRule implements CalendarRule {
  const FixedDateRule({required this.month, required this.day})
    : assert(month >= 1 && month <= 12, 'month must be 1-12'),
      assert(day >= 1 && day <= 31, 'day must be 1-31');

  final int month;
  final int day;

  @override
  DateTime resolve(CalendarContext context) {
    final date = DateTime.utc(context.year, month, day);
    if (date.month == month) return date;

    // Day 0 of the next month is the last day of this month.
    return DateTime.utc(context.year, month + 1, 0);
  }
}

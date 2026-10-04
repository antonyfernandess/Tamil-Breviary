import '../value_objects/calendar_context.dart';

abstract interface class CalendarRule{
  // Returns the date of the celebration for the given year.
  DateTime resolve(CalendarContext context);
}

import '../../enums/liturgical_season.dart';
import '../../value_objects/calendar_settings.dart';
import '../liturgical_anchors.dart';
import '../liturgical_date.dart';
import 'liturgical_season_calculator.dart';

/// Identifies the days that rank above solemnities in the Table of
/// Liturgical Days (Christmas, Epiphany, Ascension, Pentecost, Ash
/// Wednesday, Holy Week, the Easter Octave and the Sundays of Advent, Lent
/// and Easter).
///
/// Sundays of Ordinary Time and of Christmas Time are deliberately *not*
/// privileged: solemnities and feasts of the Lord take precedence over them.
class PrivilegedDayCalculator {
  const PrivilegedDayCalculator._();

  static bool isPrivileged(
    DateTime date, {
    CalendarSettings settings = CalendarSettings.roman,
  }) {
    final day = LiturgicalDate.normalize(date);
    final anchors = LiturgicalAnchors.forYear(day.year, settings);
    final octaveEnd = LiturgicalDate.addDays(anchors.easter, 7);

    if (day.month == 12 && day.day == 25) return true;
    if (_isSameDate(day, anchors.epiphany)) return true;
    if (_isSameDate(day, anchors.ascension)) return true;
    if (_isSameDate(day, anchors.pentecost)) return true;
    if (_isSameDate(day, anchors.ashWednesday)) return true;

    // Palm Sunday through Holy Saturday.
    if (!day.isBefore(anchors.palmSunday) && day.isBefore(anchors.easter)) {
      return true;
    }

    // Easter Sunday through the Sunday of the octave.
    if (!day.isBefore(anchors.easter) && !day.isAfter(octaveEnd)) return true;

    if (day.weekday == DateTime.sunday) {
      final season = LiturgicalSeasonCalculator.resolve(
        day,
        settings: settings,
      );
      return season == LiturgicalSeason.advent ||
          season == LiturgicalSeason.lent ||
          season == LiturgicalSeason.easter;
    }

    return false;
  }

  static bool _isSameDate(DateTime first, DateTime second) =>
      first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}

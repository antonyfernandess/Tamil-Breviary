import '../../enums/liturgical_season.dart';
import '../../value_objects/calendar_settings.dart';
import '../liturgical_anchors.dart';
import '../liturgical_date.dart';
import 'liturgical_season_calculator.dart';

class LiturgicalWeekCalculator {
  const LiturgicalWeekCalculator._();

  static int? weekOf(
    DateTime date, {
    CalendarSettings settings = CalendarSettings.roman,
  }) {
    final day = LiturgicalDate.normalize(date);
    final season = LiturgicalSeasonCalculator.resolve(day, settings: settings);
    final anchors = LiturgicalAnchors.forYear(day.year, settings);

    return switch (season) {
      LiturgicalSeason.advent => _weekFromSunday(
        day,
        anchors.firstAdventSunday,
      ),
      LiturgicalSeason.lent => _lentWeek(day, anchors),
      LiturgicalSeason.easter => _weekFromSunday(day, anchors.easter),
      LiturgicalSeason.ordinaryTime => _ordinaryTimeWeek(day, anchors),
      LiturgicalSeason.christmas || LiturgicalSeason.sacredTriduum => null,
    };
  }

  /// Ash Wednesday and the days after it belong to no numbered week, so
  /// they return `null`; week 1 starts on the First Sunday of Lent.
  static int? _lentWeek(DateTime day, LiturgicalAnchors anchors) {
    final firstSundayOfLent = _firstSundayOnOrAfter(anchors.ashWednesday);
    if (day.isBefore(firstSundayOfLent)) return null;
    return _weekFromSunday(day, firstSundayOfLent);
  }

  static int _ordinaryTimeWeek(DateTime day, LiturgicalAnchors anchors) {
    final firstSundayAfterBaptism = _firstSundayAfter(
      anchors.baptismOfTheLord,
    );
    if (day.isBefore(anchors.ashWednesday)) {
      if (day.isBefore(firstSundayAfterBaptism)) return 1;
      return 2 + LiturgicalDate.daysBetween(
            firstSundayAfterBaptism,
            _mostRecentSunday(day),
          ) ~/
          DateTime.daysPerWeek;
    }

    final sunday = _mostRecentSunday(day);
    return 34 -
        LiturgicalDate.daysBetween(sunday, anchors.christTheKing) ~/
            DateTime.daysPerWeek;
  }

  static int _weekFromSunday(DateTime day, DateTime firstSunday) {
    return 1 +
        LiturgicalDate.daysBetween(firstSunday, _mostRecentSunday(day)) ~/
            DateTime.daysPerWeek;
  }

  static DateTime _mostRecentSunday(DateTime date) {
    final day = LiturgicalDate.normalize(date);
    return LiturgicalDate.addDays(day, -(day.weekday % DateTime.daysPerWeek));
  }

  static DateTime _firstSundayOnOrAfter(DateTime date) {
    final day = LiturgicalDate.normalize(date);
    final daysUntilSunday = (DateTime.daysPerWeek - day.weekday) %
        DateTime.daysPerWeek;
    return LiturgicalDate.addDays(day, daysUntilSunday);
  }

  static DateTime _firstSundayAfter(DateTime date) {
    final day = LiturgicalDate.normalize(date);
    final daysUntilSunday =
        DateTime.daysPerWeek - (day.weekday % DateTime.daysPerWeek);
    return LiturgicalDate.addDays(day, daysUntilSunday);
  }
}

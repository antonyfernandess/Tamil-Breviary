import '../easter/easter_calculator.dart';
import '../../enums/liturgical_season.dart';

/// Determines which liturgical season a given date falls in.
///
/// Lent and Easter season are anchored to Easter Sunday (via
/// [EasterCalculator]). Advent and Christmas are anchored to
/// December 25. Christmas season crosses the Jan 1 boundary, so
/// this checks both "this year's Christmas into next year's
/// Baptism of the Lord" and "last year's Christmas into this
/// year's Baptism of the Lord" depending where the date falls.
class LiturgicalSeasonCalculator {
  static LiturgicalSeason resolve(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    final year = d.year;

    final easter = EasterCalculator.forYear(year);
    final ashWednesday = easter.subtract(const Duration(days: 46));
    final holyThursday = easter.subtract(const Duration(days: 3));
    final pentecost = easter.add(const Duration(days: 49));

    final adventStart = _firstAdventSunday(year);
    final christmas = DateTime(year, 12, 25);
    final baptismThisYear = _baptismOfTheLord(year);
    final baptismNextYear = _baptismOfTheLord(year + 1);
    final christmasLastYear = DateTime(year - 1, 12, 25);

    // Sacred Triduum: Holy Thursday through Holy Saturday.
    // Easter Sunday itself belongs to the Easter season, checked next.
    if (!d.isBefore(holyThursday) && d.isBefore(easter)) {
      return LiturgicalSeason.sacredTriduum;
    }

    // Easter season: Easter Sunday through Pentecost, inclusive.
    if (!d.isBefore(easter) && !d.isAfter(pentecost)) {
      return LiturgicalSeason.easter;
    }

    // Lent: Ash Wednesday through the day before Holy Thursday.
    if (!d.isBefore(ashWednesday) && d.isBefore(holyThursday)) {
      return LiturgicalSeason.lent;
    }

    // Advent: first Sunday of Advent through Dec 24.
    if (!d.isBefore(adventStart) && d.isBefore(christmas)) {
      return LiturgicalSeason.advent;
    }

    // Christmas season starting this year, running into next year's Baptism.
    if (!d.isBefore(christmas) && !d.isAfter(baptismNextYear)) {
      return LiturgicalSeason.christmas;
    }

    // Christmas season carried over from last year, running into this year's Baptism.
    if (!d.isBefore(christmasLastYear) && !d.isAfter(baptismThisYear)) {
      return LiturgicalSeason.christmas;
    }

    // Easter season is defined as Easter Sunday through Pentecost Sunday inclusive.
    // The earlier check already catches this range, so we do not need any extra logic here.

    // Everything else — after Baptism/before Ash Wednesday,
    // and after Pentecost/before Advent — is Ordinary Time.
    return LiturgicalSeason.ordinaryTime;
  }

  /// The 1st Sunday of Advent: the Sunday closest to Nov 30,
  /// equivalently 4 Sundays before Christmas Day.
  static DateTime _firstAdventSunday(int year) {
    final christmas = DateTime(year, 12, 25);
    final daysSincePrecedingSunday = christmas.weekday % 7; // Sunday.weekday == 7 -> 0
    final fourthAdventSunday = christmas.subtract(Duration(days: daysSincePrecedingSunday));
    return fourthAdventSunday.subtract(const Duration(days: 21));
  }

  /// Epiphany is fixed at Jan 6. The Baptism of the Lord is the
  /// Sunday that follows it — unless Jan 6 itself is a Sunday, in
  /// which case Baptism is celebrated the next day.
  static DateTime _baptismOfTheLord(int year) {
    final epiphany = DateTime(year, 1, 6);
    if (epiphany.weekday == DateTime.sunday) {
      return epiphany.add(const Duration(days: 1));
    }
    final daysUntilSunday = 7 - epiphany.weekday; /// Calculate the number of days until the next Sunday after Epiphany.
    return epiphany.add(Duration(days: daysUntilSunday)); /// Return the date of the Baptism of the Lord, which is the Sunday following Epiphany (or the next day if Epiphany is a Sunday).
  }
}
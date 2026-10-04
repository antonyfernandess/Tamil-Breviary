import '../../enums/liturgical_season.dart';
import '../../value_objects/calendar_settings.dart';
import '../liturgical_anchors.dart';
import '../liturgical_date.dart';

class LiturgicalSeasonCalculator {
  const LiturgicalSeasonCalculator._();

  static LiturgicalSeason resolve(
    DateTime date, {
    CalendarSettings settings = CalendarSettings.roman,
  }) {
    final day = LiturgicalDate.normalize(date);
    final anchors = LiturgicalAnchors.forYear(day.year, settings);
    final christmas = DateTime.utc(day.year, 12, 25);

    if (!day.isBefore(anchors.holyThursday) && day.isBefore(anchors.easter)) {
      return LiturgicalSeason.sacredTriduum;
    }

    if (!day.isBefore(anchors.easter) && !day.isAfter(anchors.pentecost)) {
      return LiturgicalSeason.easter;
    }

    if (!day.isBefore(anchors.ashWednesday) &&
        day.isBefore(anchors.holyThursday)) {
      return LiturgicalSeason.lent;
    }

    if (!day.isBefore(anchors.firstAdventSunday) && day.isBefore(christmas)) {
      return LiturgicalSeason.advent;
    }

    // 25-31 December belong to this year's Christmas Time...
    if (!day.isBefore(christmas)) return LiturgicalSeason.christmas;

    // ...and 1 January up to the Baptism of the Lord to the same season,
    // which began on 25 December of the previous year.
    if (!day.isAfter(anchors.baptismOfTheLord)) {
      return LiturgicalSeason.christmas;
    }

    return LiturgicalSeason.ordinaryTime;
  }
}

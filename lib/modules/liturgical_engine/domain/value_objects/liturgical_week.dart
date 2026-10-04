import '../enums/liturgical_season.dart';


class LiturgicalWeek {
  final LiturgicalSeason season;
  final int week;

  const LiturgicalWeek({
    required this.season,
    required this.week,
  });
}

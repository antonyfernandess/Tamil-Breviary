import '../value_objects/calendar_settings.dart';
import 'easter/easter_calculator.dart';
import 'liturgical_date.dart';

/// The key dates of one liturgical year, derived from Easter and Advent.
///
/// Instances are immutable and memoized per `(year, settings)`, because
/// every season, week and precedence lookup needs them.
class LiturgicalAnchors {
  LiturgicalAnchors._({
    required this.year,
    required this.settings,
    required this.easter,
    required this.firstAdventSunday,
    required this.epiphany,
    required this.baptismOfTheLord,
    required this.ascension,
    required this.pentecost,
    required this.corpusChristi,
    required this.ashWednesday,
    required this.holyThursday,
    required this.palmSunday,
    required this.christTheKing,
  });

  static final Map<(int, CalendarSettings), LiturgicalAnchors> _cache = {};

  factory LiturgicalAnchors.forYear(
    int year, [
    CalendarSettings settings = CalendarSettings.roman,
  ]) {
    return _cache.putIfAbsent(
      (year, settings),
      () => LiturgicalAnchors._build(year, settings),
    );
  }

  static LiturgicalAnchors _build(int year, CalendarSettings settings) {
    final easter = LiturgicalDate.normalize(EasterCalculator.forYear(year));
    final firstAdvent = _firstAdventSunday(year);
    final epiphany = _epiphany(year, settings);

    return LiturgicalAnchors._(
      year: year,
      settings: settings,
      easter: easter,
      firstAdventSunday: firstAdvent,
      epiphany: epiphany,
      baptismOfTheLord: _baptism(epiphany),
      ascension: LiturgicalDate.addDays(
        easter,
        settings.transferAscension ? 42 : 39,
      ),
      pentecost: LiturgicalDate.addDays(easter, 49),
      corpusChristi: LiturgicalDate.addDays(
        easter,
        settings.transferCorpusChristi ? 63 : 60,
      ),
      ashWednesday: LiturgicalDate.addDays(easter, -46),
      holyThursday: LiturgicalDate.addDays(easter, -3),
      palmSunday: LiturgicalDate.addDays(easter, -7),
      christTheKing: LiturgicalDate.addDays(firstAdvent, -7),
    );
  }

  final int year;
  final CalendarSettings settings;
  final DateTime easter;
  final DateTime firstAdventSunday;
  final DateTime epiphany;
  final DateTime baptismOfTheLord;
  final DateTime ascension;
  final DateTime pentecost;
  final DateTime corpusChristi;
  final DateTime ashWednesday;
  final DateTime holyThursday;
  final DateTime palmSunday;
  final DateTime christTheKing;

  static DateTime _firstAdventSunday(int year) {
    final december24 = DateTime.utc(year, 12, 24);
    // The 4th Sunday of Advent is the Sunday on or before 24 December.
    final fourthAdventSunday = LiturgicalDate.addDays(
      december24,
      -(december24.weekday % DateTime.daysPerWeek),
    );
    return LiturgicalDate.addDays(fourthAdventSunday, -21);
  }

  static DateTime _epiphany(int year, CalendarSettings settings) {
    if (!settings.transferEpiphany) return DateTime.utc(year, 1, 6);

    // Transferred Epiphany: the Sunday between 2 and 8 January.
    for (var day = 2; day <= 8; day++) {
      final candidate = DateTime.utc(year, 1, day);
      if (candidate.weekday == DateTime.sunday) return candidate;
    }
    throw StateError('Could not resolve Epiphany for $year.');
  }

  /// Baptism of the Lord follows the General Norms:
  ///  * the Sunday after Epiphany, or
  ///  * the Monday after Epiphany when a transferred Epiphany falls on
  ///    7 or 8 January.
  /// With a fixed 6 January Epiphany that is the first Sunday strictly after
  /// it (7-13 January), so a Sunday 6 January gives 13 January.
  static DateTime _baptism(DateTime epiphany) {
    if (epiphany.day >= 7) return LiturgicalDate.addDays(epiphany, 1);

    final daysUntilSunday =
        DateTime.daysPerWeek - (epiphany.weekday % DateTime.daysPerWeek);
    return LiturgicalDate.addDays(epiphany, daysUntilSunday);
  }
}

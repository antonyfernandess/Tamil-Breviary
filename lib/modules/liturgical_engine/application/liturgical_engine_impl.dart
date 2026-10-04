import '../domain/calculations/liturgical_anchors.dart';
import '../domain/calculations/liturgical_date.dart';
import '../domain/calculations/easter/easter_algorithm.dart';
import '../domain/calculations/season/liturgical_season_calculator.dart';
import '../domain/calculations/season/liturgical_week_calculator.dart';
import '../domain/calculations/season/privileged_day_calculator.dart';
import '../domain/definitions/celebration_definition.dart';
import '../domain/entities/liturgical_day.dart';
import '../domain/entities/liturgical_year.dart';
import '../domain/entities/optional_memorial.dart';
import '../domain/enums/liturgical_color.dart';
import '../domain/enums/liturgical_rank.dart';
import '../domain/enums/liturgical_season.dart';
import '../domain/value_objects/calendar_settings.dart';
import '../domain/value_objects/celebration_key.dart';
import 'celebration_generator.dart';
import 'liturgical_engine.dart';
import 'resolved_celebrations.dart';

/// Implementation of [LiturgicalEngine]: generates the calendar for a year
/// from the [CelebrationGenerator] and resolves collisions using the Table
/// of Liturgical Days.
class LiturgicalEngineImpl implements LiturgicalEngine {
  LiturgicalEngineImpl({required this.generator})
    : settings = generator.settings;

  final CelebrationGenerator generator;
  final CalendarSettings settings;
  final Map<int, LiturgicalYear> _yearCache = {};

  /// Celebrations that define a privileged day themselves. They must never
  /// be "transferred away" from their own date.
  static const _selfDefiningKeys = {
    'christmas',
    'nativity_of_the_lord',
    'ash_wednesday',
    'palm_sunday',
    'holy_thursday',
    'good_friday',
    'easter_sunday',
    'ascension',
    'pentecost',
    'epiphany',
    'baptism_of_the_lord',
    'trinity_sunday',
    'corpus_christi',
  };

  /// Celebrations that win a same-rank collision by design: the movable
  /// Solemnities of the Lord and the movable Marian memorials take
  /// precedence over fixed celebrations of the same rank.
  static const _winsTieKeys = {
    'sacred_heart_of_jesus',
    'christ_the_king',
    'corpus_christi',
    'immaculate_heart_of_mary',
    'mary_mother_of_the_church',
  };

  /// Keys under which St Joseph can appear (the DB uses the long form).
  static const _josephKeys = {
    'saint_joseph',
    'saint_joseph_husband_of_the_blessed_virgin_mary',
  };

  /// Retrieves the liturgical day for a given date.
  @override
  LiturgicalDay getDay(DateTime date) {
    final normalized = LiturgicalDate.normalize(date);
    final day = getYear(normalized.year).getDay(normalized);
    if (day == null) {
      throw StateError('No liturgical day generated for $normalized.');
    }
    return day;
  }

  /// Retrieves (and caches) the liturgical year for [year].
  ///
  /// Throws a [RangeError] outside the Gregorian range supported by the
  /// Easter algorithm.
  @override
  LiturgicalYear getYear(int year) {
    if (year < EasterAlgorithm.minYear || year > EasterAlgorithm.maxYear) {
      throw RangeError.range(
        year,
        EasterAlgorithm.minYear,
        EasterAlgorithm.maxYear,
        'year',
      );
    }
    return _yearCache.putIfAbsent(year, () => _generateYear(year));
  }

  LiturgicalYear _generateYear(int year) {
    final liturgicalYear = LiturgicalYear(year: year);
    final resolvedByDate = _applyPrecedenceRules(generator.generate(year));

    final startOfYear = DateTime.utc(year, 1, 1);
    final startOfNextYear = DateTime.utc(year + 1, 1, 1);
    final totalDays = startOfNextYear.difference(startOfYear).inDays;

    for (var i = 0; i < totalDays; i++) {
      final date = LiturgicalDate.addDays(startOfYear, i);
      liturgicalYear.addDay(_buildDay(date, resolvedByDate[date]));
    }

    return liturgicalYear;
  }

  // ---------------------------------------------------------------------
  // Precedence
  // ---------------------------------------------------------------------

  /// Resolves every date to at most one primary celebration (or a set of
  /// optional memorials), moving displaced solemnities to a free day.
  ///
  /// Rules applied (Table of Liturgical Days):
  ///  * On *privileged* days (see [PrivilegedDayCalculator]) only
  ///    self-defining celebrations stay; solemnities are transferred and
  ///    everything else is dropped.
  ///  * On Sundays of Ordinary Time and Christmas Time, solemnities and
  ///    feasts of the Lord win; feasts and memorials yield.
  ///  * On Lenten weekdays and 17-24 December, memorials become optional.
  ///  * Optional memorials never apply on Sundays or privileged days.
  Map<DateTime, ResolvedCelebrations> _applyPrecedenceRules(
    List<ResolvedCelebrations> resolved,
  ) {
    final byDate = <DateTime, ResolvedCelebrations>{};
    final sorted = [...resolved]..sort((a, b) => a.date.compareTo(b.date));

    // Dates already holding a feast or higher. A transferred solemnity may
    // never be moved onto them.
    final occupiedDates = <DateTime>{
      for (final entry in sorted)
        if (_obligatoryOf(entry).any((c) => _occupiesDay(c.rank)))
          _normalize(entry.date),
    };
    // `anticipate`: a solemnity displaced by another solemnity on the same
    // date moves to the preceding free day (e.g. St John the Baptist when
    // it coincides with the Sacred Heart); otherwise to the next free day.
    final transferred = <(DateTime, CelebrationDefinition, bool)>[];

    for (final entry in sorted) {
      final date = _normalize(entry.date);
      final candidates = _obligatoryOf(entry)..sort(_compare);
      final optionals = [...entry.optionalMemorials];
      final isSunday = date.weekday == DateTime.sunday;
      final privileged = PrivilegedDayCalculator.isPrivileged(
        date,
        settings: settings,
      );
      final season = LiturgicalSeasonCalculator.resolve(
        date,
        settings: settings,
      );
      final optionalsAllowed = !isSunday && !privileged;

      var eligible = candidates;
      if (privileged) {
        eligible = <CelebrationDefinition>[];
        for (final candidate in candidates) {
          if (_isSelfDefining(candidate)) {
            eligible.add(candidate);
          } else if (candidate.rank == LiturgicalRank.solemnity) {
            transferred.add((date, candidate, false));
          }
        }
      } else if (isSunday) {
        // Sunday of Ordinary Time / Christmas Time.
        eligible = candidates.where(_survivesOrdinarySunday).toList();
      } else if (_demotesMemorials(date, season)) {
        optionals.addAll(
          candidates.where((c) => c.rank == LiturgicalRank.memorial),
        );
        eligible = candidates
            .where((c) => c.rank != LiturgicalRank.memorial)
            .toList();
      }

      if (eligible.isEmpty) {
        if (optionalsAllowed && optionals.isNotEmpty) {
          byDate[date] = ResolvedCelebrations(
            date: date,
            primary: null,
            optionalMemorials: optionals,
          );
        }
        continue;
      }

      eligible.sort(_compare);
      final winner = eligible.first;
      for (final candidate in eligible.skip(1)) {
        // The same celebration listed twice (e.g. the Nativity of the Lord in
        // both the Roman calendar and the database) is not a collision.
        if (candidate.key.value == winner.key.value) continue;
        if (candidate.rank == LiturgicalRank.solemnity) {
          transferred.add((date, candidate, true));
        }
      }

      byDate[date] = ResolvedCelebrations(date: date, primary: eligible.first);
    }

    for (final (blockedDate, celebration, anticipate) in transferred) {
      final targetDate = _transferTarget(
        blockedDate,
        celebration,
        byDate,
        occupiedDates,
        anticipate: anticipate,
      );
      byDate[targetDate] = ResolvedCelebrations(
        date: targetDate,
        primary: celebration,
      );
    }

    return byDate;
  }

  List<CelebrationDefinition> _obligatoryOf(ResolvedCelebrations entry) => [
    if (entry.primary != null) entry.primary!,
    ...entry.additionalObligatory,
  ];

  int _compare(CelebrationDefinition a, CelebrationDefinition b) {
    final rankOrder = generator.precedence.compare(a, b);
    if (rankOrder != 0) return rankOrder;

    final tieOrder = _tieRank(a).compareTo(_tieRank(b));
    if (tieOrder != 0) return tieOrder;

    return a.key.value.compareTo(b.key.value);
  }

  /// Lower wins a same-rank collision:
  ///  0. self-defining celebrations and the movable ones in [_winsTieKeys];
  ///  1. national-proper celebrations (the database prefixes them with
  ///     "IN "), e.g. St Gonsalo Garcia replaces the general memorial of
  ///     Saints Paul Miki and companions on 6 February in India;
  ///  2. everything else.
  int _tieRank(CelebrationDefinition c) {
    if (_isSelfDefining(c) || _winsTieKeys.contains(c.key.value)) return 0;
    if (c.key.value.startsWith('in_')) return 1;
    return 2;
  }

  bool _isSelfDefining(CelebrationDefinition c) =>
      _selfDefiningKeys.contains(c.key.value) ||
      c.rank == LiturgicalRank.privilegedDay;

  bool _survivesOrdinarySunday(CelebrationDefinition c) =>
      c.rank == LiturgicalRank.privilegedDay ||
      c.rank == LiturgicalRank.solemnity ||
      c.rank == LiturgicalRank.feastOfTheLord;

  /// Ranks that occupy a day for the purpose of transferring a solemnity
  /// (nos. 1-8 of the Table of Liturgical Days).
  bool _occupiesDay(LiturgicalRank rank) =>
      rank == LiturgicalRank.privilegedDay ||
      rank == LiturgicalRank.solemnity ||
      rank == LiturgicalRank.feastOfTheLord ||
      rank == LiturgicalRank.feast;

  /// Obligatory memorials are reduced to optional ones on weekdays of Lent
  /// and on 17-24 December.
  bool _demotesMemorials(DateTime date, LiturgicalSeason season) {
    if (season == LiturgicalSeason.lent) return true;
    return season == LiturgicalSeason.advent &&
        date.month == 12 &&
        date.day >= 17;
  }

  DateTime _transferTarget(
    DateTime blockedDate,
    CelebrationDefinition celebration,
    Map<DateTime, ResolvedCelebrations> placed,
    Set<DateTime> occupiedDates, {
    required bool anticipate,
  }) {
    // St Joseph falling in Holy Week moves back to the preceding Saturday.
    if (_josephKeys.contains(celebration.key.value)) {
      final anchors = LiturgicalAnchors.forYear(blockedDate.year, settings);
      final inHolyWeek =
          !blockedDate.isBefore(anchors.palmSunday) &&
          blockedDate.isBefore(anchors.easter);
      if (inHolyWeek) return LiturgicalDate.addDays(anchors.palmSunday, -1);
    }

    if (anticipate) {
      var earlier = LiturgicalDate.addDays(blockedDate, -1);
      for (var i = 0; i < 7; i++) {
        if (!_isBlockedForTransfer(earlier, placed, occupiedDates)) {
          return earlier;
        }
        earlier = LiturgicalDate.addDays(earlier, -1);
      }
    }

    // Otherwise: the nearest following day not occupied by nos. 1-8.
    var candidate = LiturgicalDate.addDays(blockedDate, 1);
    while (_isBlockedForTransfer(candidate, placed, occupiedDates)) {
      candidate = LiturgicalDate.addDays(candidate, 1);
    }
    return candidate;
  }

  bool _isBlockedForTransfer(
    DateTime day,
    Map<DateTime, ResolvedCelebrations> placed,
    Set<DateTime> occupiedDates,
  ) {
    if (day.weekday == DateTime.sunday) return true;
    if (occupiedDates.contains(day)) return true;
    if (PrivilegedDayCalculator.isPrivileged(day, settings: settings)) {
      return true;
    }
    final primary = placed[day]?.primary;
    return primary != null && _occupiesDay(primary.rank);
  }

  // ---------------------------------------------------------------------
  // Day construction
  // ---------------------------------------------------------------------

  LiturgicalDay _buildDay(DateTime date, ResolvedCelebrations? resolved) {
    final season = LiturgicalSeasonCalculator.resolve(
      date,
      settings: settings,
    );
    final weekOfSeason = LiturgicalWeekCalculator.weekOf(
      date,
      settings: settings,
    );

    final primary = resolved?.primary;
    if (primary != null) {
      return LiturgicalDay(
        date: date,
        celebration: primary.key,
        displayName: primary.displayName,
        season: season,
        rank: primary.rank,
        color: primary.color,
        weekOfSeason: weekOfSeason,
      );
    }

    final isSunday = date.weekday == DateTime.sunday;
    final optionalMemorials = (resolved?.optionalMemorials ?? const [])
        .map(
          (def) => OptionalMemorial(
            key: def.key,
            color: def.color,
            displayName: def.displayName,
          ),
        )
        .toList();
    final anchors = LiturgicalAnchors.forYear(date.year, settings);
    final daysAfterAsh = LiturgicalDate.daysBetween(
      anchors.ashWednesday,
      date,
    );
    final celebrationKey = switch (daysAfterAsh) {
      1 => 'after_ash_wednesday_thursday',
      2 => 'after_ash_wednesday_friday',
      3 => 'after_ash_wednesday_saturday',
      _ => '${_seasonKey(season)}_${isSunday ? 'sunday' : 'feria'}',
    };

    return LiturgicalDay(
      date: date,
      celebration: CelebrationKey(celebrationKey),
      season: season,
      rank: LiturgicalRank.feria,
      color: _defaultColorFor(
        season,
        isSunday: isSunday,
        week: weekOfSeason,
        isHolySaturday: LiturgicalDate.daysBetween(date, anchors.easter) == 1,
      ),
      optionalMemorials: optionalMemorials,
      weekOfSeason: weekOfSeason,
    );
  }

  /// Default colour of a day with no celebration of its own.
  LiturgicalColor _defaultColorFor(
    LiturgicalSeason season, {
    required bool isSunday,
    required int? week,
    required bool isHolySaturday,
  }) {
    switch (season) {
      case LiturgicalSeason.advent:
        // Gaudete Sunday.
        return isSunday && week == 3
            ? LiturgicalColor.rose
            : LiturgicalColor.violet;
      case LiturgicalSeason.lent:
        // Laetare Sunday.
        return isSunday && week == 4
            ? LiturgicalColor.rose
            : LiturgicalColor.violet;
      case LiturgicalSeason.christmas:
      case LiturgicalSeason.easter:
        return LiturgicalColor.white;
      case LiturgicalSeason.sacredTriduum:
        // Holy Saturday has no Mass of its own; vestments are violet.
        return isHolySaturday ? LiturgicalColor.violet : LiturgicalColor.red;
      case LiturgicalSeason.ordinaryTime:
        return LiturgicalColor.green;
    }
  }

  DateTime _normalize(DateTime date) => LiturgicalDate.normalize(date);

  String _seasonKey(LiturgicalSeason season) => switch (season) {
    LiturgicalSeason.advent => 'advent',
    LiturgicalSeason.christmas => 'christmas',
    LiturgicalSeason.lent => 'lent',
    LiturgicalSeason.sacredTriduum => 'sacred_triduum',
    // Not plain 'easter': 'easter_sunday' is the key of Easter Sunday itself.
    LiturgicalSeason.easter => 'easter_time',
    LiturgicalSeason.ordinaryTime => 'ordinary_time',
  };
}

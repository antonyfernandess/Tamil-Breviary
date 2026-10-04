import 'package:catholic/modules/liturgical_engine/application/celebration_generator.dart';
import 'package:catholic/modules/liturgical_engine/application/liturgical_engine_impl.dart';
import 'package:catholic/modules/liturgical_engine/application/services/liturgical_precedence.dart';
import 'package:catholic/modules/liturgical_engine/domain/calculations/easter/easter_algorithm.dart';
import 'package:catholic/modules/liturgical_engine/domain/calculations/liturgical_anchors.dart';
import 'package:catholic/modules/liturgical_engine/domain/entities/liturgical_day.dart';
import 'package:catholic/modules/liturgical_engine/domain/enums/liturgical_color.dart';
import 'package:catholic/modules/liturgical_engine/domain/enums/liturgical_rank.dart';
import 'package:catholic/modules/liturgical_engine/domain/enums/liturgical_season.dart';
import 'package:catholic/modules/liturgical_engine/domain/rules/fixed_date_rule.dart';
import 'package:catholic/modules/liturgical_engine/domain/value_objects/calendar_context.dart';
import 'package:catholic/modules/liturgical_engine/domain/value_objects/calendar_settings.dart';
import 'package:catholic/modules/liturgical_engine/infrastructure/calendars/general_roman_calendar.dart';
import 'package:catholic/modules/liturgical_engine/infrastructure/calendars/sqlite_fixed_feast_calendar.dart';
import 'package:catholic/modules/liturgical_engine/infrastructure/database/feast_row.dart';
import 'package:flutter_test/flutter_test.dart';

FeastRow _row(
  int month,
  int day,
  String name,
  String type, {
  int? addedYear,
  int? removedYear,
}) => FeastRow(
  month: month,
  day: day,
  name: name,
  feastType: type,
  addedYear: addedYear,
  removedYear: removedYear,
);

/// A small stand-in for the feasts table covering every collision class.
final _rows = <FeastRow>[
  _row(1, 1, 'Mary the Mother of God', 'Solemnity'),
  _row(2, 2, 'Presentation of the Lord', 'Feast-Lord'),
  _row(2, 3, 'Optional A', 'OpMem'),
  _row(2, 3, 'Optional B', 'OpMem'),
  _row(3, 4, 'Lenten Memorial', 'Mem'),
  _row(3, 7, 'Perpetua and Felicity', 'Mem'),
  _row(3, 19, 'Saint Joseph', 'Solemnity'),
  _row(3, 25, 'Annunciation', 'Solemnity'),
  _row(6, 24, 'Nativity of Saint John the Baptist', 'Solemnity'),
  _row(6, 29, 'Saints Peter and Paul', 'Solemnity'),
  _row(7, 3, 'Saint Thomas the Apostle', 'Feast'),
  _row(8, 6, 'Transfiguration of the Lord', 'Feast-Lord'),
  _row(8, 15, 'Assumption of the Blessed Virgin Mary', 'Solemnity'),
  _row(9, 14, 'Exaltation of the Holy Cross', 'Feast-Lord'),
  _row(11, 1, 'All Saints', 'Solemnity'),
  _row(11, 9, 'Dedication of the Lateran Basilica', 'Feast-Lord'),
  _row(12, 8, 'Immaculate Conception', 'Solemnity'),
  _row(12, 21, 'Advent Memorial', 'Mem'),
  _row(12, 26, 'Saint Stephen', 'Feast'),
  _row(12, 27, 'Saint John the Apostle and Evangelist', 'Feast'),
  _row(12, 28, 'Holy Innocents', 'Feast'),
];

/// Names and types copied from the real fixed_feasts.db. They differ from
/// [_rows] in ways that matter: the slug of St John the Baptist sorts before
/// 'corpus_christi', and the database repeats the Nativity of the Lord.
final _realRows = <FeastRow>[
  _row(1, 1, 'Mary, the Mother of God', 'Solemnity'),
  _row(6, 24, 'Birth of Saint John the Baptist', 'Solemnity'),
  _row(6, 29, 'Saints Peter and Paul, Apostles', 'Solemnity'),
  _row(7, 3, 'Saint Thomas the Apostle', 'Feast'),
  _row(7, 3, 'IN Saint Thomas the Apostle', 'Solemnity-PrincipalPartron-Place'),
  _row(12, 3, 'Saint Francis Xavier, priest', 'Mem'),
  _row(12, 3, 'IN Saint Francis Xavier, priest', 'Solemnity-PrincipalPartron-Place'),
  _row(12, 25, 'Nativity of the Lord', 'Solemnity'),
];

const _solemnityKeys = [
  'mary_the_mother_of_god',
  'saint_joseph',
  'annunciation',
  'nativity_of_saint_john_the_baptist',
  'saints_peter_and_paul',
  'assumption_of_the_blessed_virgin_mary',
  'all_saints',
  'immaculate_conception',
  'christ_the_king',
  'nativity_of_the_lord',
  'easter_sunday',
  'pentecost',
  'ascension',
  'trinity_sunday',
  'corpus_christi',
  'sacred_heart_of_jesus',
  'epiphany',
];

LiturgicalEngineImpl _engine([
  CalendarSettings settings = CalendarSettings.india,
  List<FeastRow>? rows,
]) {
  return LiturgicalEngineImpl(
    generator: CelebrationGenerator(
      calendars: [
        GeneralRomanCalendar(),
        SqliteFixedFeastCalendar(rows: rows ?? _rows),
      ],
      precedence: const LiturgicalPrecedence(),
      settings: settings,
    ),
  );
}

DateTime _d(int y, int m, int d) => DateTime.utc(y, m, d);

void main() {
  final india = _engine();
  final roman = _engine(CalendarSettings.roman);

  group('Easter', () {
    test('matches published dates', () {
      const known = {
        2020: (4, 12), 2021: (4, 4), 2022: (4, 17), 2023: (4, 9),
        2024: (3, 31), 2025: (4, 20), 2026: (4, 5), 2027: (3, 28),
        2028: (4, 16), 2029: (4, 1), 2030: (4, 21), 2035: (3, 25),
      };
      known.forEach((year, md) {
        final result = EasterAlgorithm.calculate(year);
        expect((result.month, result.day), md, reason: '$year');
      });
    });

    test('rejects pre-Gregorian years', () {
      expect(() => EasterAlgorithm.calculate(1500), throwsRangeError);
      expect(() => india.getYear(1500), throwsRangeError);
    });
  });

  group('Baptism of the Lord', () {
    test('India (transferred Epiphany)', () {
      DateTime b(int y) =>
          LiturgicalAnchors.forYear(y, CalendarSettings.india).baptismOfTheLord;
      expect(b(2024), _d(2024, 1, 8)); // Epiphany Sun 7 Jan -> Monday
      expect(b(2025), _d(2025, 1, 12));
      expect(b(2026), _d(2026, 1, 11));
    });

    test('Roman (fixed 6 January)', () {
      DateTime b(int y) =>
          LiturgicalAnchors.forYear(y, CalendarSettings.roman).baptismOfTheLord;
      expect(b(2019), _d(2019, 1, 13)); // 6 Jan is a Sunday
      expect(b(2020), _d(2020, 1, 12));
      expect(b(2026), _d(2026, 1, 11));
    });
  });

  group('Seasons and weeks', () {
    test('1 January up to the Baptism is Christmas Time', () {
      final year = india.getYear(2026);
      for (var d = 1; d <= 11; d++) {
        expect(year.getDay(_d(2026, 1, d))!.season, LiturgicalSeason.christmas,
            reason: 'Jan $d');
      }
      expect(year.getDay(_d(2026, 1, 12))!.season, LiturgicalSeason.ordinaryTime);
      expect(year.getDay(_d(2026, 1, 12))!.weekOfSeason, 1);
      expect(year.getDay(_d(2026, 1, 18))!.weekOfSeason, 2);
    });

    test('Christmas Time is continuous across the new year', () {
      for (var y = 2000; y <= 2100; y++) {
        expect(india.getDay(_d(y, 12, 31)).season, LiturgicalSeason.christmas);
        expect(india.getDay(_d(y + 1, 1, 1)).season, LiturgicalSeason.christmas);
      }
    });

    test('Ordinary Time weeks after Pentecost', () {
      expect(india.getDay(_d(2026, 5, 25)).weekOfSeason, 8);
    });

    test('Ash Wednesday has no week; Lent week 1 starts on Sunday', () {
      expect(india.getDay(_d(2026, 2, 18)).weekOfSeason, isNull);
      expect(india.getDay(_d(2026, 2, 19)).weekOfSeason, isNull);
      expect(india.getDay(_d(2026, 2, 22)).weekOfSeason, 1);
    });

    test('Gaudete / Laetare Sundays are rose; Holy Saturday is violet', () {
      expect(india.getDay(_d(2026, 12, 13)).color, LiturgicalColor.rose);
      expect(india.getDay(_d(2026, 3, 15)).color, LiturgicalColor.rose);
      expect(india.getDay(_d(2026, 4, 4)).color, LiturgicalColor.violet);
    });
  });

  group('Precedence', () {
    String? primary(LiturgicalEngineImpl e, DateTime d) {
      final day = e.getDay(d);
      return day.rank == LiturgicalRank.feria ? null : day.celebration.value;
    }

    test('Christ the King keeps its Sunday', () {
      expect(primary(india, _d(2026, 11, 22)), 'christ_the_king');
    });

    test('solemnity on an Ordinary Time Sunday is not transferred', () {
      expect(primary(india, _d(2021, 8, 15)),
          'assumption_of_the_blessed_virgin_mary');
      expect(primary(india, _d(2021, 8, 16)), isNull);
    });

    test('Annunciation in Holy Week moves after the Easter octave', () {
      expect(primary(india, _d(2024, 3, 25)), isNull);
      expect(primary(india, _d(2024, 4, 8)), 'annunciation');
    });

    test('Immaculate Conception on an Advent Sunday moves to Monday', () {
      expect(primary(india, _d(2024, 12, 8)), isNull);
      expect(primary(india, _d(2024, 12, 9)), 'immaculate_conception');
    });

    test('St Joseph on a Lent Sunday moves to Monday', () {
      expect(primary(india, _d(2028, 3, 19)), isNull);
      expect(primary(india, _d(2028, 3, 20)), 'saint_joseph');
    });

    test('St Joseph in Holy Week moves to the preceding Saturday', () {
      final year = List.generate(111, (i) => 1990 + i).firstWhere((y) {
        final a = LiturgicalAnchors.forYear(y, CalendarSettings.india);
        final joseph = _d(y, 3, 19);
        return !joseph.isBefore(a.palmSunday) && joseph.isBefore(a.easter);
      });
      final a = LiturgicalAnchors.forYear(year, CalendarSettings.india);
      final saturday = a.palmSunday.subtract(const Duration(days: 1));
      expect(primary(india, saturday), 'saint_joseph');
      expect(primary(india, _d(year, 3, 19)), isNull);
    });

    test('an obligatory memorial in Lent no longer crashes the year', () {
      late LiturgicalDay day;
      expect(() => day = india.getDay(_d(2024, 3, 7)), returnsNormally);
      expect(day.rank, LiturgicalRank.feria);
      expect(day.optionalMemorials.map((m) => m.key.value),
          contains('perpetua_and_felicity'));
    });

    test('memorials are optional on 17-24 December', () {
      final day = india.getDay(_d(2026, 12, 21));
      expect(day.rank, LiturgicalRank.feria);
      expect(day.optionalMemorials.map((m) => m.key.value),
          contains('advent_memorial'));
    });

    test('several optional memorials on one date are all kept', () {
      final day = india.getDay(_d(2026, 2, 3));
      expect(day.optionalMemorials.map((m) => m.key.value),
          containsAll(['optional_a', 'optional_b']));
    });

    test('Holy Family displaces the Sunday and the saint of the day', () {
      expect(primary(india, _d(2021, 12, 26)), 'holy_family'); // over Stephen
      expect(primary(india, _d(2022, 12, 30)), 'holy_family'); // 25 Dec Sunday
    });

    test('Baptism of the Lord on a Sunday (Roman) keeps its day', () {
      expect(primary(roman, _d(2019, 1, 13)), 'baptism_of_the_lord');
    });
  });

  group('Invariants 2000-2100', () {
    for (final entry in {
      'india': india,
      'roman': roman,
    }.entries) {
      test('${entry.key}: every solemnity occurs exactly once, never lost', () {
        for (var y = 2000; y <= 2100; y++) {
          final days = entry.value.getYear(y).days;
          for (final key in _solemnityKeys) {
            final hits = days.where((d) => d.celebration.value == key);
            expect(hits.length, 1, reason: '$y $key');
          }
        }
      });

      test('${entry.key}: no obligatory memorial on a Lent weekday', () {
        for (var y = 2000; y <= 2100; y++) {
          for (final d in entry.value.getYear(y).days) {
            if (d.season == LiturgicalSeason.lent &&
                d.date.weekday != DateTime.sunday) {
              expect(d.rank, isNot(LiturgicalRank.memorial), reason: '${d.date}');
            }
          }
        }
      });

      test('${entry.key}: Sundays hold only Sunday-level celebrations', () {
        const allowed = {
          LiturgicalRank.privilegedDay,
          LiturgicalRank.solemnity,
          LiturgicalRank.feastOfTheLord,
          LiturgicalRank.feria,
        };
        for (var y = 2000; y <= 2100; y++) {
          for (final d in entry.value.getYear(y).days) {
            if (d.date.weekday == DateTime.sunday) {
              expect(allowed, contains(d.rank), reason: '${d.date}');
            }
          }
        }
      });
    }
  });

  group('Rules and data', () {
    test('FixedDateRule never rolls into the next month', () {
      const rule = FixedDateRule(month: 2, day: 29);
      CalendarContext ctx(int y) =>
          CalendarContext(year: y, settings: CalendarSettings.roman);
      expect(rule.resolve(ctx(2024)), _d(2024, 2, 29));
      expect(rule.resolve(ctx(2025)), _d(2025, 2, 28));
      expect(rule.resolve(ctx(2025)).isUtc, isTrue);
    });

    test('SQLite calendar keeps distinct celebrations, dedupes repeats', () {
      final calendar = SqliteFixedFeastCalendar(rows: [
        _row(7, 22, 'Saint Mary Magdalene', 'Mem', removedYear: 2016),
        _row(7, 22, 'Saint Mary Magdalene', 'Feast', addedYear: 2016),
        _row(7, 22, 'Another Optional', 'OpMem'),
      ]);
      final in2020 = calendar.celebrationsForYear(2020).toList();
      expect(in2020.length, 2);
      expect(
        in2020.firstWhere((c) => c.key.value == 'saint_mary_magdalene').rank,
        LiturgicalRank.feast,
      );
      final in2010 = calendar.celebrationsForYear(2010).toList();
      expect(
        in2010.firstWhere((c) => c.key.value == 'saint_mary_magdalene').rank,
        LiturgicalRank.memorial,
      );
    });

    test('the same celebration stored twice for a day resolves to one', () {
      final calendar = SqliteFixedFeastCalendar(rows: [
        _row(5, 5, 'Same Name', 'Mem', addedYear: 2000),
        _row(5, 5, 'Same Name', 'Feast', addedYear: 2010),
      ]);
      expect(
        calendar.celebrationsForYear(2020).single.rank,
        LiturgicalRank.feast,
      );
    });

    test('feast_type spelling variants do not downgrade a solemnity', () {
      final calendar = SqliteFixedFeastCalendar(rows: [
        _row(7, 3, 'Patron of the Place', 'Solemnity-PrincipalPartron-Place'),
        _row(7, 4, 'Patron Two', 'Solemnity-PrincipalPatron-Place'),
      ]);
      expect(
        calendar.celebrationsForYear(2026).map((c) => c.rank),
        everyElement(LiturgicalRank.solemnity),
      );
    });
  });

  group('Real database collisions', () {
    final realIndia = _engine(CalendarSettings.india, _realRows);
    final realRoman = _engine(CalendarSettings.roman, _realRows);

    String? primary(LiturgicalEngineImpl e, DateTime d) {
      final day = e.getDay(d);
      return day.rank == LiturgicalRank.feria ? null : day.celebration.value;
    }

    test('Sacred Heart keeps 24 June; St John the Baptist is anticipated', () {
      for (final e in [realIndia, realRoman]) {
        expect(primary(e, _d(2022, 6, 24)), 'sacred_heart_of_jesus');
        expect(primary(e, _d(2022, 6, 23)), 'birth_of_saint_john_the_baptist');
      }
    });

    test('Corpus Christi is never lost to St John the Baptist', () {
      expect(primary(realRoman, _d(2038, 6, 24)), 'corpus_christi');
      expect(primary(realRoman, _d(2038, 6, 23)), 'birth_of_saint_john_the_baptist');
      expect(primary(realIndia, _d(2057, 6, 24)), 'corpus_christi');
      expect(primary(realIndia, _d(2057, 6, 23)), 'birth_of_saint_john_the_baptist');
    });

    test('Sacred Heart wins over Saints Peter and Paul', () {
      expect(primary(realIndia, _d(2057, 6, 29)), 'sacred_heart_of_jesus');
      expect(primary(realIndia, _d(2057, 6, 28)), 'saints_peter_and_paul_apostles');
    });

    test('India patron solemnities beat the universal celebration', () {
      expect(primary(realIndia, _d(2026, 7, 3)), 'in_saint_thomas_the_apostle');
      expect(primary(realIndia, _d(2026, 12, 3)), 'in_saint_francis_xavier_priest');
    });

    test('St Gonsalo Garcia replaces Paul Miki on 6 February (India)', () {
      // 2026-02-06 is an ordinary Friday, before Ash Wednesday.
      final rows = [
        _row(2, 6, 'Saints Paul Miki and companions, martyrs', 'Mem'),
        _row(2, 6, 'IN Saint Gonsalo Garcia, martyr', 'Mem'),
      ];
      final e = _engine(CalendarSettings.india, rows);
      expect(primary(e, _d(2026, 2, 6)), 'in_saint_gonsalo_garcia_martyr');
    });

    test('a national-proper memorial beats a general one, whatever the slug', () {
      // 'another_general_memorial' sorts before 'in_...' alphabetically.
      final rows = [
        _row(2, 6, 'Another General Memorial', 'Mem'),
        _row(2, 6, 'IN Saint Gonsalo Garcia, martyr', 'Mem'),
      ];
      final e = _engine(CalendarSettings.india, rows);
      expect(primary(e, _d(2026, 2, 6)), 'in_saint_gonsalo_garcia_martyr');
    });

    test('the Nativity listed in both sources appears once', () {
      for (final e in [realIndia, realRoman]) {
        for (var y = 2000; y <= 2100; y++) {
          final hits = e.getYear(y).days.where(
            (d) => d.celebration.value == 'nativity_of_the_lord',
          );
          expect(hits.length, 1, reason: '$y');
        }
      }
    });

    test('every solemnity occurs exactly once, 2000-2100', () {
      const keys = [
        'mary_the_mother_of_god',
        'birth_of_saint_john_the_baptist',
        'saints_peter_and_paul_apostles',
        'corpus_christi',
        'sacred_heart_of_jesus',
        'christ_the_king',
        'nativity_of_the_lord',
      ];
      for (final e in [realIndia, realRoman]) {
        for (var y = 2000; y <= 2100; y++) {
          final days = e.getYear(y).days;
          for (final key in keys) {
            final hits = days.where((d) => d.celebration.value == key);
            expect(hits.length, 1, reason: '$y $key');
          }
        }
      }
    });

    test('the database name travels with the celebration', () {
      expect(realIndia.getDay(_d(2026, 12, 3)).displayName,
          'Saint Francis Xavier, priest');
      expect(realIndia.getDay(_d(2026, 6, 29)).displayName,
          'Saints Peter and Paul, Apostles');
    });
  });
}

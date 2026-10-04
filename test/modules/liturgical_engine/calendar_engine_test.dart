import 'package:catholic/modules/liturgical_engine/application/celebration_generator.dart';
import 'package:catholic/modules/liturgical_engine/application/liturgical_engine_impl.dart';
import 'package:catholic/modules/liturgical_engine/application/services/liturgical_precedence.dart';
import 'package:catholic/modules/liturgical_engine/domain/calculations/easter/easter_calculator.dart';
import 'package:catholic/modules/liturgical_engine/domain/calculations/liturgical_anchors.dart';
import 'package:catholic/modules/liturgical_engine/domain/calculations/liturgical_date.dart';
import 'package:catholic/modules/liturgical_engine/domain/calculations/season/liturgical_week_calculator.dart';
import 'package:catholic/modules/liturgical_engine/domain/calculations/season/privileged_day_calculator.dart';
import 'package:catholic/modules/liturgical_engine/domain/calculations/season/liturgical_season_calculator.dart';
import 'package:catholic/modules/liturgical_engine/domain/enums/liturgical_rank.dart';
import 'package:catholic/modules/liturgical_engine/domain/enums/liturgical_season.dart';
import 'package:catholic/modules/liturgical_engine/infrastructure/calendars/general_roman_calendar.dart';
import 'package:catholic/modules/liturgical_engine/infrastructure/calendars/sqlite_fixed_feast_calendar.dart';
import 'package:catholic/modules/liturgical_engine/infrastructure/database/feast_row.dart';
import 'package:catholic/modules/liturgical_engine/domain/value_objects/calendar_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Easter calculator', () {
    test('computes Easter Sunday for a known year', () {
      final easter = EasterCalculator.forYear(2025);
      expect(easter.year, 2025);
      expect(easter.month, 4);
      expect(easter.day, 20);
    });

    test('computes Easter Sunday for a leap-year variant', () {
      final easter = EasterCalculator.forYear(2024);
      expect(easter.year, 2024);
      expect(easter.month, 3);
      expect(easter.day, 31);
    });
  });

  group('Season resolution', () {
    test('resolves Lent and Easter correctly around the Paschal period', () {
      expect(
        LiturgicalSeasonCalculator.resolve(DateTime(2025, 3, 5)),
        LiturgicalSeason.lent,
      );
      expect(
        LiturgicalSeasonCalculator.resolve(DateTime(2025, 4, 20)),
        LiturgicalSeason.easter,
      );
      expect(
        LiturgicalSeasonCalculator.resolve(DateTime(2025, 6, 9)),
        LiturgicalSeason.ordinaryTime,
      );
    });

    group('Liturgical anchors', () {
      test('Advent remains correct when Christmas is Sunday', () {
        for (final year in [2033, 2039]) {
          final firstAdvent = LiturgicalAnchors.forYear(year).firstAdventSunday;
          expect(firstAdvent, DateTime.utc(year, 11, 27));
        }
      });

      test('Baptism follows the transferred Epiphany in India', () {
        // Epiphany is the Sunday between 2-8 Jan. The Baptism is the Sunday
        // after it, or the Monday after it when Epiphany is 7 or 8 Jan.
        final expectedDates = {
          2023: DateTime.utc(2023, 1, 9), // Epiphany Sun 8 Jan -> Monday
          2024: DateTime.utc(2024, 1, 8), // Epiphany Sun 7 Jan -> Monday
          2025: DateTime.utc(2025, 1, 12), // Epiphany Sun 5 Jan -> next Sunday
          2030: DateTime.utc(2030, 1, 13), // Epiphany Sun 6 Jan -> next Sunday
        };

        for (final entry in expectedDates.entries) {
          expect(
            LiturgicalAnchors.forYear(
              entry.key,
              CalendarSettings.india,
            ).baptismOfTheLord,
            entry.value,
          );
        }
      });

      test(
        'ordinary-time week two starts on the first Sunday after Baptism',
        () {
          expect(
            LiturgicalWeekCalculator.weekOf(
              DateTime(2024, 1, 13),
              settings: CalendarSettings.india,
            ),
            1,
          );
          expect(
            LiturgicalWeekCalculator.weekOf(
              DateTime(2024, 1, 14),
              settings: CalendarSettings.india,
            ),
            2,
          );
        },
      );

      test('Ascension privilege follows the regional setting', () {
        expect(
          PrivilegedDayCalculator.isPrivileged(
            DateTime(2024, 5, 9),
            settings: CalendarSettings.roman,
          ),
          isTrue,
        );
        expect(
          PrivilegedDayCalculator.isPrivileged(
            DateTime(2024, 5, 9),
            settings: CalendarSettings.india,
          ),
          isFalse,
        );
      });

      test('anchors use UTC date-only values', () {
        final ashWednesday = LiturgicalAnchors.forYear(2026).ashWednesday;
        expect(ashWednesday.isUtc, isTrue);
        expect(ashWednesday, DateTime.utc(2026, 2, 18));
        expect(
          identical(
            LiturgicalAnchors.forYear(2026),
            LiturgicalAnchors.forYear(2026),
          ),
          isTrue,
        );
        expect(
          LiturgicalDate.normalize(DateTime(2026, 2, 18, 23, 59)),
          DateTime.utc(2026, 2, 18),
        );
      });
    });
  });

  group('Engine generation', () {
    test('generates a full liturgical year for 2025', () {
      final generator = CelebrationGenerator(
        calendars: [GeneralRomanCalendar()],
        precedence: const LiturgicalPrecedence(),
      );

      final engine = LiturgicalEngineImpl(generator: generator);
      final year = engine.getYear(2025);

      expect(year.days.length, 365);
      expect(
        year.getDay(DateTime(2025, 4, 20))?.celebration.value,
        'easter_sunday',
      );
      expect(
        year.getDay(DateTime(2025, 12, 25))?.celebration.value,
        'nativity_of_the_lord',
      );
      expect(
        year.getDay(DateTime(2025, 12, 25))?.rank,
        LiturgicalRank.solemnity,
      );
    });

    test('Palm Sunday retains its named celebration key', () {
      final generator = CelebrationGenerator(
        calendars: [GeneralRomanCalendar()],
        precedence: const LiturgicalPrecedence(),
      );

      final day = LiturgicalEngineImpl(
        generator: generator,
      ).getDay(DateTime(2025, 4, 13));

      expect(day.celebration.value, 'palm_sunday');
      expect(day.rank, LiturgicalRank.solemnity);
    });

    test('keeps the first celebration of the day as the primary one', () {
      final feastRows = <FeastRow>[
        const FeastRow(
          name: 'Saint John',
          feastType: 'Feast',
          month: 6,
          day: 24,
          addedYear: 0,
          removedYear: null,
        ),
      ];

      final generator = CelebrationGenerator(
        calendars: [
          GeneralRomanCalendar(),
          SqliteFixedFeastCalendar(rows: feastRows),
        ],
        precedence: const LiturgicalPrecedence(),
      );

      final engine = LiturgicalEngineImpl(generator: generator);
      final day = engine.getDay(DateTime(2025, 6, 24));

      expect(day, isNotNull);
      expect(day.rank.index <= LiturgicalRank.feast.index, isTrue);
    });

    test('Ash Wednesday wins over a memorial on the same date', () {
      final generator = CelebrationGenerator(
        calendars: [
          GeneralRomanCalendar(),
          SqliteFixedFeastCalendar(
            rows: [
              const FeastRow(
                name: 'Saint Cyril and Methodius',
                feastType: 'Mem',
                month: 2,
                day: 14,
                addedYear: 0,
                removedYear: null,
              ),
            ],
          ),
        ],
        precedence: const LiturgicalPrecedence(),
      );

      final day = LiturgicalEngineImpl(
        generator: generator,
      ).getDay(DateTime(2024, 2, 14));

      expect(day.celebration.value, 'ash_wednesday');
      expect(day.rank, LiturgicalRank.privilegedDay);
    });

    test(
      'Lenten weekday memorial becomes optional without empty selection',
      () {
        final generator = CelebrationGenerator(
          calendars: [
            GeneralRomanCalendar(),
            SqliteFixedFeastCalendar(
              rows: [
                const FeastRow(
                  name: 'Saint Perpetua',
                  feastType: 'Mem',
                  month: 3,
                  day: 6,
                  addedYear: 0,
                  removedYear: null,
                ),
              ],
            ),
          ],
          precedence: const LiturgicalPrecedence(),
        );

        final day = LiturgicalEngineImpl(
          generator: generator,
        ).getDay(DateTime(2025, 3, 6));

        expect(day.celebration.value, 'after_ash_wednesday_thursday');
        expect(
          day.optionalMemorials.map((memorial) => memorial.key.value),
          contains('saint_perpetua'),
        );
      },
    );

    test('Ordinary Time Sunday takes precedence over a saint memorial', () {
      final generator = CelebrationGenerator(
        calendars: [
          GeneralRomanCalendar(),
          SqliteFixedFeastCalendar(
            rows: [
              const FeastRow(
                name: 'Saint Justin',
                feastType: 'Mem',
                month: 7,
                day: 6,
                addedYear: 0,
                removedYear: null,
              ),
            ],
          ),
        ],
        precedence: const LiturgicalPrecedence(),
      );

      final day = LiturgicalEngineImpl(
        generator: generator,
      ).getDay(DateTime(2025, 7, 6));

      expect(day.celebration.value, 'ordinary_time_sunday');
    });

    test('Ordinary Time Sunday takes precedence over a generic feast', () {
      final generator = CelebrationGenerator(
        calendars: [
          GeneralRomanCalendar(),
          SqliteFixedFeastCalendar(
            rows: [
              const FeastRow(
                name: 'Saint Maria',
                feastType: 'Feast',
                month: 7,
                day: 6,
                addedYear: 0,
                removedYear: null,
              ),
            ],
          ),
        ],
        precedence: const LiturgicalPrecedence(),
      );

      final day = LiturgicalEngineImpl(
        generator: generator,
      ).getDay(DateTime(2025, 7, 6));

      expect(day.celebration.value, 'ordinary_time_sunday');
    });

    test('A solemnity may replace an Ordinary Time Sunday', () {
      final generator = CelebrationGenerator(
        calendars: [
          GeneralRomanCalendar(),
          SqliteFixedFeastCalendar(
            rows: [
              const FeastRow(
                name: 'Saints Peter and Paul',
                feastType: 'Solemnity',
                month: 6,
                day: 29,
                addedYear: 0,
                removedYear: null,
              ),
            ],
          ),
        ],
        precedence: const LiturgicalPrecedence(),
      );

      final day = LiturgicalEngineImpl(
        generator: generator,
      ).getDay(DateTime(2025, 6, 29));

      expect(day.celebration.value, 'saints_peter_and_paul');
      expect(day.rank, LiturgicalRank.solemnity);
    });

    test('Feast of the Lord may replace an Ordinary Time Sunday', () {
      final generator = CelebrationGenerator(
        calendars: [
          GeneralRomanCalendar(),
          SqliteFixedFeastCalendar(
            rows: [
              const FeastRow(
                name: 'Presentation of the Lord',
                feastType: 'Feast-Lord',
                month: 2,
                day: 2,
                addedYear: 0,
                removedYear: null,
              ),
            ],
          ),
        ],
        precedence: const LiturgicalPrecedence(),
      );

      final day = LiturgicalEngineImpl(
        generator: generator,
      ).getDay(DateTime(2025, 2, 2));

      expect(day.celebration.value, 'presentation_of_the_lord');
      expect(day.rank, LiturgicalRank.feastOfTheLord);
    });

    test('Annunciation on Good Friday transfers after the Easter octave', () {
      final generator = CelebrationGenerator(
        calendars: [
          GeneralRomanCalendar(),
          SqliteFixedFeastCalendar(
            rows: [
              const FeastRow(
                name: 'Annunciation',
                feastType: 'Solemnity',
                month: 3,
                day: 25,
                addedYear: 0,
                removedYear: null,
              ),
            ],
          ),
        ],
        precedence: const LiturgicalPrecedence(),
      );
      final year = LiturgicalEngineImpl(generator: generator).getYear(2016);

      expect(
        year.getDay(DateTime(2016, 3, 25))?.celebration.value,
        'good_friday',
      );
      expect(
        year.getDay(DateTime(2016, 4, 4))?.celebration.value,
        'annunciation',
      );
    });

    test('movable celebrations are present in the General Roman calendar', () {
      final generator = CelebrationGenerator(
        calendars: [GeneralRomanCalendar()],
        precedence: const LiturgicalPrecedence(),
      );
      final engine = LiturgicalEngineImpl(generator: generator);

      expect(
        engine.getDay(DateTime(2022, 12, 30)).celebration.value,
        'holy_family',
      );
      expect(
        engine.getDay(DateTime(2025, 6, 27)).celebration.value,
        'sacred_heart_of_jesus',
      );
      expect(
        engine.getDay(DateTime(2025, 6, 28)).celebration.value,
        'immaculate_heart_of_mary',
      );
      expect(
        engine.getDay(DateTime(2025, 6, 9)).celebration.value,
        'mary_mother_of_the_church',
      );
    });
  });
}

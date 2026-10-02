import 'package:catholic/modules/liturgical_engine/application/celebration_generator.dart';
import 'package:catholic/modules/liturgical_engine/application/liturgical_engine_impl.dart';
import 'package:catholic/modules/liturgical_engine/application/services/liturgical_precedence.dart';
import 'package:catholic/modules/liturgical_engine/domain/calculations/easter/easter_calculator.dart';
import 'package:catholic/modules/liturgical_engine/domain/calculations/season/liturgical_season_calculator.dart';
import 'package:catholic/modules/liturgical_engine/domain/enums/liturgical_rank.dart';
import 'package:catholic/modules/liturgical_engine/domain/enums/liturgical_season.dart';
import 'package:catholic/modules/liturgical_engine/infrastructure/calendars/general_roman_calendar.dart';
import 'package:catholic/modules/liturgical_engine/infrastructure/calendars/sqlite_fixed_feast_calendar.dart';
import 'package:catholic/modules/liturgical_engine/infrastructure/database/feast_row.dart';
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
      expect(year.getDay(DateTime(2025, 4, 20))?.celebration.value, 'easter_sunday');
      expect(year.getDay(DateTime(2025, 12, 25))?.celebration.value, 'nativity_of_the_lord');
      expect(year.getDay(DateTime(2025, 12, 25))?.rank, LiturgicalRank.solemnity);
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
  });
}

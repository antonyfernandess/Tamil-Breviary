import 'package:catholic/l10n/generated/app_localizations_en.dart';
import 'package:catholic/l10n/generated/app_localizations_ta.dart';
import 'package:catholic/modules/liturgical_engine/application/celebration_generator.dart';
import 'package:catholic/modules/liturgical_engine/application/liturgical_engine_impl.dart';
import 'package:catholic/modules/liturgical_engine/application/services/liturgical_precedence.dart';
import 'package:catholic/modules/liturgical_engine/domain/enums/liturgical_color.dart';
import 'package:catholic/modules/liturgical_engine/domain/enums/liturgical_rank.dart';
import 'package:catholic/modules/liturgical_engine/domain/enums/liturgical_season.dart';
import 'package:catholic/modules/liturgical_engine/domain/value_objects/calendar_settings.dart';
import 'package:catholic/modules/liturgical_engine/infrastructure/calendars/general_roman_calendar.dart';
import 'package:flutter_test/flutter_test.dart';

LiturgicalEngineImpl _engine(CalendarSettings settings) {
  return LiturgicalEngineImpl(
    generator: CelebrationGenerator(
      calendars: [GeneralRomanCalendar()],
      precedence: const LiturgicalPrecedence(),
      settings: settings,
    ),
  );
}

void main() {
  final india = _engine(CalendarSettings.india);
  final roman = _engine(CalendarSettings.roman);
  DateTime d(int y, int m, int day) => DateTime.utc(y, m, day);

  group('Holy Week weekdays', () {
    test('Monday to Wednesday of Holy Week 2026', () {
      // Palm Sunday 29 Mar, Easter 5 Apr.
      for (final day in [d(2026, 3, 30), d(2026, 3, 31), d(2026, 4, 1)]) {
        final result = india.getDay(day);
        expect(result.celebration.value, 'holy_week_feria', reason: '$day');
        expect(result.season, LiturgicalSeason.lent);
        expect(result.rank, LiturgicalRank.feria);
        expect(result.color, LiturgicalColor.violet);
        expect(result.weekOfSeason, isNull, reason: 'no "week 6 of Lent"');
      }
    });

    test('the days around Holy Week are unaffected', () {
      expect(india.getDay(d(2026, 3, 28)).celebration.value, 'lent_feria');
      expect(india.getDay(d(2026, 3, 28)).weekOfSeason, 5);
      expect(india.getDay(d(2026, 3, 29)).celebration.value, 'palm_sunday');
      expect(india.getDay(d(2026, 4, 2)).celebration.value, 'holy_thursday');
      expect(india.getDay(d(2026, 4, 3)).celebration.value, 'good_friday');
    });

    test('exactly Monday, Tuesday and Wednesday, every year 2000-2100', () {
      for (final engine in [india, roman]) {
        for (var y = 2000; y <= 2100; y++) {
          final days = engine
              .getYear(y)
              .days
              .where((day) => day.celebration.value == 'holy_week_feria')
              .toList();
          expect(days.map((day) => day.date.weekday).toList(), [
            DateTime.monday,
            DateTime.tuesday,
            DateTime.wednesday,
          ], reason: '$y');
        }
      }
    });
  });

  group('Holy Week wording', () {
    test('English', () {
      expect(AppLocalizationsEn().weekdayOfHolyWeek('Monday'),
          'Monday of Holy Week');
    });

    test('Tamil', () {
      expect(AppLocalizationsTa().weekdayOfHolyWeek('திங்கட்கிழமை'),
          'புனித வாரம் - திங்கட்கிழமை');
    });
  });
}

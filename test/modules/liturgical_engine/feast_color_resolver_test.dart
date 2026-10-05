import 'package:catholic/modules/liturgical_engine/application/celebration_generator.dart';
import 'package:catholic/modules/liturgical_engine/application/liturgical_engine_impl.dart';
import 'package:catholic/modules/liturgical_engine/application/services/liturgical_precedence.dart';
import 'package:catholic/modules/liturgical_engine/domain/enums/liturgical_color.dart';
import 'package:catholic/modules/liturgical_engine/domain/value_objects/calendar_settings.dart';
import 'package:catholic/modules/liturgical_engine/infrastructure/calendars/feast_color_resolver.dart';
import 'package:catholic/modules/liturgical_engine/infrastructure/calendars/general_roman_calendar.dart';
import 'package:catholic/modules/liturgical_engine/infrastructure/calendars/sqlite_fixed_feast_calendar.dart';
import 'package:catholic/modules/liturgical_engine/infrastructure/database/feast_row.dart';
import 'package:flutter_test/flutter_test.dart';

FeastRow _row(int month, int day, String name, String type) =>
    FeastRow(month: month, day: day, name: name, feastType: type);

LiturgicalEngineImpl _engine(List<FeastRow> rows) {
  return LiturgicalEngineImpl(
    generator: CelebrationGenerator(
      calendars: [GeneralRomanCalendar(), SqliteFixedFeastCalendar(rows: rows)],
      precedence: const LiturgicalPrecedence(),
      settings: CalendarSettings.india,
    ),
  );
}

void main() {
  group('FeastColorResolver (names from fixed_feasts.db)', () {
    const red = LiturgicalColor.red;
    const white = LiturgicalColor.white;
    const violet = LiturgicalColor.violet;

    final expected = <String, LiturgicalColor>{
      // Martyrs
      'Saint Agnes, virgin and martyr': red,
      'Saints Perpetua and Felicity, martyrs': red,
      'Saint Justin Martyr': red,
      'Saint Stephen, the first martyr': red,
      'Holy Innocents, martyrs': red,
      'The Beheading of Saint John the Baptist, martyr': red,
      'First Martyrs of the Church of Rome': red,
      'IN Saint Gonsalo Garcia, martyr': red,
      'IN Blessed Rani Maria, virgin, martyr': red,
      // Apostles and evangelists
      'Saints Peter and Paul, Apostles': red,
      'Saint Thomas the Apostle': red,
      'IN Saint Thomas the Apostle': red,
      'Saint Matthias the Apostle': red,
      'Saint Barnabas the Apostle': red,
      'Saint James, apostle': red,
      'Saints Philip and James, Apostles': red,
      'Saint Bartholomew the Apostle': red,
      'Saint Simon and Saint Jude, apostles': red,
      'Saint Andrew the Apostle': red,
      'Saint Mark the Evangelist': red,
      'Saint Luke the Evangelist': red,
      'Saint Matthew the Evangelist, Apostle, Evangelist': red,
      // The Cross
      'Exaltation of the Holy Cross': red,
      // Apostles that are white by exception
      'The Conversion of Saint Paul, apostle': white,
      'Chair of Saint Peter, apostle': white,
      'Saint John the Apostle and evangelist': white,
      'Dedication of the basilicas of Saints Peter and Paul, Apostles': white,
      'Dedication of the Basilica of Saint Mary Major': white,
      'Dedication of the Lateran basilica': white,
      // Names that look similar but are white
      'Birth of Saint John the Baptist': white,
      'Saint John of the Cross, priest and doctor': white,
      'Saint Paul of the Cross, priest': white,
      'Saint John Baptist de la Salle, priest': white,
      'Saint Mary Magdalene': white,
      'Saint Joseph Husband of the Blessed Virgin Mary': white,
      'Saint Francis Xavier, priest': white,
      'Saints Michael, Gabriel and Raphael, archangels': white,
      // Violet
      'All Souls': violet,
    };

    expected.forEach((name, color) {
      test('$name -> ${color.name}', () {
        expect(FeastColorResolver.resolve(name), color);
      });
    });
  });

  group('Colours on real days', () {
    final engine = _engine([
      _row(6, 29, 'Saints Peter and Paul, Apostles', 'Solemnity'),
      _row(7, 3, 'IN Saint Thomas the Apostle', 'Solemnity-PrincipalPartron-Place'),
      _row(9, 14, 'Exaltation of the Holy Cross', 'Feast-Lord'),
      _row(11, 2, 'All Souls', 'Solemnity'),
      _row(12, 26, 'Saint Stephen, the first martyr', 'Feast'),
      _row(12, 28, 'Holy Innocents, martyrs', 'Feast'),
      _row(1, 25, 'The Conversion of Saint Paul, apostle', 'Feast'),
      _row(4, 23, 'Saint George, martyr', 'OpMem'),
    ]);

    LiturgicalColor colorOf(int y, int m, int d) =>
        engine.getDay(DateTime.utc(y, m, d)).color;

    test('apostles and martyrs are red', () {
      expect(colorOf(2026, 6, 29), LiturgicalColor.red);
      expect(colorOf(2026, 7, 3), LiturgicalColor.red);
      expect(colorOf(2026, 12, 26), LiturgicalColor.red);
      expect(colorOf(2026, 12, 28), LiturgicalColor.red);
    });

    test('Exaltation of the Holy Cross is red, All Souls violet', () {
      expect(colorOf(2026, 9, 14), LiturgicalColor.red);
      expect(colorOf(2026, 11, 2), LiturgicalColor.violet);
    });

    test('Conversion of St Paul stays white', () {
      // 25 January 2027 is an ordinary Monday.
      expect(colorOf(2027, 1, 25), LiturgicalColor.white);
    });

    test('an optional memorial of a martyr carries red', () {
      // 23 April 2026 is a Thursday of Eastertide; the day itself is white.
      final day = engine.getDay(DateTime.utc(2026, 4, 23));
      expect(day.color, LiturgicalColor.white);
      expect(day.optionalMemorials.single.color, LiturgicalColor.red);
    });
  });
}

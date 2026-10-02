import 'package:catholic/app/app_language_controller.dart';
import 'package:catholic/l10n/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('App language', () {
    late Directory temporaryDirectory;
    late File preferenceFile;

    setUp(() async {
      temporaryDirectory = await Directory.systemTemp.createTemp(
        'catholic-language-test-',
      );
      preferenceFile = File('${temporaryDirectory.path}/app_language.txt');
    });

    tearDown(() async {
      await temporaryDirectory.delete(recursive: true);
    });

    test('loads the saved language preference', () async {
      await preferenceFile.writeAsString('ta');

      final language = await AppLanguageController.load(
        preferenceFile: preferenceFile,
      );

      expect(language.locale, const Locale('ta'));
    });

    test('saves and publishes a changed language preference', () async {
      final language = await AppLanguageController.load(
        preferenceFile: preferenceFile,
      );
      var notified = false;
      language.addListener(() => notified = true);

      await language.setLocale(const Locale('ta'));

      expect(language.locale, const Locale('ta'));
      expect(notified, isTrue);
      expect(await preferenceFile.readAsString(), 'ta');
      language.dispose();
    });

    test('includes Tamil translations for calendar and navigation', () async {
      final tamil = await AppLocalizations.delegate.load(const Locale('ta'));

      expect(tamil.today, 'இன்று');
      expect(tamil.calendar, 'நாள்காட்டி');
      expect(tamil.liturgicalCalendar, 'திருவழிபாட்டு நாள்காட்டி');
      expect(tamil.ashWednesday, 'திருநீற்றுப் புதன்');
      expect(
        tamil.weekdayAfterAshWednesday('வியாழக்கிழமை'),
        'திருநீற்றுப் புதனுக்குப் பின் வியாழக்கிழமை',
      );
      expect(
        tamil.weekOfSeason('வியாழக்கிழமை', '1', 'பொதுக்காலம்'),
        'பொதுக்காலம் - 1ஆம் வாரம், வியாழக்கிழமை',
      );
      expect(tamil.sundayOfOrdinaryTime('1'), 'பொதுக்காலத்தின் 1ஆம் ஞாயிறு');
    });
  });
}

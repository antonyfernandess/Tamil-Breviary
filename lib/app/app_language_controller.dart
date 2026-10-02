import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class AppLanguageController extends ChangeNotifier {
  AppLanguageController._(this._preferenceFile, this._locale);

  final File _preferenceFile;
  Locale _locale;

  Locale get locale => _locale;

  static Future<AppLanguageController> load({File? preferenceFile}) async {
    final file =
        preferenceFile ??
        File(
          path.join(
            (await getApplicationSupportDirectory()).path,
            'app_language.txt',
          ),
        );

    final savedLanguage = await file.exists()
        ? (await file.readAsString()).trim()
        : null;
    final languageCode = switch (savedLanguage) {
      'ta' => 'ta',
      'en' => 'en',
      _ =>
        WidgetsBinding.instance.platformDispatcher.locale.languageCode == 'ta'
            ? 'ta'
            : 'en',
    };

    return AppLanguageController._(file, Locale(languageCode));
  }

  Future<void> setLocale(Locale locale) async {
    if (locale.languageCode != 'en' && locale.languageCode != 'ta') {
      throw ArgumentError.value(locale, 'locale', 'Unsupported app language');
    }

    if (locale.languageCode == _locale.languageCode) return;

    await _preferenceFile.parent.create(recursive: true);
    await _preferenceFile.writeAsString(locale.languageCode, flush: true);

    _locale = Locale(locale.languageCode);
    notifyListeners();
  }
}

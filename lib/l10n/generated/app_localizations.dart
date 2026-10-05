import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ta.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ta'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Catholic'**
  String get appTitle;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @readings.
  ///
  /// In en, this message translates to:
  /// **'Readings'**
  String get readings;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @liturgicalCalendar.
  ///
  /// In en, this message translates to:
  /// **'LITURGICAL CALENDAR'**
  String get liturgicalCalendar;

  /// No description provided for @previousYear.
  ///
  /// In en, this message translates to:
  /// **'Previous year'**
  String get previousYear;

  /// No description provided for @nextYear.
  ///
  /// In en, this message translates to:
  /// **'Next year'**
  String get nextYear;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the language used throughout the app.'**
  String get languageDescription;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @tamil.
  ///
  /// In en, this message translates to:
  /// **'Tamil'**
  String get tamil;

  /// No description provided for @languageSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save your language preference.'**
  String get languageSaveError;

  /// No description provided for @ashWednesday.
  ///
  /// In en, this message translates to:
  /// **'Ash Wednesday'**
  String get ashWednesday;

  /// No description provided for @weekdayAfterAshWednesday.
  ///
  /// In en, this message translates to:
  /// **'{weekday} after Ash Wednesday'**
  String weekdayAfterAshWednesday(Object weekday);

  /// No description provided for @weekOfSeason.
  ///
  /// In en, this message translates to:
  /// **'{weekday} of week {week} in {season}'**
  String weekOfSeason(Object weekday, Object week, Object season);

  /// No description provided for @weekdayInSeason.
  ///
  /// In en, this message translates to:
  /// **'{weekday} in {season}'**
  String weekdayInSeason(Object weekday, Object season);

  /// No description provided for @weekdayOfHolyWeek.
  ///
  /// In en, this message translates to:
  /// **'{weekday} of Holy Week'**
  String weekdayOfHolyWeek(Object weekday);

  /// No description provided for @advent.
  ///
  /// In en, this message translates to:
  /// **'Advent'**
  String get advent;

  /// No description provided for @christmasTime.
  ///
  /// In en, this message translates to:
  /// **'Christmas Time'**
  String get christmasTime;

  /// No description provided for @lent.
  ///
  /// In en, this message translates to:
  /// **'Lent'**
  String get lent;

  /// No description provided for @sacredTriduum.
  ///
  /// In en, this message translates to:
  /// **'the Sacred Triduum'**
  String get sacredTriduum;

  /// No description provided for @easterTime.
  ///
  /// In en, this message translates to:
  /// **'Easter Time'**
  String get easterTime;

  /// No description provided for @ordinaryTime.
  ///
  /// In en, this message translates to:
  /// **'Ordinary Time'**
  String get ordinaryTime;

  /// No description provided for @sundayOfAdvent.
  ///
  /// In en, this message translates to:
  /// **'{week} Sunday of Advent'**
  String sundayOfAdvent(Object week);

  /// No description provided for @sundayOfChristmas.
  ///
  /// In en, this message translates to:
  /// **'{week} Sunday of Christmas'**
  String sundayOfChristmas(Object week);

  /// No description provided for @sundayOfLent.
  ///
  /// In en, this message translates to:
  /// **'{week} Sunday of Lent'**
  String sundayOfLent(Object week);

  /// No description provided for @sundayOfTriduum.
  ///
  /// In en, this message translates to:
  /// **'{week} Sunday of the Sacred Triduum'**
  String sundayOfTriduum(Object week);

  /// No description provided for @sundayOfEaster.
  ///
  /// In en, this message translates to:
  /// **'{week} Sunday of Easter'**
  String sundayOfEaster(Object week);

  /// No description provided for @sundayOfOrdinaryTime.
  ///
  /// In en, this message translates to:
  /// **'{week} Sunday in Ordinary Time'**
  String sundayOfOrdinaryTime(Object week);

  /// No description provided for @solemnity.
  ///
  /// In en, this message translates to:
  /// **'Solemnity'**
  String get solemnity;

  /// No description provided for @feast.
  ///
  /// In en, this message translates to:
  /// **'Feast'**
  String get feast;

  /// No description provided for @memorial.
  ///
  /// In en, this message translates to:
  /// **'Memorial'**
  String get memorial;

  /// No description provided for @optionalMemorial.
  ///
  /// In en, this message translates to:
  /// **'Optional Memorial'**
  String get optionalMemorial;

  /// No description provided for @commemoration.
  ///
  /// In en, this message translates to:
  /// **'Commemoration'**
  String get commemoration;

  /// No description provided for @weekdayRank.
  ///
  /// In en, this message translates to:
  /// **'Weekday'**
  String get weekdayRank;

  /// No description provided for @orMemorial.
  ///
  /// In en, this message translates to:
  /// **'or {celebration}'**
  String orMemorial(Object celebration);

  /// No description provided for @nativityOfTheLord.
  ///
  /// In en, this message translates to:
  /// **'The Nativity of the Lord'**
  String get nativityOfTheLord;

  /// No description provided for @palmSunday.
  ///
  /// In en, this message translates to:
  /// **'Palm Sunday of the Passion of the Lord'**
  String get palmSunday;

  /// No description provided for @holyThursday.
  ///
  /// In en, this message translates to:
  /// **'Holy Thursday'**
  String get holyThursday;

  /// No description provided for @goodFriday.
  ///
  /// In en, this message translates to:
  /// **'Friday of the Passion of the Lord'**
  String get goodFriday;

  /// No description provided for @easterSunday.
  ///
  /// In en, this message translates to:
  /// **'Easter Sunday'**
  String get easterSunday;

  /// No description provided for @ascension.
  ///
  /// In en, this message translates to:
  /// **'The Ascension of the Lord'**
  String get ascension;

  /// No description provided for @pentecost.
  ///
  /// In en, this message translates to:
  /// **'Pentecost Sunday'**
  String get pentecost;

  /// No description provided for @trinitySunday.
  ///
  /// In en, this message translates to:
  /// **'The Most Holy Trinity'**
  String get trinitySunday;

  /// No description provided for @corpusChristi.
  ///
  /// In en, this message translates to:
  /// **'The Most Holy Body and Blood of Christ'**
  String get corpusChristi;

  /// No description provided for @epiphany.
  ///
  /// In en, this message translates to:
  /// **'The Epiphany of the Lord'**
  String get epiphany;

  /// No description provided for @baptismOfTheLord.
  ///
  /// In en, this message translates to:
  /// **'The Baptism of the Lord'**
  String get baptismOfTheLord;

  /// No description provided for @christTheKing.
  ///
  /// In en, this message translates to:
  /// **'Our Lord Jesus Christ, King of the Universe'**
  String get christTheKing;

  /// No description provided for @presentationOfTheLord.
  ///
  /// In en, this message translates to:
  /// **'The Presentation of the Lord'**
  String get presentationOfTheLord;

  /// No description provided for @saintJoseph.
  ///
  /// In en, this message translates to:
  /// **'Saint Joseph, Spouse of the Blessed Virgin Mary'**
  String get saintJoseph;

  /// No description provided for @annunciation.
  ///
  /// In en, this message translates to:
  /// **'The Annunciation of the Lord'**
  String get annunciation;

  /// No description provided for @saintMark.
  ///
  /// In en, this message translates to:
  /// **'Saint Mark, Evangelist'**
  String get saintMark;

  /// No description provided for @saintPhilipAndSaintJames.
  ///
  /// In en, this message translates to:
  /// **'Saints Philip and James, Apostles'**
  String get saintPhilipAndSaintJames;

  /// No description provided for @saintMatthias.
  ///
  /// In en, this message translates to:
  /// **'Saint Matthias, Apostle'**
  String get saintMatthias;

  /// No description provided for @nativityOfSaintJohnTheBaptist.
  ///
  /// In en, this message translates to:
  /// **'The Nativity of Saint John the Baptist'**
  String get nativityOfSaintJohnTheBaptist;

  /// No description provided for @saintsPeterAndPaul.
  ///
  /// In en, this message translates to:
  /// **'Saints Peter and Paul, Apostles'**
  String get saintsPeterAndPaul;

  /// No description provided for @saintMaryMagdalene.
  ///
  /// In en, this message translates to:
  /// **'Saint Mary Magdalene'**
  String get saintMaryMagdalene;

  /// No description provided for @saintJames.
  ///
  /// In en, this message translates to:
  /// **'Saint James, Apostle'**
  String get saintJames;

  /// No description provided for @transfiguration.
  ///
  /// In en, this message translates to:
  /// **'The Transfiguration of the Lord'**
  String get transfiguration;

  /// No description provided for @assumption.
  ///
  /// In en, this message translates to:
  /// **'The Assumption of the Blessed Virgin Mary'**
  String get assumption;

  /// No description provided for @nativityOfMary.
  ///
  /// In en, this message translates to:
  /// **'The Nativity of the Blessed Virgin Mary'**
  String get nativityOfMary;

  /// No description provided for @exaltationOfTheCross.
  ///
  /// In en, this message translates to:
  /// **'The Exaltation of the Holy Cross'**
  String get exaltationOfTheCross;

  /// No description provided for @ourLadyOfSorrows.
  ///
  /// In en, this message translates to:
  /// **'Our Lady of Sorrows'**
  String get ourLadyOfSorrows;

  /// No description provided for @saintsMichaelGabrielRaphael.
  ///
  /// In en, this message translates to:
  /// **'Saints Michael, Gabriel and Raphael, Archangels'**
  String get saintsMichaelGabrielRaphael;

  /// No description provided for @allSaints.
  ///
  /// In en, this message translates to:
  /// **'All Saints'**
  String get allSaints;

  /// No description provided for @allSouls.
  ///
  /// In en, this message translates to:
  /// **'The Commemoration of All the Faithful Departed'**
  String get allSouls;

  /// No description provided for @dedicationOfLateranBasilica.
  ///
  /// In en, this message translates to:
  /// **'The Dedication of the Lateran Basilica'**
  String get dedicationOfLateranBasilica;

  /// No description provided for @saintAndrew.
  ///
  /// In en, this message translates to:
  /// **'Saint Andrew, Apostle'**
  String get saintAndrew;

  /// No description provided for @immaculateConception.
  ///
  /// In en, this message translates to:
  /// **'The Immaculate Conception of the Blessed Virgin Mary'**
  String get immaculateConception;

  /// No description provided for @saintStephen.
  ///
  /// In en, this message translates to:
  /// **'Saint Stephen, the First Martyr'**
  String get saintStephen;

  /// No description provided for @saintJohnApostle.
  ///
  /// In en, this message translates to:
  /// **'Saint John, Apostle and Evangelist'**
  String get saintJohnApostle;

  /// No description provided for @holyInnocents.
  ///
  /// In en, this message translates to:
  /// **'The Holy Innocents, Martyrs'**
  String get holyInnocents;

  /// No description provided for @holyFamily.
  ///
  /// In en, this message translates to:
  /// **'The Holy Family of Jesus, Mary and Joseph'**
  String get holyFamily;

  /// No description provided for @sacredHeart.
  ///
  /// In en, this message translates to:
  /// **'The Most Sacred Heart of Jesus'**
  String get sacredHeart;

  /// No description provided for @immaculateHeart.
  ///
  /// In en, this message translates to:
  /// **'The Immaculate Heart of the Blessed Virgin Mary'**
  String get immaculateHeart;

  /// No description provided for @maryMotherOfTheChurch.
  ///
  /// In en, this message translates to:
  /// **'The Blessed Virgin Mary, Mother of the Church'**
  String get maryMotherOfTheChurch;

  /// No description provided for @motherOfGod.
  ///
  /// In en, this message translates to:
  /// **'Mary, the Mother of God'**
  String get motherOfGod;

  /// No description provided for @guardianAngels.
  ///
  /// In en, this message translates to:
  /// **'The Holy Guardian Angels'**
  String get guardianAngels;

  /// No description provided for @holyNameOfMary.
  ///
  /// In en, this message translates to:
  /// **'The Most Holy Name of the Blessed Virgin Mary'**
  String get holyNameOfMary;

  /// No description provided for @ourLadyOfFatima.
  ///
  /// In en, this message translates to:
  /// **'Our Lady of Fatima'**
  String get ourLadyOfFatima;

  /// No description provided for @ourLadyOfGuadalupe.
  ///
  /// In en, this message translates to:
  /// **'Our Lady of Guadalupe'**
  String get ourLadyOfGuadalupe;

  /// No description provided for @ourLadyOfLourdes.
  ///
  /// In en, this message translates to:
  /// **'Our Lady of Lourdes'**
  String get ourLadyOfLourdes;

  /// No description provided for @ourLadyOfMountCarmel.
  ///
  /// In en, this message translates to:
  /// **'Our Lady of Mount Carmel'**
  String get ourLadyOfMountCarmel;

  /// No description provided for @ourLadyOfTheRosary.
  ///
  /// In en, this message translates to:
  /// **'Our Lady of the Rosary'**
  String get ourLadyOfTheRosary;

  /// No description provided for @presentationOfMary.
  ///
  /// In en, this message translates to:
  /// **'The Presentation of the Blessed Virgin Mary'**
  String get presentationOfMary;

  /// No description provided for @queenshipOfMary.
  ///
  /// In en, this message translates to:
  /// **'The Queenship of the Blessed Virgin Mary'**
  String get queenshipOfMary;

  /// No description provided for @birthOfJohnTheBaptist.
  ///
  /// In en, this message translates to:
  /// **'The Nativity of Saint John the Baptist'**
  String get birthOfJohnTheBaptist;

  /// No description provided for @saintThomas.
  ///
  /// In en, this message translates to:
  /// **'Saint Thomas the Apostle'**
  String get saintThomas;

  /// No description provided for @saintLuke.
  ///
  /// In en, this message translates to:
  /// **'Saint Luke the Evangelist'**
  String get saintLuke;

  /// No description provided for @saintMatthew.
  ///
  /// In en, this message translates to:
  /// **'Saint Matthew the Evangelist'**
  String get saintMatthew;

  /// No description provided for @saintAlphonsa.
  ///
  /// In en, this message translates to:
  /// **'Saint Alphonsa of the Immaculate Conception'**
  String get saintAlphonsa;

  /// No description provided for @saintDevasahayam.
  ///
  /// In en, this message translates to:
  /// **'Saint Devasahayam Pillai, martyr'**
  String get saintDevasahayam;

  /// No description provided for @saintEuphrasia.
  ///
  /// In en, this message translates to:
  /// **'Saint Euphrasia, virgin'**
  String get saintEuphrasia;

  /// No description provided for @saintFrancisXavier.
  ///
  /// In en, this message translates to:
  /// **'Saint Francis Xavier, priest'**
  String get saintFrancisXavier;

  /// No description provided for @saintGonsaloGarcia.
  ///
  /// In en, this message translates to:
  /// **'Saint Gonsalo Garcia, martyr'**
  String get saintGonsaloGarcia;

  /// No description provided for @saintJohnDeBrito.
  ///
  /// In en, this message translates to:
  /// **'Saint John de Brito, priest and martyr'**
  String get saintJohnDeBrito;

  /// No description provided for @saintJosephVaz.
  ///
  /// In en, this message translates to:
  /// **'Saint Joseph Vaz, priest'**
  String get saintJosephVaz;

  /// No description provided for @saintKuriakoseChavara.
  ///
  /// In en, this message translates to:
  /// **'Saint Kuriakose Elias Chavara, priest'**
  String get saintKuriakoseChavara;

  /// No description provided for @saintTeresaOfCalcutta.
  ///
  /// In en, this message translates to:
  /// **'Saint Teresa of Calcutta, virgin'**
  String get saintTeresaOfCalcutta;

  /// No description provided for @blessedAugustineThevarparambil.
  ///
  /// In en, this message translates to:
  /// **'Blessed Augustine Thevarparambil, priest'**
  String get blessedAugustineThevarparambil;

  /// No description provided for @blessedMariaTheresaChiramel.
  ///
  /// In en, this message translates to:
  /// **'Blessed Maria Theresa Chiramel, virgin'**
  String get blessedMariaTheresaChiramel;

  /// No description provided for @blessedRaniMaria.
  ///
  /// In en, this message translates to:
  /// **'Blessed Rani Maria, virgin and martyr'**
  String get blessedRaniMaria;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ta':
      return AppLocalizationsTa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

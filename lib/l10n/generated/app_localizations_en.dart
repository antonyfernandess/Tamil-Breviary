// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Catholic';

  @override
  String get today => 'Today';

  @override
  String get calendar => 'Calendar';

  @override
  String get readings => 'Readings';

  @override
  String get settings => 'Settings';

  @override
  String get liturgicalCalendar => 'LITURGICAL CALENDAR';

  @override
  String get previousYear => 'Previous year';

  @override
  String get nextYear => 'Next year';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get languageDescription =>
      'Choose the language used throughout the app.';

  @override
  String get english => 'English';

  @override
  String get tamil => 'Tamil';

  @override
  String get languageSaveError => 'Could not save your language preference.';

  @override
  String get ashWednesday => 'Ash Wednesday';

  @override
  String weekdayAfterAshWednesday(Object weekday) {
    return '$weekday after Ash Wednesday';
  }

  @override
  String weekOfSeason(Object weekday, Object week, Object season) {
    return '$weekday of week $week in $season';
  }

  @override
  String weekdayInSeason(Object weekday, Object season) {
    return '$weekday in $season';
  }

  @override
  String weekdayOfHolyWeek(Object weekday) {
    return '$weekday of Holy Week';
  }

  @override
  String get advent => 'Advent';

  @override
  String get christmasTime => 'Christmas Time';

  @override
  String get lent => 'Lent';

  @override
  String get sacredTriduum => 'the Sacred Triduum';

  @override
  String get easterTime => 'Easter Time';

  @override
  String get ordinaryTime => 'Ordinary Time';

  @override
  String sundayOfAdvent(Object week) {
    return '$week Sunday of Advent';
  }

  @override
  String sundayOfChristmas(Object week) {
    return '$week Sunday of Christmas';
  }

  @override
  String sundayOfLent(Object week) {
    return '$week Sunday of Lent';
  }

  @override
  String sundayOfTriduum(Object week) {
    return '$week Sunday of the Sacred Triduum';
  }

  @override
  String sundayOfEaster(Object week) {
    return '$week Sunday of Easter';
  }

  @override
  String sundayOfOrdinaryTime(Object week) {
    return '$week Sunday in Ordinary Time';
  }

  @override
  String get solemnity => 'Solemnity';

  @override
  String get feast => 'Feast';

  @override
  String get memorial => 'Memorial';

  @override
  String get optionalMemorial => 'Optional Memorial';

  @override
  String get commemoration => 'Commemoration';

  @override
  String get weekdayRank => 'Weekday';

  @override
  String orMemorial(Object celebration) {
    return 'or $celebration';
  }

  @override
  String get nativityOfTheLord => 'The Nativity of the Lord';

  @override
  String get palmSunday => 'Palm Sunday of the Passion of the Lord';

  @override
  String get holyThursday => 'Holy Thursday';

  @override
  String get goodFriday => 'Friday of the Passion of the Lord';

  @override
  String get easterSunday => 'Easter Sunday';

  @override
  String get ascension => 'The Ascension of the Lord';

  @override
  String get pentecost => 'Pentecost Sunday';

  @override
  String get trinitySunday => 'The Most Holy Trinity';

  @override
  String get corpusChristi => 'The Most Holy Body and Blood of Christ';

  @override
  String get epiphany => 'The Epiphany of the Lord';

  @override
  String get baptismOfTheLord => 'The Baptism of the Lord';

  @override
  String get christTheKing => 'Our Lord Jesus Christ, King of the Universe';

  @override
  String get presentationOfTheLord => 'The Presentation of the Lord';

  @override
  String get saintJoseph => 'Saint Joseph, Spouse of the Blessed Virgin Mary';

  @override
  String get annunciation => 'The Annunciation of the Lord';

  @override
  String get saintMark => 'Saint Mark, Evangelist';

  @override
  String get saintPhilipAndSaintJames => 'Saints Philip and James, Apostles';

  @override
  String get saintMatthias => 'Saint Matthias, Apostle';

  @override
  String get nativityOfSaintJohnTheBaptist =>
      'The Nativity of Saint John the Baptist';

  @override
  String get saintsPeterAndPaul => 'Saints Peter and Paul, Apostles';

  @override
  String get saintMaryMagdalene => 'Saint Mary Magdalene';

  @override
  String get saintJames => 'Saint James, Apostle';

  @override
  String get transfiguration => 'The Transfiguration of the Lord';

  @override
  String get assumption => 'The Assumption of the Blessed Virgin Mary';

  @override
  String get nativityOfMary => 'The Nativity of the Blessed Virgin Mary';

  @override
  String get exaltationOfTheCross => 'The Exaltation of the Holy Cross';

  @override
  String get ourLadyOfSorrows => 'Our Lady of Sorrows';

  @override
  String get saintsMichaelGabrielRaphael =>
      'Saints Michael, Gabriel and Raphael, Archangels';

  @override
  String get allSaints => 'All Saints';

  @override
  String get allSouls => 'The Commemoration of All the Faithful Departed';

  @override
  String get dedicationOfLateranBasilica =>
      'The Dedication of the Lateran Basilica';

  @override
  String get saintAndrew => 'Saint Andrew, Apostle';

  @override
  String get immaculateConception =>
      'The Immaculate Conception of the Blessed Virgin Mary';

  @override
  String get saintStephen => 'Saint Stephen, the First Martyr';

  @override
  String get saintJohnApostle => 'Saint John, Apostle and Evangelist';

  @override
  String get holyInnocents => 'The Holy Innocents, Martyrs';

  @override
  String get holyFamily => 'The Holy Family of Jesus, Mary and Joseph';

  @override
  String get sacredHeart => 'The Most Sacred Heart of Jesus';

  @override
  String get immaculateHeart =>
      'The Immaculate Heart of the Blessed Virgin Mary';

  @override
  String get maryMotherOfTheChurch =>
      'The Blessed Virgin Mary, Mother of the Church';

  @override
  String get motherOfGod => 'Mary, the Mother of God';

  @override
  String get guardianAngels => 'The Holy Guardian Angels';

  @override
  String get holyNameOfMary => 'The Most Holy Name of the Blessed Virgin Mary';

  @override
  String get ourLadyOfFatima => 'Our Lady of Fatima';

  @override
  String get ourLadyOfGuadalupe => 'Our Lady of Guadalupe';

  @override
  String get ourLadyOfLourdes => 'Our Lady of Lourdes';

  @override
  String get ourLadyOfMountCarmel => 'Our Lady of Mount Carmel';

  @override
  String get ourLadyOfTheRosary => 'Our Lady of the Rosary';

  @override
  String get presentationOfMary =>
      'The Presentation of the Blessed Virgin Mary';

  @override
  String get queenshipOfMary => 'The Queenship of the Blessed Virgin Mary';

  @override
  String get birthOfJohnTheBaptist => 'The Nativity of Saint John the Baptist';

  @override
  String get saintThomas => 'Saint Thomas the Apostle';

  @override
  String get saintLuke => 'Saint Luke the Evangelist';

  @override
  String get saintMatthew => 'Saint Matthew the Evangelist';

  @override
  String get saintAlphonsa => 'Saint Alphonsa of the Immaculate Conception';

  @override
  String get saintDevasahayam => 'Saint Devasahayam Pillai, martyr';

  @override
  String get saintEuphrasia => 'Saint Euphrasia, virgin';

  @override
  String get saintFrancisXavier => 'Saint Francis Xavier, priest';

  @override
  String get saintGonsaloGarcia => 'Saint Gonsalo Garcia, martyr';

  @override
  String get saintJohnDeBrito => 'Saint John de Brito, priest and martyr';

  @override
  String get saintJosephVaz => 'Saint Joseph Vaz, priest';

  @override
  String get saintKuriakoseChavara => 'Saint Kuriakose Elias Chavara, priest';

  @override
  String get saintTeresaOfCalcutta => 'Saint Teresa of Calcutta, virgin';

  @override
  String get blessedAugustineThevarparambil =>
      'Blessed Augustine Thevarparambil, priest';

  @override
  String get blessedMariaTheresaChiramel =>
      'Blessed Maria Theresa Chiramel, virgin';

  @override
  String get blessedRaniMaria => 'Blessed Rani Maria, virgin and martyr';
}

import 'package:flutter/foundation.dart';

import '../../l10n/generated/app_localizations.dart';

final Set<String> _reportedUnmappedKeys = <String>{};

/// Returns the localized display name of the celebration identified by [key].
///
/// Keys come from the engine ('nativity_of_the_lord') or are slugs of the
/// `feast_code` column of the feasts table. India-proper feasts carry an
/// `in_` prefix; when only the universal name is known that is tried too.
///
/// A key without a translation falls back to a Title Cased English name and
/// is reported once in debug builds, so a DB edit that breaks a name shows up
/// in the console instead of silently rendering English in the Tamil UI.
String celebrationName(
  String key,
  AppLocalizations strings, {
  String? fallbackName,
}) {
  final name =
      _lookup(key, strings) ??
      (key.startsWith('in_') ? _lookup(key.substring(3), strings) : null);
  if (name != null) return name;

  // No translation: show the source name as written (accents, commas and
  // capitalization intact) rather than a Title Cased slug.
  final source = fallbackName?.trim();
  if (source != null && source.isNotEmpty) return source;

  assert(() {
    if (_reportedUnmappedKeys.add(key)) {
      debugPrint('[celebration_names] No localized name for "$key".');
    }
    return true;
  }());

  return _titleCase(key.replaceAll('_', ' '));
}

String? _lookup(String key, AppLocalizations strings) {
  return switch (key) {
    'nativity_of_the_lord' => strings.nativityOfTheLord,
    'ash_wednesday' => strings.ashWednesday,
    'palm_sunday' => strings.palmSunday,
    'holy_thursday' => strings.holyThursday,
    'good_friday' => strings.goodFriday,
    'easter_sunday' => strings.easterSunday,
    'ascension' => strings.ascension,
    'pentecost' => strings.pentecost,
    'trinity_sunday' => strings.trinitySunday,
    'corpus_christi' => strings.corpusChristi,
    'epiphany' => strings.epiphany,
    'baptism_of_the_lord' => strings.baptismOfTheLord,
    'christ_the_king' => strings.christTheKing,
    'presentation_of_the_lord' => strings.presentationOfTheLord,
    'saint_joseph' => strings.saintJoseph,
    'annunciation' => strings.annunciation,
    'saint_mark' => strings.saintMark,
    'saints_philip_and_james' => strings.saintPhilipAndSaintJames,
    'saint_matthias' => strings.saintMatthias,
    'nativity_of_saint_john_the_baptist' =>
      strings.nativityOfSaintJohnTheBaptist,
    'saints_peter_and_paul' => strings.saintsPeterAndPaul,
    'saint_mary_magdalene' => strings.saintMaryMagdalene,
    'saint_james' => strings.saintJames,
    'transfiguration_of_the_lord' => strings.transfiguration,
    'assumption_of_the_blessed_virgin_mary' => strings.assumption,
    'nativity_of_the_blessed_virgin_mary' => strings.nativityOfMary,
    'exaltation_of_the_holy_cross' => strings.exaltationOfTheCross,
    'our_lady_of_sorrows' => strings.ourLadyOfSorrows,
    'saints_michael_gabriel_and_raphael' => strings.saintsMichaelGabrielRaphael,
    'all_saints' => strings.allSaints,
    'all_souls' => strings.allSouls,
    'dedication_of_the_lateran_basilica' => strings.dedicationOfLateranBasilica,
    'saint_andrew' => strings.saintAndrew,
    'immaculate_conception' => strings.immaculateConception,
    'saint_stephen' => strings.saintStephen,
    'saint_john' => strings.saintJohnApostle,
    'holy_innocents' => strings.holyInnocents,
    'holy_innocents_martyrs' => strings.holyInnocents,
    'holy_family' => strings.holyFamily,
    'sacred_heart_of_jesus' => strings.sacredHeart,
    'immaculate_heart_of_mary' => strings.immaculateHeart,
    'mary_mother_of_the_church' => strings.maryMotherOfTheChurch,
    'mary_the_mother_of_god' => strings.motherOfGod,
    'guardian_angels' => strings.guardianAngels,
    'holy_name_of_the_blessed_virgin_mary' => strings.holyNameOfMary,
    'our_lady_of_fatima' => strings.ourLadyOfFatima,
    'our_lady_of_guadalupe' => strings.ourLadyOfGuadalupe,
    'our_lady_of_lourdes' => strings.ourLadyOfLourdes,
    'our_lady_of_mount_carmel' => strings.ourLadyOfMountCarmel,
    'our_lady_of_the_rosary' => strings.ourLadyOfTheRosary,
    'presentation_of_the_blessed_virgin_mary' => strings.presentationOfMary,
    'queenship_of_blessed_virgin_mary' => strings.queenshipOfMary,
    'birth_of_saint_john_the_baptist' => strings.birthOfJohnTheBaptist,
    'birth_of_the_blessed_virgin_mary' => strings.nativityOfMary,
    'saint_thomas_the_apostle' => strings.saintThomas,
    'in_saint_thomas_the_apostle' => strings.saintThomas,
    'saint_andrew_the_apostle' => strings.saintAndrew,
    'saint_mark_the_evangelist' => strings.saintMark,
    'saint_john_the_apostle_and_evangelist' => strings.saintJohnApostle,
    'saint_luke_the_evangelist' => strings.saintLuke,
    'saint_matthew_the_evangelist_apostle_evangelist' => strings.saintMatthew,
    'saint_joseph_husband_of_the_blessed_virgin_mary' => strings.saintJoseph,
    'in_blessed_augustine_thevarparambil_priest' =>
      strings.blessedAugustineThevarparambil,
    'in_blessed_maria_theresa_chiramel_virgin' =>
      strings.blessedMariaTheresaChiramel,
    'in_blessed_rani_maria_virgin_martyr' => strings.blessedRaniMaria,
    'in_saint_alphonsa_of_the_immaculate_conception_alphonsa_muttathupadathu_virgin' =>
      strings.saintAlphonsa,
    'in_saint_devasahayam_pillai_martyr' => strings.saintDevasahayam,
    'in_saint_euphrasia_virgin' => strings.saintEuphrasia,
    'in_saint_francis_xavier_priest' => strings.saintFrancisXavier,
    'in_saint_gonsalo_garcia_martyr' => strings.saintGonsaloGarcia,
    'in_saint_john_de_brito_priest_and_martyr' => strings.saintJohnDeBrito,
    'in_saint_joseph_vaz_priest' => strings.saintJosephVaz,
    'in_saint_kuriakose_elias_chavara_priest' => strings.saintKuriakoseChavara,
    'in_saint_teresa_of_calcutta_virgin' => strings.saintTeresaOfCalcutta,
    // Keys produced by the feasts database for celebrations whose strings
    // were originally registered under shorter names.
    'annunciation_of_the_lord' => strings.annunciation,
    'immaculate_conception_of_the_blessed_virgin_mary' => strings.immaculateConception,
    'saints_peter_and_paul_apostles' => strings.saintsPeterAndPaul,
    'saint_matthias_the_apostle' => strings.saintMatthias,
    'saint_james_apostle' => strings.saintJames,
    'saints_philip_and_james_apostles' => strings.saintPhilipAndSaintJames,
    'saints_michael_gabriel_and_raphael_archangels' => strings.saintsMichaelGabrielRaphael,
    'saint_stephen_the_first_martyr' => strings.saintStephen,
    'saint_francis_xavier_priest' => strings.saintFrancisXavier,
    'saint_teresa_of_calcutta_virgin' => strings.saintTeresaOfCalcutta,
    _ => null,
  };
}

String _titleCase(String value) {
  return value
      .split(' ')
      .where((word) => word.isNotEmpty)
      .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
      .join(' ');
}

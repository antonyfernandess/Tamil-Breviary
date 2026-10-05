import '../../domain/enums/liturgical_color.dart';

/// Chooses the vestment colour of a saint's celebration from its name.
///
/// Rules (General Instruction of the Roman Missal, 346):
///  * red: martyrs, apostles and evangelists, the Holy Innocents, the
///    Exaltation of the Holy Cross, the Beheading of St John the Baptist;
///  * violet: the Commemoration of All the Faithful Departed (All Souls);
///  * white: everything else, including the deliberate exceptions below.
///
/// The feasts that name an apostle but are white are the Conversion of
/// St Paul, the Chair of St Peter, the Dedications of basilicas, and
/// St John the Apostle (27 December, in Christmas Time).
class FeastColorResolver {
  const FeastColorResolver._();

  static const _violet = ['faithful departed', 'all souls'];

  static const _whiteExceptions = [
    'conversion of',
    'chair of',
    'dedication of',
    'john the apostle',
  ];

  static const _red = [
    'martyr',
    'apostle',
    'evangelist',
    'innocents',
    'exaltation of the holy cross',
    'beheading',
  ];

  static LiturgicalColor resolve(String name) {
    final text = name.toLowerCase();

    if (_violet.any(text.contains)) return LiturgicalColor.violet;
    if (_whiteExceptions.any(text.contains)) return LiturgicalColor.white;
    if (_red.any(text.contains)) return LiturgicalColor.red;
    return LiturgicalColor.white;
  }
}

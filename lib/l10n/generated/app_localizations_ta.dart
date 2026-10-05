// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'கத்தோலிக்கம்';

  @override
  String get today => 'இன்று';

  @override
  String get calendar => 'நாள்காட்டி';

  @override
  String get readings => 'வாசகங்கள்';

  @override
  String get settings => 'அமைப்புகள்';

  @override
  String get liturgicalCalendar => 'திருவழிபாட்டு நாள்காட்டி';

  @override
  String get previousYear => 'முந்தைய ஆண்டு';

  @override
  String get nextYear => 'அடுத்த ஆண்டு';

  @override
  String get settingsTitle => 'அமைப்புகள்';

  @override
  String get language => 'மொழி';

  @override
  String get languageDescription =>
      'செயலியில் பயன்படுத்தப்படும் மொழியைத் தேர்ந்தெடுக்கவும்.';

  @override
  String get english => 'ஆங்கிலம்';

  @override
  String get tamil => 'தமிழ்';

  @override
  String get languageSaveError => 'மொழி விருப்பத்தைச் சேமிக்க முடியவில்லை.';

  @override
  String get ashWednesday => 'திருநீற்றுப் புதன்';

  @override
  String weekdayAfterAshWednesday(Object weekday) {
    return 'திருநீற்றுப் புதனுக்குப் பின் $weekday';
  }

  @override
  String weekOfSeason(Object weekday, Object week, Object season) {
    return '$season - $weekஆம் வாரம், $weekday';
  }

  @override
  String weekdayInSeason(Object weekday, Object season) {
    return '$season - $weekday';
  }

  @override
  String weekdayOfHolyWeek(Object weekday) {
    return 'புனித வாரம் - $weekday';
  }

  @override
  String get advent => 'திருவருகைக் காலம்';

  @override
  String get christmasTime => 'கிறிஸ்து பிறப்புக் காலம்';

  @override
  String get lent => 'தவக்காலம்';

  @override
  String get sacredTriduum => 'புனித மூன்று நாள்';

  @override
  String get easterTime => 'உயிர்ப்பு காலம்';

  @override
  String get ordinaryTime => 'பொதுக்காலம்';

  @override
  String sundayOfAdvent(Object week) {
    return 'திருவருகைக் காலத்தின் $weekஆம் ஞாயிறு';
  }

  @override
  String sundayOfChristmas(Object week) {
    return 'கிறிஸ்து பிறப்புக் காலத்தின் $weekஆம் ஞாயிறு';
  }

  @override
  String sundayOfLent(Object week) {
    return 'தவக்காலத்தின் $weekஆம் ஞாயிறு';
  }

  @override
  String sundayOfTriduum(Object week) {
    return 'புனித மூன்று நாள் காலத்தின் $weekஆம் ஞாயிறு';
  }

  @override
  String sundayOfEaster(Object week) {
    return 'உயிர்ப்பு காலத்தின் $weekஆம் ஞாயிறு';
  }

  @override
  String sundayOfOrdinaryTime(Object week) {
    return 'பொதுக்காலத்தின் $weekஆம் ஞாயிறு';
  }

  @override
  String get solemnity => 'பெருவிழா';

  @override
  String get feast => 'விழா';

  @override
  String get memorial => 'நினைவுநாள்';

  @override
  String get optionalMemorial => 'விருப்ப நினைவுநாள்';

  @override
  String get commemoration => 'நினைவுகூர்தல்';

  @override
  String get weekdayRank => 'வாரநாள்';

  @override
  String orMemorial(Object celebration) {
    return 'அல்லது $celebration';
  }

  @override
  String get nativityOfTheLord => 'ஆண்டவரின் பிறப்பு';

  @override
  String get palmSunday => 'ஆண்டவரின் திருப்பாடுகளின் குருத்து ஞாயிறு';

  @override
  String get holyThursday => 'புனித வியாழன்';

  @override
  String get goodFriday => 'ஆண்டவரின் திருப்பாடுகளின் வெள்ளி';

  @override
  String get easterSunday => 'ஆண்டவரின் உயிர்ப்பு ஞாயிறு';

  @override
  String get ascension => 'ஆண்டவரின் விண்ணேற்றம்';

  @override
  String get pentecost => 'பெந்தக்கோஸ்து ஞாயிறு';

  @override
  String get trinitySunday => 'மிகத் தூய மூவொரு இறைவன்';

  @override
  String get corpusChristi => 'கிறிஸ்துவின் திருவுடல் திருஇரத்தம்';

  @override
  String get epiphany => 'ஆண்டவரின் திருக்காட்சி';

  @override
  String get baptismOfTheLord => 'ஆண்டவரின் திருமுழுக்கு';

  @override
  String get christTheKing => 'அகில உலக அரசர் நம் ஆண்டவர் இயேசு கிறிஸ்து';

  @override
  String get presentationOfTheLord =>
      'ஆண்டவரைக் கோவிலில் காணிக்கையாக அர்ப்பணித்தல்';

  @override
  String get saintJoseph => 'தூய யோசேப்பு, அன்னை மரியாவின் துணைவர்';

  @override
  String get annunciation => 'ஆண்டவரின் அறிவிப்பு';

  @override
  String get saintMark => 'தூய மாற்கு, நற்செய்தியாளர்';

  @override
  String get saintPhilipAndSaintJames =>
      'தூய பிலிப்பு மற்றும் தூய யாக்கோபு, திருத்தூதர்கள்';

  @override
  String get saintMatthias => 'தூய மத்தியா, திருத்தூதர்';

  @override
  String get nativityOfSaintJohnTheBaptist => 'திருமுழுக்கு யோவானின் பிறப்பு';

  @override
  String get saintsPeterAndPaul =>
      'தூய பேதுரு மற்றும் தூய பவுல், திருத்தூதர்கள்';

  @override
  String get saintMaryMagdalene => 'தூய மகதலா மரியா';

  @override
  String get saintJames => 'தூய யாக்கோபு, திருத்தூதர்';

  @override
  String get transfiguration => 'ஆண்டவரின் உருமாற்றம்';

  @override
  String get assumption => 'அன்னை மரியாவின் விண்ணேற்பு';

  @override
  String get nativityOfMary => 'அன்னை மரியாவின் பிறப்பு';

  @override
  String get exaltationOfTheCross => 'திருச்சிலுவையின் மேன்மை';

  @override
  String get ourLadyOfSorrows => 'துயருறும் அன்னை மரியா';

  @override
  String get saintsMichaelGabrielRaphael =>
      'தூய மிக்கேல், கபிரியேல், ரபேல், வானதூதர்கள்';

  @override
  String get allSaints => 'அனைத்துப் புனிதர்கள்';

  @override
  String get allSouls => 'இறைநம்பிக்கையில் இறந்த அனைவரின் நினைவு';

  @override
  String get dedicationOfLateranBasilica =>
      'லாத்தரன் பெருங்கோவிலின் நேர்ந்தளிப்பு';

  @override
  String get saintAndrew => 'தூய அந்திரேயா, திருத்தூதர்';

  @override
  String get immaculateConception => 'அன்னை மரியாவின் அமல உற்பவம்';

  @override
  String get saintStephen => 'தூய ஸ்தேவான், முதல் மறைசாட்சி';

  @override
  String get saintJohnApostle => 'தூய யோவான், திருத்தூதரும் நற்செய்தியாளரும்';

  @override
  String get holyInnocents => 'மாசில்லாக் குழந்தைகள், மறைசாட்சிகள்';

  @override
  String get holyFamily => 'இயேசு, மரியா, யோசேப்பு அடங்கிய திருக்குடும்பம்';

  @override
  String get sacredHeart => 'இயேசுவின் மிகத் தூய இதயம்';

  @override
  String get immaculateHeart => 'அன்னை மரியாவின் மாசற்ற இதயம்';

  @override
  String get maryMotherOfTheChurch => 'திருச்சபையின் தாயான தூய கன்னி மரியா';

  @override
  String get motherOfGod => 'இறைவனின் தாய் அன்னை மரியா';

  @override
  String get guardianAngels => 'புனித காவல் வானதூதர்கள்';

  @override
  String get holyNameOfMary => 'அன்னை மரியாவின் மிகத் தூய பெயர்';

  @override
  String get ourLadyOfFatima => 'பாத்திமா அன்னை';

  @override
  String get ourLadyOfGuadalupe => 'குவாதலூப்பே அன்னை';

  @override
  String get ourLadyOfLourdes => 'லூர்து அன்னை';

  @override
  String get ourLadyOfMountCarmel => 'கார்மேல் மலை அன்னை';

  @override
  String get ourLadyOfTheRosary => 'செபமாலை அன்னை';

  @override
  String get presentationOfMary => 'அன்னை மரியாவின் ஆலய அர்ப்பணம்';

  @override
  String get queenshipOfMary => 'அன்னை மரியாவின் அரசத் தன்மை';

  @override
  String get birthOfJohnTheBaptist => 'திருமுழுக்கு யோவானின் பிறப்பு';

  @override
  String get saintThomas => 'தூய தோமையார், திருத்தூதர்';

  @override
  String get saintLuke => 'தூய லூக்கா, நற்செய்தியாளர்';

  @override
  String get saintMatthew => 'தூய மத்தேயு, திருத்தூதரும் நற்செய்தியாளரும்';

  @override
  String get saintAlphonsa => 'அமல உற்பவ தூய அல்போன்சா';

  @override
  String get saintDevasahayam => 'தூய தேவசகாயம் பிள்ளை, மறைசாட்சி';

  @override
  String get saintEuphrasia => 'தூய யூப்ராசியா, கன்னியர்';

  @override
  String get saintFrancisXavier => 'தூய பிரான்சிஸ் சவேரியார், குரு';

  @override
  String get saintGonsaloGarcia => 'தூய கோன்சாலோ கார்சியா, மறைசாட்சி';

  @override
  String get saintJohnDeBrito => 'தூய அருளானந்தர், குருவும் மறைசாட்சியும்';

  @override
  String get saintJosephVaz => 'தூய யோசேப்பு வாஸ், குரு';

  @override
  String get saintKuriakoseChavara => 'தூய குரியாக்கோஸ் எலியாஸ் சாவரா, குரு';

  @override
  String get saintTeresaOfCalcutta => 'கல்கத்தா தூய தெரேசா';

  @override
  String get blessedAugustineThevarparambil =>
      'அருளாளர் அகஸ்தீன் தேவர்பரம்பில், குரு';

  @override
  String get blessedMariaTheresaChiramel =>
      'அருளாளர் மரியா தெரேசா சிரமேல், கன்னியர்';

  @override
  String get blessedRaniMaria =>
      'அருளாளர் ராணி மரியா, கன்னியரும் மறைசாட்சியும்';
}

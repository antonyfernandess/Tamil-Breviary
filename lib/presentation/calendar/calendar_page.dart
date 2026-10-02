import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../modules/liturgical_engine/domain/calculations/easter/easter_calculator.dart';
import '../../modules/liturgical_engine/application/services/calendar_service.dart';
import '../../modules/liturgical_engine/domain/entities/liturgical_day.dart';
import '../../modules/liturgical_engine/domain/enums/liturgical_color.dart';
import '../../modules/liturgical_engine/domain/enums/liturgical_rank.dart';
import '../../modules/liturgical_engine/domain/enums/liturgical_season.dart';
import '../widgets/bottom_nav_bar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final ScrollController _scrollController = ScrollController();
  late int _year;
  late DateTime _selectedDate;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _year = today.year;
    _selectedDate = DateTime(today.year, today.month, today.day);
  }

  @override
  Widget build(BuildContext context) {
    final calendar = context.watch<CalendarService>();
    final strings = AppLocalizations.of(context)!;
    final months = List.generate(12, (index) => DateTime(_year, index + 1));

    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      body: SafeArea(
        child: Column(
          children: [
            _CalendarToolbar(
              year: _year,
              onPrevious: () => _changeYear(-1),
              onNext: () => _changeYear(1),
              onToday: _goToToday,
              strings: strings,
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.zero,
                itemCount: months.length,
                itemBuilder: (context, index) {
                  final month = months[index];
                  return _MonthSection(
                    month: month,
                    selectedDate: _selectedDate,
                    getDay: calendar.getDay,
                    onDateSelected: _selectDate,
                    strings: strings,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedTab: 'calendar'),
    );
  }

  void _goToToday() {
    final today = DateTime.now();
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
    setState(() {
      _year = today.year;
      _selectedDate = DateTime(today.year, today.month, today.day);
    });
  }

  void _changeYear(int amount) {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
    setState(() {
      _year += amount;
      _selectedDate = DateTime(_year, 1, 1);
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = DateTime(date.year, date.month, date.day);
    });
  }
}

class _CalendarToolbar extends StatelessWidget {
  const _CalendarToolbar({
    required this.year,
    required this.onPrevious,
    required this.onNext,
    required this.onToday,
    required this.strings,
  });

  final int year;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onToday;
  final AppLocalizations strings;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF1F1F1),
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      child: Row(
        children: [
          IconButton(
            onPressed: onPrevious,
            tooltip: strings.previousYear,
            icon: const Icon(Icons.chevron_left_rounded),
            color: const Color(0xFF555555),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  strings.liturgicalCalendar,
                  style: TextStyle(
                    color: Color(0xFF777777),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.6,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  NumberFormat.decimalPattern(strings.localeName).format(year),
                  style: const TextStyle(
                    color: Color(0xFF263A32),
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onNext,
            tooltip: strings.nextYear,
            icon: const Icon(Icons.chevron_right_rounded),
            color: const Color(0xFF555555),
          ),
          TextButton(
            onPressed: onToday,
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF315C48),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              strings.today,
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthSection extends StatelessWidget {
  const _MonthSection({
    required this.month,
    required this.selectedDate,
    required this.getDay,
    required this.onDateSelected,
    required this.strings,
  });

  final DateTime month;
  final DateTime selectedDate;
  final LiturgicalDay Function(DateTime date) getDay;
  final ValueChanged<DateTime> onDateSelected;
  final AppLocalizations strings;

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: const Color(0xFF747474),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            DateFormat(
              'MMMM yyyy',
              Localizations.localeOf(context).toString(),
            ).format(month),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.1,
            ),
          ),
        ),
        for (var dayNumber = 1; dayNumber <= daysInMonth; dayNumber++)
          _CalendarDayRow(
            day: getDay(DateTime(month.year, month.month, dayNumber)),
            selected: _isSameDate(
              DateTime(month.year, month.month, dayNumber),
              selectedDate,
            ),
            onTap: onDateSelected,
            strings: strings,
            localeName: Localizations.localeOf(context).toString(),
          ),
      ],
    );
  }
}

class _CalendarDayRow extends StatelessWidget {
  const _CalendarDayRow({
    required this.day,
    required this.selected,
    required this.onTap,
    required this.strings,
    required this.localeName,
  });

  final LiturgicalDay day;
  final bool selected;
  final ValueChanged<DateTime> onTap;
  final AppLocalizations strings;
  final String localeName;

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(day.color);
    final primaryTitle = _celebrationTitle(day, strings, localeName);
    final isEmphasized =
        day.date.weekday == DateTime.sunday ||
        day.rank == LiturgicalRank.solemnity ||
        day.rank == LiturgicalRank.feast;

    return Material(
      color: selected ? const Color(0xFFBCEFF0) : const Color(0xFFF3F3F3),
      child: InkWell(
        onTap: () => onTap(day.date),
        child: Container(
          constraints: const BoxConstraints(minHeight: 58),
          padding: const EdgeInsets.fromLTRB(14, 10, 12, 10),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFFD4D4D4), width: 0.7),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 72,
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    DateFormat('EEE d', localeName).format(day.date),
                    style: const TextStyle(
                      color: Color(0xFF353535),
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: primaryTitle,
                            style: TextStyle(
                              color: const Color(0xFF191919),
                              fontWeight: isEmphasized
                                  ? FontWeight.w800
                                  : FontWeight.w400,
                            ),
                          ),
                          const WidgetSpan(child: SizedBox(width: 5)),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: _ColorDot(color: color),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, height: 1.35),
                    ),
                    if (day.rank != LiturgicalRank.feria) ...[
                      const SizedBox(height: 2),
                      Text(
                        '- ${_rankLabel(day.rank, strings)}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF404040),
                          fontSize: 17,
                          fontStyle: FontStyle.italic,
                          height: 1.25,
                        ),
                      ),
                    ],
                    for (final memorial in day.optionalMemorials) ...[
                      const SizedBox(height: 5),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: strings.orMemorial(
                                _celebrationName(memorial.key.value, strings),
                              ),
                            ),
                            const WidgetSpan(child: SizedBox(width: 5)),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: _ColorDot(
                                color: _colorFor(memorial.color),
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF242424),
                          fontSize: 18,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 9,
      height: 9,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

String _celebrationTitle(
  LiturgicalDay day,
  AppLocalizations strings,
  String localeName,
) {
  final key = day.celebration.value;
  final weekday = DateFormat('EEEE', localeName).format(day.date);
  final week = day.weekOfSeason;
  final season = _seasonName(day, strings);

  final easter = EasterCalculator.forYear(day.date.year);
  final ashWednesday = DateTime(easter.year, easter.month, easter.day - 46);
  for (var offset = 1; offset <= 3; offset++) {
    final dateAfterAshWednesday = DateTime(
      ashWednesday.year,
      ashWednesday.month,
      ashWednesday.day + offset,
    );
    if (_isSameDate(day.date, dateAfterAshWednesday)) {
      return strings.weekdayAfterAshWednesday(weekday);
    }
  }

  if (key.endsWith('_sunday')) {
    return _sundayName(day, week, strings);
  }

  if (key.endsWith('_feria')) {
    if (week == null) return strings.weekdayInSeason(weekday, season);
    return strings.weekOfSeason(weekday, _number(week, localeName), season);
  }

  return _celebrationName(key, strings);
}

String _sundayName(LiturgicalDay day, int? week, AppLocalizations strings) {
  final localizedWeek = _ordinalText(week ?? 1, strings.localeName);
  return switch (day.season) {
    LiturgicalSeason.advent => strings.sundayOfAdvent(localizedWeek),
    LiturgicalSeason.christmas => strings.sundayOfChristmas(localizedWeek),
    LiturgicalSeason.lent => strings.sundayOfLent(localizedWeek),
    LiturgicalSeason.sacredTriduum => strings.sundayOfTriduum(localizedWeek),
    LiturgicalSeason.easter => strings.sundayOfEaster(localizedWeek),
    LiturgicalSeason.ordinaryTime => strings.sundayOfOrdinaryTime(
      localizedWeek,
    ),
  };
}

String _seasonName(LiturgicalDay day, AppLocalizations strings) {
  return switch (day.season) {
    LiturgicalSeason.advent => strings.advent,
    LiturgicalSeason.christmas => strings.christmasTime,
    LiturgicalSeason.lent => strings.lent,
    LiturgicalSeason.sacredTriduum => strings.sacredTriduum,
    LiturgicalSeason.easter => strings.easterTime,
    LiturgicalSeason.ordinaryTime => strings.ordinaryTime,
  };
}

String _rankLabel(LiturgicalRank rank, AppLocalizations strings) {
  return switch (rank) {
    LiturgicalRank.solemnity => strings.solemnity,
    LiturgicalRank.feast => strings.feast,
    LiturgicalRank.memorial => strings.memorial,
    LiturgicalRank.optionalMemorial => strings.optionalMemorial,
    LiturgicalRank.commemoration => strings.commemoration,
    LiturgicalRank.feria => strings.weekdayRank,
  };
}

String _number(int value, String localeName) {
  return NumberFormat.decimalPattern(localeName).format(value);
}

String _ordinalText(int value, String localeName) {
  final number = _number(value, localeName);
  if (localeName == 'ta') return number;

  final suffix = value % 100 >= 11 && value % 100 <= 13
      ? 'th'
      : switch (value % 10) {
          1 => 'st',
          2 => 'nd',
          3 => 'rd',
          _ => 'th',
        };
  return '$number$suffix';
}

String _celebrationName(String key, AppLocalizations strings) {
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
    _ => _titleCase(key.replaceAll('_', ' ')),
  };
}

String _titleCase(String value) {
  return value
      .split(' ')
      .where((word) => word.isNotEmpty)
      .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
      .join(' ');
}

Color _colorFor(LiturgicalColor color) {
  return switch (color) {
    LiturgicalColor.green => const Color(0xFF36B64A),
    LiturgicalColor.violet => const Color.fromARGB(255, 65, 28, 99),
    LiturgicalColor.white => const Color(0xFF777777),
    LiturgicalColor.red => const Color(0xFFEF3E3E),
    LiturgicalColor.rose => const Color(0xFFE78DAD),
  };
}

bool _isSameDate(DateTime first, DateTime second) =>
    first.year == second.year &&
    first.month == second.month &&
    first.day == second.day;

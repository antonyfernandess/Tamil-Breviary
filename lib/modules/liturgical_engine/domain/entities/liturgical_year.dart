import '../calculations/liturgical_date.dart';
import 'liturgical_day.dart';

class LiturgicalYear {
  LiturgicalYear({required this.year});

  final int year;

  final Map<DateTime, LiturgicalDay> _days = {};

  void addDay(LiturgicalDay day) {
    _days[LiturgicalDate.normalize(day.date)] = day;
  }

  LiturgicalDay? getDay(DateTime date) {
    return _days[LiturgicalDate.normalize(date)];
  }

  List<LiturgicalDay> get days {
    final sorted = _days.values.toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    return sorted;
  }
}

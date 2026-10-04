class LiturgicalDate {
  const LiturgicalDate._();

  static DateTime normalize(DateTime date) =>
      DateTime.utc(date.year, date.month, date.day);

  static DateTime addDays(DateTime date, int days) =>
      DateTime.utc(date.year, date.month, date.day + days);

  static int daysBetween(DateTime start, DateTime end) =>
      normalize(end).difference(normalize(start)).inDays;
}

/// The month and day of Easter Sunday for a given Gregorian year.
class EasterResult {
  const EasterResult({required this.month, required this.day});

  /// Month of Easter Sunday (3 = March, 4 = April).
  final int month;

  /// Day of the month of Easter Sunday.
  final int day;

  @override
  String toString() => 'EasterResult($month/$day)';
}

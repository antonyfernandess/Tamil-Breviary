import 'easter_result.dart';

/// Computes the date of Easter Sunday using the Anonymous Gregorian
/// algorithm (also known as the Meeus/Jones/Butcher algorithm).
///
/// Only valid for Gregorian years, i.e. [minYear] onward.
class EasterAlgorithm {
  const EasterAlgorithm._();

  /// First year of the Gregorian calendar the algorithm is defined for.
  static const int minYear = 1583;

  /// Upper bound kept well inside the range of [DateTime].
  static const int maxYear = 9999;

  /// Returns the month and day of Easter Sunday for [year].
  ///
  /// Throws a [RangeError] when [year] is outside [minYear]..[maxYear].
  static EasterResult calculate(int year) {
    if (year < minYear || year > maxYear) {
      throw RangeError.range(year, minYear, maxYear, 'year');
    }

    final a = year % 19;
    final b = year ~/ 100;
    final c = year % 100;
    final d = b ~/ 4;
    final e = b % 4;
    final f = (b + 8) ~/ 25;
    final g = (b - f + 1) ~/ 3;
    final h = (19 * a + b - d - g + 15) % 30;
    final i = c ~/ 4;
    final k = c % 4;
    final l = (32 + 2 * e + 2 * i - h - k) % 7;
    final m = (a + 11 * h + 22 * l) ~/ 451;
    final month = (h + l - 7 * m + 114) ~/ 31;
    final day = ((h + l - 7 * m + 114) % 31) + 1;

    return EasterResult(month: month, day: day);
  }
}

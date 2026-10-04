import 'easter_algorithm.dart';

/// Public entry point for getting Easter Sunday as a real (UTC) [DateTime].
///
/// Wraps [EasterAlgorithm] and caches results per year, since many other
/// liturgical dates (Ash Wednesday, Ascension, Pentecost, ...) are computed
/// relative to Easter and would otherwise trigger repeated calculation.
class EasterCalculator {
  const EasterCalculator._();

  static final Map<int, DateTime> _cache = {};

  /// Returns Easter Sunday for [year] at 00:00 UTC.
  static DateTime forYear(int year) {
    return _cache.putIfAbsent(year, () {
      final result = EasterAlgorithm.calculate(year);
      return DateTime.utc(year, result.month, result.day);
    });
  }
}

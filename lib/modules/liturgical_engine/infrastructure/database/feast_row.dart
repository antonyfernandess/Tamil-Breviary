/// A row in the feasts table, representing a single feast day.
class FeastRow {
  final int month;
  final int day;
  final String name;
  final String feastType;
  final int? addedYear;
  final int? removedYear;

  const FeastRow({
    required this.month,
    required this.day,
    required this.name,
    required this.feastType,
    required this.addedYear,
    required this.removedYear,
  });
  /// Create a FeastRow from a map of values, typically from a database query result.
  factory FeastRow.fromMap(Map<String, Object?> map) {
    return FeastRow(
      month: map['feast_month'] as int,
      day: map['feast_date'] as int,
      name: map['feast_code'] as String,
      feastType: map['feast_type'] as String,
      addedYear: map['added_year'] as int?,
      removedYear: map['removed_year'] as int?,
    );
  }

  /// True if this row is the correct one to use for [year] — i.e. it
  /// had already been added (or has no added_year restriction) and
  /// hadn't yet been removed/superseded by that year.
  bool appliesInYear(int year) {
    final addedOk = addedYear == null || year >= addedYear!;
    final removedOk = removedYear == null || year < removedYear!;
    return addedOk && removedOk;
  }
}

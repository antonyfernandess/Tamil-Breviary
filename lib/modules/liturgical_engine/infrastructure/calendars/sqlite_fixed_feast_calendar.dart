import '../../domain/definitions/celebration_definition.dart';
import '../../domain/definitions/liturgical_calendar.dart';
import '../../domain/enums/liturgical_color.dart';
import '../../domain/enums/liturgical_rank.dart';
import '../../domain/rules/fixed_date_rule.dart';
import '../../domain/value_objects/celebration_key.dart';
import '../database/feast_row.dart';

/// A [LiturgicalCalendar] backed by feast data loaded from SQLite.
/// Rows are pre-loaded into memory (see FeastRepository) so that
/// per-year filtering here stays synchronous, matching the rest of
/// the engine.
class SqliteFixedFeastCalendar implements LiturgicalCalendar {
  final List<FeastRow> _rows;

  SqliteFixedFeastCalendar({required List<FeastRow> rows}) : _rows = List<FeastRow>.unmodifiable(rows);

  @override
  String get key => 'sqlite_fixed_feasts';

  @override
  Iterable<CelebrationDefinition> celebrationsForYear(int year) {
    // Group by date so that when two rows share a day (e.g. St. Mary
    // Magdalene as Mem pre-2016 and Feast from 2016 on) only the row
    // that actually applies in this year survives.
    final byDate = <String, FeastRow>{};

    for (final row in _rows) {
      if (!row.appliesInYear(year)) continue;

      final dateKey = '${row.month}-${row.day}';
      final existing = byDate[dateKey];

      if (existing == null || (row.addedYear ?? 0) > (existing.addedYear ?? 0)) {
        byDate[dateKey] = row;
      }
    }

    return byDate.values.map(_toDefinition);
  }

  CelebrationDefinition _toDefinition(FeastRow row) {
    return CelebrationDefinition(
      key: CelebrationKey(_slugify(row.name)),
      rule: FixedDateRule(month: row.month, day: row.day),
      rank: _mapRank(row.feastType),
      color: _mapColor(row.name),
    );
  }

  String _slugify(String name) {
    return name
        .toLowerCase()
        .replaceAll(RegExp(r"[^a-z0-9\s]"), '')
        .trim()
        .replaceAll(RegExp(r"\s+"), '_');
  }

  LiturgicalRank _mapRank(String feastType) {
    switch (feastType) {
      case 'Solemnity':
      case 'Solemnity-PrincipalPartron-Place':
        return LiturgicalRank.solemnity;
      case 'Feast':
      case 'Feast-Lord':
        return LiturgicalRank.feast;
      case 'Mem':
      case 'Mem-Mary':
        return LiturgicalRank.memorial;
      case 'OpMem':
        return LiturgicalRank.optionalMemorial;
      default:
        return LiturgicalRank.optionalMemorial;
    }
  }

  LiturgicalColor _mapColor(String name) {
    return name.toLowerCase().contains('martyr')
        ? LiturgicalColor.red
        : LiturgicalColor.white;
  }
}
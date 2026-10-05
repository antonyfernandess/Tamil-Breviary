import 'dart:developer' as developer;

import '../../domain/definitions/celebration_definition.dart';
import '../../domain/definitions/liturgical_calendar.dart';
import '../../domain/enums/liturgical_rank.dart';
import '../../domain/rules/fixed_date_rule.dart';
import '../../domain/value_objects/celebration_key.dart';
import '../database/feast_row.dart';
import 'feast_color_resolver.dart';

/// A [LiturgicalCalendar] backed by feast data loaded from SQLite.
///
/// Rows are pre-loaded into memory (see FeastRepository) so that per-year
/// filtering here stays synchronous, matching the rest of the engine.
class SqliteFixedFeastCalendar implements LiturgicalCalendar {
  SqliteFixedFeastCalendar({required List<FeastRow> rows})
    : _rows = List<FeastRow>.unmodifiable(rows);

  final List<FeastRow> _rows;

  @override
  String get key => 'sqlite_fixed_feasts';

  @override
  Iterable<CelebrationDefinition> celebrationsForYear(int year) {
    // De-duplicate per (month, day, name): when the *same* celebration is
    // stored more than once for a day (e.g. St Mary Magdalene as Mem before
    // 2016 and as Feast from 2016) only the most recently added row that
    // applies in [year] survives.
    //
    // Different celebrations on the same day (e.g. several optional
    // memorials on 3 February) are all kept: the engine's precedence rules
    // decide which of them is shown.
    final byIdentity = <String, FeastRow>{};

    for (final row in _rows) {
      if (!row.appliesInYear(year)) continue;
      if (!_hasValidDate(row)) {
        developer.log(
          'Skipping feast "${row.name}" with invalid date '
          '${row.month}/${row.day}.',
          name: 'liturgical_engine',
        );
        continue;
      }

      final identity = '${row.month}-${row.day}-${_slugify(row.name)}';
      final existing = byIdentity[identity];

      if (existing == null || (row.addedYear ?? 0) > (existing.addedYear ?? 0)) {
        byIdentity[identity] = row;
      }
    }

    return byIdentity.values.map(_toDefinition).toList(growable: false);
  }

  bool _hasValidDate(FeastRow row) =>
      row.month >= 1 && row.month <= 12 && row.day >= 1 && row.day <= 31;

  CelebrationDefinition _toDefinition(FeastRow row) {
    return CelebrationDefinition(
      key: CelebrationKey(_slugify(row.name)),
      rule: FixedDateRule(month: row.month, day: row.day),
      rank: _mapRank(row),
      color: FeastColorResolver.resolve(row.name),
      displayName: _displayName(row.name),
    );
  }

  /// The DB prefixes India-proper rows with "IN "; that is not part of the
  /// celebration's name.
  String _displayName(String name) {
    return name.trim().replaceFirst(RegExp(r'^IN\s+'), '').replaceAll(RegExp(r'\s+'), ' ');
  }

  String _slugify(String name) {
    return name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), '_');
  }

  /// Maps the DB `feast_type` onto a [LiturgicalRank].
  ///
  /// Matching is prefix based and case-insensitive so spelling variants of a
  /// type (the DB contains `Solemnity-PrincipalPartron-Place`) cannot
  /// silently downgrade a solemnity. Genuinely unknown types are logged.
  LiturgicalRank _mapRank(FeastRow row) {
    final type = row.feastType.trim().toLowerCase();

    if (type.startsWith('solemnity')) return LiturgicalRank.solemnity;
    if (type == 'feast-lord' || type.startsWith('feast-of-the-lord')) {
      return LiturgicalRank.feastOfTheLord;
    }
    if (type.startsWith('feast')) return LiturgicalRank.feast;
    if (type.startsWith('opmem')) return LiturgicalRank.optionalMemorial;
    if (type.startsWith('mem')) return LiturgicalRank.memorial;

    developer.log(
      'Unknown feast_type "${row.feastType}" for "${row.name}"; '
      'treating it as an optional memorial.',
      name: 'liturgical_engine',
      level: 900,
    );
    return LiturgicalRank.optionalMemorial;
  }
}

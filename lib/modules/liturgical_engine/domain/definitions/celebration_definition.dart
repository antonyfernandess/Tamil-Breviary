import '../enums/liturgical_color.dart';
import '../enums/liturgical_rank.dart';
import '../rules/calendar_rule.dart';
import '../value_objects/celebration_key.dart';

/// Defines a liturgical celebration: its key, calendar rule, rank and color.
class CelebrationDefinition {
  const CelebrationDefinition({
    required this.key,
    required this.rule,
    required this.rank,
    required this.color,
    this.displayName,
  });

  final CelebrationKey key;
  final CalendarRule rule;
  final LiturgicalRank rank;
  final LiturgicalColor color;

  /// Human-readable name from the data source (e.g. the `feast_code` column),
  /// used when no localized name exists for [key]. Slugs are lossy (accents
  /// and punctuation are stripped), so this is the only faithful fallback.
  final String? displayName;
}

import '../domain/definitions/celebration_definition.dart';

/// What a single date resolves to before becoming a LiturgicalDay:
/// either one obligatory celebration (a solemnity, feast, or
/// obligatory memorial — which fully owns the day), OR zero-to-many
/// optional memorials that coexist alongside the season's own day.
/// Never both — an obligatory celebration always suppresses optional
/// ones on the same date.
class ResolvedCelebrations {
  final DateTime date;
  final CelebrationDefinition? primary;
  final List<CelebrationDefinition> additionalObligatory;
  final List<CelebrationDefinition> optionalMemorials;

  const ResolvedCelebrations({
    required this.date,
    required this.primary,
    this.additionalObligatory = const [],
    this.optionalMemorials = const [],
  });
}

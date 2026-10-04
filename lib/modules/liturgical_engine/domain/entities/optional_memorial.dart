import '../enums/liturgical_color.dart';
import '../value_objects/celebration_key.dart';

class OptionalMemorial {
  const OptionalMemorial({
    required this.key,
    required this.color,
    this.displayName,
  });

  final CelebrationKey key;
  final LiturgicalColor color;

  /// See [CelebrationDefinition.displayName].
  final String? displayName;
}

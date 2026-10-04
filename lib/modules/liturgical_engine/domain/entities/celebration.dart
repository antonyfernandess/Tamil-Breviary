import '../definitions/celebration_definition.dart';

class Celebration{
  final CelebrationDefinition definition;

  final DateTime date;

  const Celebration({
    required this.definition,
    required this.date,
  });
}

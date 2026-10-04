import '../../domain/definitions/celebration_definition.dart';
import '../../domain/enums/liturgical_rank.dart';


class LiturgicalPrecedence {
  const LiturgicalPrecedence();

  int compare(
    CelebrationDefinition first,
    CelebrationDefinition second,
  ) {
    final firstRank = _precedenceValue(first.rank);
    final secondRank = _precedenceValue(second.rank);
    return firstRank.compareTo(secondRank);
  }

  CelebrationDefinition higher(
    CelebrationDefinition first,
    CelebrationDefinition second,
  ) {
    return compare(first, second) <= 0 ? first : second;
  }

  int _precedenceValue(LiturgicalRank rank) {
    return switch (rank) {
      LiturgicalRank.privilegedDay => 0,
      LiturgicalRank.solemnity => 1,
      LiturgicalRank.feastOfTheLord => 2,
      LiturgicalRank.feast => 3,
      LiturgicalRank.memorial => 4,
      LiturgicalRank.optionalMemorial => 5,
      LiturgicalRank.commemoration => 6,
      LiturgicalRank.feria => 7,
    };
  }
}

class CelebrationKey {
  final String value;

  const CelebrationKey(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CelebrationKey && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
          
}

/// Regional options that change how movable celebrations are placed.
class CalendarSettings {
  const CalendarSettings({
    this.transferEpiphany = false,
    this.transferAscension = false,
    this.transferCorpusChristi = false,
  });

  final bool transferEpiphany;
  final bool transferAscension;
  final bool transferCorpusChristi;

  static const roman = CalendarSettings();

  static const india = CalendarSettings(
    transferEpiphany: true,
    transferAscension: true,
    transferCorpusChristi: true,
  );

  // Value equality is required because settings are part of the key used to
  // memoize LiturgicalAnchors.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarSettings &&
          other.transferEpiphany == transferEpiphany &&
          other.transferAscension == transferAscension &&
          other.transferCorpusChristi == transferCorpusChristi;

  @override
  int get hashCode =>
      Object.hash(transferEpiphany, transferAscension, transferCorpusChristi);
}

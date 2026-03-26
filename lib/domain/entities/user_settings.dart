class UserSettings {
  final int dailyTargetMl;
  final bool remindersEnabled;
  final int wakeTimeMinutes;
  final int sleepTimeMinutes;
  final int intervalMinutes;
  final bool alarmEnabled;
  final bool isOnboarded;

  const UserSettings({
    this.dailyTargetMl = 2500,
    this.remindersEnabled = false,
    this.wakeTimeMinutes = 480, // 8:00 AM
    this.sleepTimeMinutes = 1380, // 11:00 PM
    this.intervalMinutes = 60,
    this.alarmEnabled = false,
    this.isOnboarded = false,
  });

  UserSettings copyWith({
    int? dailyTargetMl,
    bool? remindersEnabled,
    int? wakeTimeMinutes,
    int? sleepTimeMinutes,
    int? intervalMinutes,
    bool? alarmEnabled,
    bool? isOnboarded,
  }) {
    return UserSettings(
      dailyTargetMl: dailyTargetMl ?? this.dailyTargetMl,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      wakeTimeMinutes: wakeTimeMinutes ?? this.wakeTimeMinutes,
      sleepTimeMinutes: sleepTimeMinutes ?? this.sleepTimeMinutes,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      alarmEnabled: alarmEnabled ?? this.alarmEnabled,
      isOnboarded: isOnboarded ?? this.isOnboarded,
    );
  }
}

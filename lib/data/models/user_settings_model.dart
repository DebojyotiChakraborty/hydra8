import 'package:hive/hive.dart';
import '../../domain/entities/user_settings.dart';

part 'user_settings_model.g.dart';

@HiveType(typeId: 0)
class UserSettingsModel extends HiveObject {
  @HiveField(0)
  int dailyTargetMl;

  @HiveField(1)
  bool remindersEnabled;

  @HiveField(2)
  int wakeTimeMinutes;

  @HiveField(3)
  int sleepTimeMinutes;

  @HiveField(4)
  int intervalMinutes;

  @HiveField(5)
  bool alarmEnabled;

  @HiveField(6)
  bool isOnboarded;

  UserSettingsModel({
    required this.dailyTargetMl,
    required this.remindersEnabled,
    required this.wakeTimeMinutes,
    required this.sleepTimeMinutes,
    required this.intervalMinutes,
    required this.alarmEnabled,
    required this.isOnboarded,
  });

  factory UserSettingsModel.fromDomain(UserSettings settings) {
    return UserSettingsModel(
      dailyTargetMl: settings.dailyTargetMl,
      remindersEnabled: settings.remindersEnabled,
      wakeTimeMinutes: settings.wakeTimeMinutes,
      sleepTimeMinutes: settings.sleepTimeMinutes,
      intervalMinutes: settings.intervalMinutes,
      alarmEnabled: settings.alarmEnabled,
      isOnboarded: settings.isOnboarded,
    );
  }

  UserSettings toDomain() {
    return UserSettings(
      dailyTargetMl: dailyTargetMl,
      remindersEnabled: remindersEnabled,
      wakeTimeMinutes: wakeTimeMinutes,
      sleepTimeMinutes: sleepTimeMinutes,
      intervalMinutes: intervalMinutes,
      alarmEnabled: alarmEnabled,
      isOnboarded: isOnboarded,
    );
  }
}

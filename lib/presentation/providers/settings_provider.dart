import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local_data_source.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../data/repositories/water_intake_repository_impl.dart';
import '../../domain/entities/user_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/repositories/water_intake_repository.dart';

final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  throw UnimplementedError('Must be overridden in ProviderScope');
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(ref.read(localDataSourceProvider));
});

final waterIntakeRepositoryProvider = Provider<WaterIntakeRepository>((ref) {
  return WaterIntakeRepositoryImpl(ref.read(localDataSourceProvider));
});

final settingsProvider =
    AsyncNotifierProvider<SettingsNotifier, UserSettings>(
  SettingsNotifier.new,
);

class SettingsNotifier extends AsyncNotifier<UserSettings> {
  @override
  Future<UserSettings> build() async {
    final repo = ref.read(settingsRepositoryProvider);
    return repo.getSettings();
  }

  Future<void> _save(UserSettings settings) async {
    final repo = ref.read(settingsRepositoryProvider);
    await repo.saveSettings(settings);
    state = AsyncData(settings);
  }

  Future<void> updateTarget(int targetMl) async {
    final current = state.valueOrNull ?? const UserSettings();
    await _save(current.copyWith(dailyTargetMl: targetMl));
  }

  Future<void> toggleReminders(bool enabled) async {
    final current = state.valueOrNull ?? const UserSettings();
    await _save(current.copyWith(remindersEnabled: enabled));
  }

  Future<void> updateWakeTime(int minutes) async {
    final current = state.valueOrNull ?? const UserSettings();
    await _save(current.copyWith(wakeTimeMinutes: minutes));
  }

  Future<void> updateSleepTime(int minutes) async {
    final current = state.valueOrNull ?? const UserSettings();
    await _save(current.copyWith(sleepTimeMinutes: minutes));
  }

  Future<void> updateInterval(int minutes) async {
    final current = state.valueOrNull ?? const UserSettings();
    await _save(current.copyWith(intervalMinutes: minutes));
  }

  Future<void> toggleAlarm(bool enabled) async {
    final current = state.valueOrNull ?? const UserSettings();
    await _save(current.copyWith(alarmEnabled: enabled));
  }

  Future<void> completeOnboarding() async {
    final current = state.valueOrNull ?? const UserSettings();
    await _save(current.copyWith(isOnboarded: true));
  }
}

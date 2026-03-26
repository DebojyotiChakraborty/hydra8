import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/daily_progress.dart';
import '../../domain/entities/water_intake_log.dart';
import 'settings_provider.dart';

const _uuid = Uuid();

const bottleAssets = [
  'assets/images/bottle-asset-1.png',
  'assets/images/bottle-asset-2.png',
  'assets/images/bottle-asset-3.png',
  'assets/images/bottle-asset-4.png',
  'assets/images/bottle-asset-5.png',
];

final selectedBottleIndexProvider = StateProvider<int>((ref) => 0);

final intakeSliderProvider = StateProvider<int>((ref) => 250);

final dailyProgressProvider =
    AsyncNotifierProvider<DailyProgressNotifier, DailyProgress>(
  DailyProgressNotifier.new,
);

class DailyProgressNotifier extends AsyncNotifier<DailyProgress> {
  @override
  Future<DailyProgress> build() async {
    final settings = await ref.watch(settingsProvider.future);
    final repo = ref.read(waterIntakeRepositoryProvider);
    final logs = await repo.getLogsForDate(DateTime.now());
    final total = logs.fold<int>(0, (sum, log) => sum + log.amountMl);
    return DailyProgress(
      date: DateTime.now(),
      totalConsumedMl: total,
      targetMl: settings.dailyTargetMl,
    );
  }

  Future<void> logIntake(int amountMl) async {
    final repo = ref.read(waterIntakeRepositoryProvider);
    final log = WaterIntakeLog(
      id: _uuid.v4(),
      amountMl: amountMl,
      timestamp: DateTime.now(),
    );
    await repo.addLog(log);
    ref.invalidateSelf();
  }
}

import '../entities/water_intake_log.dart';

abstract class WaterIntakeRepository {
  Future<List<WaterIntakeLog>> getLogsForDate(DateTime date);
  Future<void> addLog(WaterIntakeLog log);
  Future<void> deleteLog(String id);
}

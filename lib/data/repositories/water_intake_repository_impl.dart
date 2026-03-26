import '../../domain/entities/water_intake_log.dart';
import '../../domain/repositories/water_intake_repository.dart';
import '../datasources/local_data_source.dart';
import '../models/water_intake_log_model.dart';

class WaterIntakeRepositoryImpl implements WaterIntakeRepository {
  final LocalDataSource _localDataSource;

  WaterIntakeRepositoryImpl(this._localDataSource);

  @override
  Future<List<WaterIntakeLog>> getLogsForDate(DateTime date) async {
    final allLogs = _localDataSource.getAllLogs();
    return allLogs
        .where((log) =>
            log.timestamp.year == date.year &&
            log.timestamp.month == date.month &&
            log.timestamp.day == date.day)
        .map((log) => log.toDomain())
        .toList();
  }

  @override
  Future<void> addLog(WaterIntakeLog log) async {
    final model = WaterIntakeLogModel.fromDomain(log);
    await _localDataSource.addLog(model);
  }

  @override
  Future<void> deleteLog(String id) async {
    await _localDataSource.deleteLog(id);
  }
}

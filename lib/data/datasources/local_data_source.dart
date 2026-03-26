import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_settings_model.dart';
import '../models/water_intake_log_model.dart';

class LocalDataSource {
  static const String _settingsBoxName = 'settings';
  static const String _logsBoxName = 'water_logs';
  static const String _settingsKey = 'user_settings';

  late Box<UserSettingsModel> _settingsBox;
  late Box<WaterIntakeLogModel> _logsBox;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserSettingsModelAdapter());
    Hive.registerAdapter(WaterIntakeLogModelAdapter());
    _settingsBox = await Hive.openBox<UserSettingsModel>(_settingsBoxName);
    _logsBox = await Hive.openBox<WaterIntakeLogModel>(_logsBoxName);
  }

  UserSettingsModel? getSettings() {
    return _settingsBox.get(_settingsKey);
  }

  Future<void> saveSettings(UserSettingsModel settings) async {
    await _settingsBox.put(_settingsKey, settings);
  }

  List<WaterIntakeLogModel> getAllLogs() {
    return _logsBox.values.toList();
  }

  Future<void> addLog(WaterIntakeLogModel log) async {
    await _logsBox.put(log.id, log);
  }

  Future<void> deleteLog(String id) async {
    await _logsBox.delete(id);
  }
}

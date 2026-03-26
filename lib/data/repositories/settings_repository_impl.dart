import '../../domain/entities/user_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/local_data_source.dart';
import '../models/user_settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final LocalDataSource _localDataSource;

  SettingsRepositoryImpl(this._localDataSource);

  @override
  Future<UserSettings> getSettings() async {
    final model = _localDataSource.getSettings();
    return model?.toDomain() ?? const UserSettings();
  }

  @override
  Future<void> saveSettings(UserSettings settings) async {
    final model = UserSettingsModel.fromDomain(settings);
    await _localDataSource.saveSettings(model);
  }
}

import 'package:hive/hive.dart';
import '../../domain/entities/water_intake_log.dart';

part 'water_intake_log_model.g.dart';

@HiveType(typeId: 1)
class WaterIntakeLogModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  int amountMl;

  @HiveField(2)
  DateTime timestamp;

  WaterIntakeLogModel({
    required this.id,
    required this.amountMl,
    required this.timestamp,
  });

  factory WaterIntakeLogModel.fromDomain(WaterIntakeLog log) {
    return WaterIntakeLogModel(
      id: log.id,
      amountMl: log.amountMl,
      timestamp: log.timestamp,
    );
  }

  WaterIntakeLog toDomain() {
    return WaterIntakeLog(
      id: id,
      amountMl: amountMl,
      timestamp: timestamp,
    );
  }
}

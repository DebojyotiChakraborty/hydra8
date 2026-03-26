import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatMl(int ml) {
  final formatter = NumberFormat('#,###');
  return formatter.format(ml);
}

String formatLiters(int ml) {
  final liters = ml / 1000.0;
  return liters.toStringAsFixed(2);
}

String formatPercentage(int consumed, int target) {
  if (target == 0) return '0';
  final percent = ((consumed / target) * 100).round();
  return '$percent';
}

String formatTimeOfDay(TimeOfDay time) {
  final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.period == DayPeriod.am ? 'AM' : 'PM';
  return '$hour:$minute $period';
}

String formatIntervalMinutes(int minutes) {
  if (minutes >= 60) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (mins == 0) return '$hours hour${hours > 1 ? 's' : ''}';
    return '$hours h $mins min';
  }
  return '$minutes min';
}

TimeOfDay minutesToTimeOfDay(int minutes) {
  return TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
}

int timeOfDayToMinutes(TimeOfDay time) {
  return time.hour * 60 + time.minute;
}

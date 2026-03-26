class DailyProgress {
  final DateTime date;
  final int totalConsumedMl;
  final int targetMl;

  const DailyProgress({
    required this.date,
    this.totalConsumedMl = 0,
    required this.targetMl,
  });

  double get percentage =>
      targetMl > 0 ? (totalConsumedMl / targetMl).clamp(0.0, 1.0) : 0.0;
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../providers/settings_provider.dart';

class ReminderSection extends ConsumerWidget {
  const ReminderSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider).valueOrNull;
    if (settings == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        children: [
          // Reminders toggle row
          Row(
            children: [
              Icon(
                MingCuteIcons.mgc_notification_line,
                color: AppColors.white,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reminders',
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                    Text(
                      'Get reminded to take regular sips',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: AppColors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: settings.remindersEnabled,
                onChanged: (value) {
                  ref.read(settingsProvider.notifier).toggleReminders(value);
                },
              ),
            ],
          ),

          // Expanded reminder options
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: settings.remindersEnabled
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                _buildDottedDivider(),
                // Wake time
                _TimeRow(
                  icon: MingCuteIcons.mgc_run_line,
                  value: formatTimeOfDay(
                      minutesToTimeOfDay(settings.wakeTimeMinutes)),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime:
                          minutesToTimeOfDay(settings.wakeTimeMinutes),
                    );
                    if (time != null) {
                      ref
                          .read(settingsProvider.notifier)
                          .updateWakeTime(timeOfDayToMinutes(time));
                    }
                  },
                  trailing: _TimeRow(
                    icon: MingCuteIcons.mgc_bed_line,
                    value: formatTimeOfDay(
                        minutesToTimeOfDay(settings.sleepTimeMinutes)),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime:
                            minutesToTimeOfDay(settings.sleepTimeMinutes),
                      );
                      if (time != null) {
                        ref
                            .read(settingsProvider.notifier)
                            .updateSleepTime(timeOfDayToMinutes(time));
                      }
                    },
                  ),
                ),
                _buildDottedDivider(),
                // Interval
                Row(
                  children: [
                    Icon(
                      MingCuteIcons.mgc_time_line,
                      color: AppColors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Interval',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                    ),
                    const Spacer(),
                    _IntervalSelector(
                      currentMinutes: settings.intervalMinutes,
                      onChanged: (minutes) {
                        ref
                            .read(settingsProvider.notifier)
                            .updateInterval(minutes);
                      },
                    ),
                  ],
                ),
                _buildDottedDivider(),
                // Alarm toggle
                Row(
                  children: [
                    Icon(
                      MingCuteIcons.mgc_alarm_2_line,
                      color: AppColors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Alarm',
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.white,
                            ),
                          ),
                          Text(
                            'Higher Priority',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              color: AppColors.white.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: settings.alarmEnabled,
                      onChanged: (value) {
                        ref
                            .read(settingsProvider.notifier)
                            .toggleAlarm(value);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDottedDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final dotCount = (constraints.maxWidth / 6).floor();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(dotCount, (_) {
              return Container(
                width: 3,
                height: 1,
                color: AppColors.white.withValues(alpha: 0.3),
              );
            }),
          );
        },
      ),
    );
  }
}

class _TimeRow extends StatelessWidget {
  final IconData icon;
  final String value;
  final VoidCallback onTap;
  final Widget? trailing;

  const _TimeRow({
    required this.icon,
    required this.value,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final content = GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            MingCuteIcons.mgc_transfer_line,
            color: AppColors.white.withValues(alpha: 0.5),
            size: 14,
          ),
        ],
      ),
    );

    if (trailing != null) {
      return Row(
        children: [
          content,
          const Spacer(),
          trailing!,
        ],
      );
    }

    return content;
  }
}

class _IntervalSelector extends StatelessWidget {
  final int currentMinutes;
  final ValueChanged<int> onChanged;

  const _IntervalSelector({
    required this.currentMinutes,
    required this.onChanged,
  });

  static const _intervals = [15, 30, 45, 60, 90, 120, 180, 240];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final currentIndex = _intervals.indexOf(currentMinutes);
        final nextIndex = (currentIndex + 1) % _intervals.length;
        onChanged(_intervals[nextIndex]);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            formatIntervalMinutes(currentMinutes),
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            MingCuteIcons.mgc_transfer_line,
            color: AppColors.white.withValues(alpha: 0.5),
            size: 14,
          ),
        ],
      ),
    );
  }
}

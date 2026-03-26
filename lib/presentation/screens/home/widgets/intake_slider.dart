import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../providers/water_intake_provider.dart';

class IntakeSlider extends ConsumerWidget {
  const IntakeSlider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sliderValue = ref.watch(intakeSliderProvider);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundDark,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Amount display
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$sliderValue',
                style: GoogleFonts.manrope(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                  height: 1.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  'ml',
                  style: GoogleFonts.manrope(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: AppColors.white.withValues(alpha: 0.7),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  MingCuteIcons.mgc_glass_cup_fill,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Custom bar slider
          _BarSlider(
            value: sliderValue,
            onChanged: (value) {
              ref.read(intakeSliderProvider.notifier).state = value;
            },
          ),
          const SizedBox(height: 8),
          // Scale labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [50, 300, 550, 750, 1000].map((label) {
              return Text(
                '$label',
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: AppColors.white.withValues(alpha: 0.4),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          // Log Intake button
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                ref
                    .read(dailyProgressProvider.notifier)
                    .logIntake(sliderValue);
              },
              child: const Text('Log Intake'),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarSlider extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _BarSlider({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalBars = 38;
        final barWidth = constraints.maxWidth / (totalBars * 1.6);

        return GestureDetector(
          onHorizontalDragUpdate: (details) {
            final fraction = (details.localPosition.dx / constraints.maxWidth)
                .clamp(0.0, 1.0);
            final newValue = (50 + (fraction * 950)).round();
            // Snap to nearest 50
            final snapped = (newValue / 50).round() * 50;
            onChanged(snapped.clamp(50, 1000));
          },
          onTapDown: (details) {
            final fraction = (details.localPosition.dx / constraints.maxWidth)
                .clamp(0.0, 1.0);
            final newValue = (50 + (fraction * 950)).round();
            final snapped = (newValue / 50).round() * 50;
            onChanged(snapped.clamp(50, 1000));
          },
          child: SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(totalBars, (index) {
                final barFraction = index / (totalBars - 1);
                final currentFraction = (value - 50) / 950;
                final isActive = barFraction <= currentFraction;

                // Varying bar heights for visual effect
                final heightFraction = 0.4 + (barFraction * 0.6);

                return Container(
                  width: barWidth,
                  height: 40 * heightFraction,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.white
                        : AppColors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}

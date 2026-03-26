import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/daily_progress.dart';
import '../../providers/water_intake_provider.dart';
import '../intake_target/intake_target_screen.dart';
import 'widgets/water_bottle.dart';
import 'widgets/progress_info.dart';
import 'widgets/intake_slider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(dailyProgressProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  const Spacer(),
                  Text(
                    'Hydra8',
                    style: GoogleFonts.manrope(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  const IntakeTargetScreen(isEditing: true),
                            ),
                          );
                        },
                        icon: Icon(
                          MingCuteIcons.mgc_settings_3_line,
                          color: AppColors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Main content
            Expanded(
              child: progressAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.white),
                ),
                error: (e, _) => Center(
                  child: Text(
                    'Something went wrong',
                    style: GoogleFonts.manrope(color: AppColors.white),
                  ),
                ),
                data: (progress) => _buildContent(progress),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(DailyProgress progress) {
    // Fill level: starts full (1.0), decreases as user drinks
    final fillLevel = 1.0 - progress.percentage;

    return Column(
      children: [
        // Bottle + Progress info
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                // Water bottle
                Expanded(
                  flex: 4,
                  child: Center(
                    child: WaterBottle(fillLevel: fillLevel),
                  ),
                ),
                const SizedBox(width: 8),
                // Progress info
                Expanded(
                  flex: 5,
                  child: ProgressInfo(progress: progress),
                ),
              ],
            ),
          ),
        ),
        // Intake slider
        const IntakeSlider(),
      ],
    );
  }
}

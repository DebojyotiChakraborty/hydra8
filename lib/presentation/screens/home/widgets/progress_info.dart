import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../domain/entities/daily_progress.dart';

class ProgressInfo extends StatelessWidget {
  final DailyProgress progress;

  const ProgressInfo({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Percentage
        Text(
          '${formatPercentage(progress.totalConsumedMl, progress.targetMl)}%',
          style: GoogleFonts.manrope(
            fontSize: 56,
            fontWeight: FontWeight.w800,
            color: AppColors.white,
            height: 1.0,
          ),
        ),
        Text(
          'Completed',
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.white.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 24),
        // Goal
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: formatLiters(progress.targetMl),
                style: GoogleFonts.manrope(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                ),
              ),
              TextSpan(
                text: 'L',
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
        Text(
          'Goal',
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.white.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 24),
        // Consumed
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${progress.totalConsumedMl}',
                style: GoogleFonts.manrope(
                  fontSize: 56,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                  height: 1.0,
                ),
              ),
              TextSpan(
                text: 'ml',
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
        Text(
          'Consumed so far',
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

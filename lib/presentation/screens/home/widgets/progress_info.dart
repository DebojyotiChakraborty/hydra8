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
            fontSize: 48,
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
                  fontSize: 48,
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
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerRight,
          child: Text(
            '${progress.totalConsumedMl}',
            style: GoogleFonts.manrope(
              fontSize: 96,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
              height: 1.0,
            ),
            maxLines: 1,
          ),
        ),
        Text(
          'ml',
          style: GoogleFonts.manrope(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
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

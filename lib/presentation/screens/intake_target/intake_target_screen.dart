import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/numeric_text_transition.dart';
import '../../widgets/bouncy_button.dart';
import '../home/home_screen.dart';
import 'widgets/target_counter.dart';
import 'widgets/reminder_section.dart';

class IntakeTargetScreen extends ConsumerWidget {
  final bool isEditing;

  const IntakeTargetScreen({super.key, this.isEditing = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider).valueOrNull;
    final targetMl = settings?.dailyTargetMl ?? 2500;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.onboardingGradient,
            stops: [0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Scrollable content
              Positioned.fill(
                bottom: 100,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        // App title - centered
                        Center(
                          child: Text(
                            'Hydra8',
                            style: GoogleFonts.manrope(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Water glass icon - centered, gradient, no background
                        Center(
                          child: ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.iconGradientStart,
                                AppColors.iconGradientEnd,
                              ],
                            ).createShader(bounds),
                            child: const Icon(
                              MingCuteIcons.mgc_glass_cup_fill,
                              size: 140,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 90),
                        // Heading - left aligned
                        Text(
                          'Daily Water\nIntake Target',
                          style: GoogleFonts.manrope(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: AppColors.white,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Target display with counter - left aligned
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            NumericTextTransition(
                              value: targetMl,
                              style: GoogleFonts.manrope(
                                fontSize: 48,
                                fontWeight: FontWeight.w800,
                                color: AppColors.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                'ml',
                                style: GoogleFonts.manrope(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                            const Spacer(),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 6),
                              child: TargetCounter(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Reminder section
                        const ReminderSection(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
              // Done button - fixed at bottom
              Positioned(
                left: 0,
                right: 0,
                bottom: 24,
                child: Center(
                  child: SizedBox(
                    width: 200,
                    child: BouncyButton(
                      label: 'Done',
                      onPressed: () async {
                        if (!isEditing) {
                          await ref
                              .read(settingsProvider.notifier)
                              .completeOnboarding();
                          if (context.mounted) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const HomeScreen(),
                              ),
                            );
                          }
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

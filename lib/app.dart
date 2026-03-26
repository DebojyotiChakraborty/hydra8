import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/constants/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'presentation/providers/settings_provider.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/intake_target/intake_target_screen.dart';

class Hydra8App extends ConsumerWidget {
  const Hydra8App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);

    return MaterialApp(
      title: 'Hydra8',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: settingsAsync.when(
        loading: () => const _SplashScreen(),
        error: (_, _) => const IntakeTargetScreen(),
        data: (settings) {
          if (settings.isOnboarded) {
            return const HomeScreen();
          }
          return const IntakeTargetScreen();
        },
      ),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: Center(
        child: Text(
          'Hydra8',
          style: GoogleFonts.manrope(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}

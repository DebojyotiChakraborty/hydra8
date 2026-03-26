import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../providers/settings_provider.dart';

class TargetCounter extends ConsumerWidget {
  const TargetCounter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider).valueOrNull;
    final currentTarget = settings?.dailyTargetMl ?? 2500;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CounterButton(
            icon: MingCuteIcons.mgc_minimize_line,
            onPressed: currentTarget > 1000
                ? () {
                    HapticFeedback.selectionClick();
                    ref
                        .read(settingsProvider.notifier)
                        .updateTarget(currentTarget - 100);
                  }
                : null,
          ),
          Container(
            width: 1,
            height: 20,
            color: AppColors.white.withValues(alpha: 0.3),
          ),
          _CounterButton(
            icon: MingCuteIcons.mgc_add_line,
            onPressed: currentTarget < 10000
                ? () {
                    HapticFeedback.selectionClick();
                    ref
                        .read(settingsProvider.notifier)
                        .updateTarget(currentTarget + 100);
                  }
                : null,
          ),
        ],
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _CounterButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: AppColors.white, size: 18),
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      padding: EdgeInsets.zero,
    );
  }
}

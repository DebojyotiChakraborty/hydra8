import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CounterButton(
            icon: MingCuteIcons.mgc_minimize_line,
            onPressed: currentTarget > 1000
                ? () => ref
                    .read(settingsProvider.notifier)
                    .updateTarget(currentTarget - 250)
                : null,
          ),
          Container(
            width: 1,
            height: 24,
            color: AppColors.white.withValues(alpha: 0.3),
          ),
          _CounterButton(
            icon: MingCuteIcons.mgc_add_line,
            onPressed: currentTarget < 10000
                ? () => ref
                    .read(settingsProvider.notifier)
                    .updateTarget(currentTarget + 250)
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
      icon: Icon(icon, color: AppColors.white, size: 22),
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      padding: EdgeInsets.zero,
    );
  }
}

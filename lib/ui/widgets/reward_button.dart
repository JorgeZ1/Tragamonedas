import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/providers.dart';
import '../../theme/slot_theme.dart';

class RewardButton extends ConsumerStatefulWidget {
  const RewardButton({super.key});

  @override
  ConsumerState<RewardButton> createState() => _RewardButtonState();
}

class _RewardButtonState extends ConsumerState<RewardButton> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    // Refresh every second so the countdown stays accurate.
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = ref.read(gameControllerProvider.notifier);
    final canClaim = ctrl.canClaimReward;
    final secsLeft = ctrl.rewardCooldownSeconds;

    String label;
    if (canClaim) {
      label = '🎁  +100 MONEDAS';
    } else {
      final m = secsLeft ~/ 60;
      final s = secsLeft % 60;
      label = '⏳  ${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }

    return GestureDetector(
      onTap: canClaim ? ctrl.claimReward : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
          gradient: canClaim
              ? const LinearGradient(
                  colors: [Color(0xFFD97706), Color(0xFFF59E0B), Color(0xFFD97706)],
                )
              : null,
          color: canClaim ? null : const Color(0xFF374151),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: canClaim ? const Color(0xFFFEF08A) : const Color(0xFF4B5563),
            width: 1.5,
          ),
          boxShadow: canClaim
              ? [
                  BoxShadow(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.5),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: SlotTheme.gameFont(
                size: 10,
                color: canClaim
                    ? const Color(0xFF1F2937)
                    : const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

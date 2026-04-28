import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/providers.dart';
import '../../theme/slot_theme.dart';
import '../../util/glow_decoration.dart';

class HeaderPanel extends ConsumerWidget {
  const HeaderPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameControllerProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _Display(
          label: 'ÚLTIMO',
          value: s.lastWin,
          valueColor: SlotTheme.goldLight,
        ),
        _Display(
          label: 'GANANCIA',
          value: s.winnings,
          valueColor: SlotTheme.goldLight,
        ),
        _Display(
          label: 'CRÉDITO',
          value: s.credits,
          valueColor: SlotTheme.creditGreen,
        ),
      ],
    );
  }
}

class _Display extends StatelessWidget {
  final String label;
  final int value;
  final Color valueColor;

  const _Display({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FittedBox(
          child: Text(
            label,
            style: SlotTheme.bodyFont(size: 8, color: const Color(0xFF9CA3AF)),
          ),
        ),
        const SizedBox(height: 2),
        Container(
          decoration: GlowDecorations.display,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
          constraints: const BoxConstraints(minWidth: 60, minHeight: 28),
          alignment: Alignment.center,
          child: FittedBox(
            child: Text(
              '$value',
              style: SlotTheme.gameFont(size: 13, color: valueColor),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/symbols.dart';
import '../../state/providers.dart';
import '../../theme/slot_theme.dart';
import 'bet_button.dart';

class BetGrid extends ConsumerWidget {
  const BetGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameControllerProvider);
    final ctrl = ref.read(gameControllerProvider.notifier);

    final disabled = s.isBusy || s.winnings > 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'APUESTAS',
          style: SlotTheme.gameFont(size: 10, color: SlotTheme.goldLight),
        ),
        const SizedBox(height: 4),
        // 9 botones en 2 filas: 5 arriba, 4 abajo (centrados con un hueco final)
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: kBetTypes.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, i) {
            final type = kBetTypes[i];
            final count = s.selectedBets[type] ?? 0;
            final isBetting = s.isBusy && count > 0;
            return BetButton(
              type: type,
              count: count,
              disabled: disabled,
              isBetting: isBetting,
              onTap: () => ctrl.placeBet(type),
            );
          },
        ),
      ],
    );
  }
}

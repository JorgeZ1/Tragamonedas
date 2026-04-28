import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/game_state.dart';
import '../../state/providers.dart';
import '../../theme/slot_theme.dart';

class DoubleUpOverlay extends ConsumerWidget {
  const DoubleUpOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameControllerProvider);
    final ctrl = ref.read(gameControllerProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xE61F2937),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            child: Text('DOBLAR APUESTA',
                style: SlotTheme.gameFont(
                    size: 14, color: SlotTheme.goldLight)),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _Choice(
                  label: 'IZQ',
                  side: 'left',
                  state: s,
                  onTap: () => ctrl.chooseDouble('left'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Choice(
                  label: 'DER',
                  side: 'right',
                  state: s,
                  onTap: () => ctrl.chooseDouble('right'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _statusText(s),
            style: SlotTheme.bodyFont(size: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }

  String _statusText(GameState s) {
    switch (s.doubleResult) {
      case DoubleResult.won:
        return '¡GANASTE! x2';
      case DoubleResult.lost:
        return 'PERDISTE';
      case DoubleResult.none:
        return s.doubleHighlight == null ? 'ELIGE UNO' : '...';
    }
  }
}

class _Choice extends StatelessWidget {
  final String label;
  final String side;
  final GameState state;
  final VoidCallback onTap;

  const _Choice({
    required this.label,
    required this.side,
    required this.state,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isHighlighted = state.doubleHighlight == side;
    final isWinner = state.doubleWinner == side &&
        state.doubleResult == DoubleResult.won;
    final isLoserSide = state.doubleResult == DoubleResult.lost &&
        state.doubleWinner == side;

    Color bg = const Color(0xFF374151);
    Color border = const Color(0xFF6B7280);
    List<BoxShadow> shadows = const [];

    if (isWinner) {
      bg = const Color(0xFF4ADE80);
      border = const Color(0xFF86EFAC);
      shadows = const [
        BoxShadow(color: Color(0xCC22C55E), blurRadius: 16, spreadRadius: 4),
      ];
    } else if (isLoserSide) {
      bg = const Color(0xFFF87171);
      border = const Color(0xFFFCA5A5);
      shadows = const [
        BoxShadow(color: Color(0xCCDC2626), blurRadius: 16, spreadRadius: 4),
      ];
    } else if (isHighlighted) {
      bg = const Color(0xFFFDE047);
      border = const Color(0xFFFEF08A);
      shadows = const [
        BoxShadow(color: Color(0xCCFDE047), blurRadius: 16, spreadRadius: 4),
      ];
    }

    return GestureDetector(
      onTap: state.doubleResult == DoubleResult.none &&
              state.doubleHighlight == null
          ? onTap
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: border, width: 3),
          boxShadow: shadows,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: SlotTheme.gameFont(
                size: 20, color: const Color(0xFF1F2937)),
          ),
        ),
      ),
    );
  }
}

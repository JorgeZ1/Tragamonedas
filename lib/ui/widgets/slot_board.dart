import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/light_path.dart';
import '../../state/providers.dart';
import 'center_display.dart';
import 'slot_cell.dart';

/// 7×7 slot board with an orange frame. Cells are flush (gap=0) and
/// have slightly rounded corners — matches the Mexican-arcade reference.
class SlotBoard extends ConsumerWidget {
  const SlotBoard({super.key});

  static const int _cols = 7;
  static const int _rows = 7;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameControllerProvider);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE67E00),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFFBBF24), width: 3),
        boxShadow: const [
          BoxShadow(color: Color(0x99000000), blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: AspectRatio(
        aspectRatio: _cols / _rows,
        child: LayoutBuilder(
          builder: (context, c) {
            final cellW = c.maxWidth  / _cols;
            final cellH = c.maxHeight / _rows;

            double xOf(int col) => col * cellW;
            double yOf(int row) => row * cellH;

            final children = <Widget>[];

            // ── Centre panel (5 cols × 5 rows) ──────────────────────
            children.add(Positioned(
              left: xOf(1),
              top: yOf(1),
              width: cellW * 5,
              height: cellH * 5,
              child: const CenterDisplay(),
            ));

            // ── 24 perimeter slot cells ──────────────────────────────
            for (final entry in kSlotGridPos.entries) {
              final slotId = entry.key;
              final pos = entry.value;
              final symbol = s.symbolsOnBoard[slotId];

              SlotVisualState visual;
              if (s.winnerSlots.contains(slotId)) {
                visual = SlotVisualState.winner;
              } else if (s.eventWonSlots.contains(slotId)) {
                visual = SlotVisualState.eventWon;
              } else if (s.deactivatedSlots.contains(slotId)) {
                visual = SlotVisualState.deactivated;
              } else if (s.activeSlotId == slotId ||
                  s.activeSnakeSlots.contains(slotId)) {
                visual = SlotVisualState.active;
              } else {
                visual = SlotVisualState.idle;
              }

              children.add(Positioned(
                left: xOf(pos.col),
                top: yOf(pos.row),
                width: cellW,
                height: cellH,
                child: SlotCell(symbol: symbol, visual: visual),
              ));
            }

            return Stack(children: children);
          },
        ),
      ),
    );
  }
}

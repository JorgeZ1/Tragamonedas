import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/light_path.dart';
import '../../state/providers.dart';
import 'center_display.dart';
import 'slot_cell.dart';

class SlotBoard extends ConsumerWidget {
  const SlotBoard({super.key});

  static const int _cols = 7;
  static const int _rows = 5;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameControllerProvider);

    return AspectRatio(
      aspectRatio: 7 / 5,
      child: LayoutBuilder(
        builder: (context, c) {
          const gap = 4.0;
          final cellW = (c.maxWidth - gap * (_cols - 1)) / _cols;
          final cellH = (c.maxHeight - gap * (_rows - 1)) / _rows;

          double xOf(int col) => col * (cellW + gap);
          double yOf(int row) => row * (cellH + gap);

          final children = <Widget>[];

          // Center 5x3 message panel: cols 1..5 row 1..3
          children.add(Positioned(
            left: xOf(1),
            top: yOf(1),
            width: cellW * 5 + gap * 4,
            height: cellH * 3 + gap * 2,
            child: const CenterDisplay(),
          ));

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
    );
  }
}

import 'package:flutter/material.dart';

import '../theme/slot_theme.dart';

class GlowDecorations {
  static BoxDecoration slotIdle = BoxDecoration(
    color: SlotTheme.slotBg,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: SlotTheme.slotBorder, width: 2),
    boxShadow: const [
      BoxShadow(
        color: Color(0x66000000),
        offset: Offset(0, 3),
        blurRadius: 5,
        spreadRadius: -1,
      ),
    ],
  );

  static BoxDecoration slotActive = BoxDecoration(
    color: const Color(0xFFFDE047),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: SlotTheme.goldLight, width: 2),
    boxShadow: [
      BoxShadow(color: SlotTheme.goldLight.withValues(alpha: 0.9),
          blurRadius: 16, spreadRadius: 4),
      const BoxShadow(color: Color(0xFFFDE047), blurRadius: 22, spreadRadius: 6),
    ],
  );

  static BoxDecoration slotWinner({double pulse = 0}) {
    final t = pulse;
    return BoxDecoration(
      color: const Color(0xFF4ADE80),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: const Color(0xFF86EFAC), width: 2),
      boxShadow: [
        BoxShadow(
          color: SlotTheme.winnerGreen.withValues(alpha: 0.85),
          blurRadius: 20 + 12 * t,
          spreadRadius: 4 + 6 * t,
        ),
      ],
    );
  }

  static BoxDecoration slotEventWon = BoxDecoration(
    color: const Color(0xFF4ADE80),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: const Color(0xFF86EFAC), width: 2),
    boxShadow: const [
      BoxShadow(
          color: Color(0xCC22C55E), blurRadius: 14, spreadRadius: 3),
    ],
  );

  static BoxDecoration slotDeactivated = BoxDecoration(
    color: SlotTheme.slotBg.withValues(alpha: 0.4),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: SlotTheme.frameLight, width: 2),
  );

  static BoxDecoration display = BoxDecoration(
    color: const Color(0x66000000),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: const Color(0x80000000), width: 2),
    boxShadow: const [
      BoxShadow(
          color: Color(0x80000000),
          offset: Offset(0, 2),
          blurRadius: 4,
          spreadRadius: -1),
    ],
  );

  static BoxDecoration goldFrame = BoxDecoration(
    color: SlotTheme.frameDark,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: SlotTheme.goldLight, width: 3),
    boxShadow: const [
      BoxShadow(
          color: Color(0x99000000),
          offset: Offset(0, 12),
          blurRadius: 24,
          spreadRadius: 0),
    ],
  );
}

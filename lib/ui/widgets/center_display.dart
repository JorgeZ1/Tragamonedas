import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/providers.dart';
import 'double_up_overlay.dart';

/// The 5x3 centre panel of the board.
/// Shows: logo → message → doubling overlay.
class CenterDisplay extends ConsumerWidget {
  const CenterDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameControllerProvider);

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Background image ──────────────
          Image.asset(
            'assets/images/slot_center_bg.png',
            fit: BoxFit.fill,
          ),

          // ── Message overlay (Disabled per user request) ────────────
          // if (s.messageTitle != null && !s.doublingActive)
          //   _MessageOverlay(
          //     symbol: s.messageSymbol,
          //     title: s.messageTitle!,
          //     details: s.messageDetails,
          //   ),

          // ── Doubling overlay ───────────────────────────────────────
          if (s.doublingActive) const DoubleUpOverlay(),
        ],
      ),
    );
  }
}

class _MessageOverlay extends StatelessWidget {
  final String? symbol;
  final String title;
  final String? details;

  const _MessageOverlay({this.symbol, required this.title, this.details});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.55),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (symbol != null)
              Text(symbol!, style: const TextStyle(fontSize: 36)),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Color(0xFFFBBF24),
                shadows: [Shadow(color: Colors.black, offset: Offset(1, 1))],
              ),
            ),
            if (details != null && details!.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                details!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4ADE80),
                  shadows: [Shadow(color: Colors.black, offset: Offset(1, 1))],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

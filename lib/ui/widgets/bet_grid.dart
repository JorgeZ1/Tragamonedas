import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/symbols.dart';
import '../../state/providers.dart';
import 'led_display.dart';

/// Bottom bet panel — Mexican-arcade style:
///   Prize value (red) → symbol cell → 7-seg LED → big physical 3D button
class BetGrid extends ConsumerWidget {
  const BetGrid({super.key});

  // Order matches the reference image (left → right)
  static const List<String> _order = [
    'apple', 'watermelon', 'star', 'seven', 'bar',
    'bell', 'plum', 'orange', 'cherry',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s    = ref.watch(gameControllerProvider);
    final ctrl = ref.read(gameControllerProvider.notifier);
    final disabled = s.isBusy || s.winnings > 0;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE67E00),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFBBF24), width: 2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _order.map((type) {
          final sym   = symbolByType(type);
          final count = s.selectedBets[type] ?? 0;
          return Expanded(
            child: _BetColumn(
              symbol: sym,
              count: count,
              disabled: disabled,
              onTap: () => ctrl.placeBet(type),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _BetColumn extends StatelessWidget {
  final GameSymbol symbol;
  final int count;
  final bool disabled;
  final VoidCallback onTap;

  const _BetColumn({
    required this.symbol,
    required this.count,
    required this.disabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selected = count > 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Prize value (red number) ─────────────────────────────
          FittedBox(
            child: Text(
              '${symbol.prize}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Color(0xFFDC2626),
              ),
            ),
          ),
          const SizedBox(height: 2),

          // ── Symbol cell (white box, sharp corners) ──────────────
          AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFFEF9C3) : Colors.white,
              borderRadius: BorderRadius.circular(2),
              border: Border.all(
                color: selected
                    ? const Color(0xFFFBBF24)
                    : const Color(0xFF9CA3AF),
                width: selected ? 2 : 1,
              ),
            ),
            padding: const EdgeInsets.all(2),
            child: AspectRatio(
              aspectRatio: 1,
              child: _SymbolIcon(symbol: symbol),
            ),
          ),
          const SizedBox(height: 3),

          // ── 7-segment LED counter ────────────────────────────────
          LedDisplay(value: count, height: 18),
          const SizedBox(height: 4),

          // ── Physical 3D arcade button ────────────────────────────
          _ArcadeBetButton(
            enabled: !disabled,
            pressed: selected,
            onTap: disabled ? null : onTap,
          ),
        ],
      ),
    );
  }
}

class _SymbolIcon extends StatelessWidget {
  final GameSymbol symbol;
  const _SymbolIcon({required this.symbol});

  @override
  Widget build(BuildContext context) {
    if (symbol.type == 'bar' || symbol.type == 'bar1000') {
      return FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('BAR', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Color(0xFFDC2626))),
            Text('BAR', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Color(0xFFDC2626))),
            Text('BAR', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Color(0xFFDC2626))),
          ],
        ),
      );
    }
    if (symbol.type == 'seven') {
      return FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          '7',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Color(0xFFDC2626),
          ),
        ),
      );
    }
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(symbol.display, style: const TextStyle(fontSize: 22)),
    );
  }
}

/// Physical button styled like the round white plungers on Mexican
/// arcade slots. Has a clear "depressed" state when held / selected.
class _ArcadeBetButton extends StatefulWidget {
  final bool enabled;
  final bool pressed;
  final VoidCallback? onTap;

  const _ArcadeBetButton({
    required this.enabled,
    required this.pressed,
    required this.onTap,
  });

  @override
  State<_ArcadeBetButton> createState() => _ArcadeBetButtonState();
}

class _ArcadeBetButtonState extends State<_ArcadeBetButton> {
  bool _hold = false;

  @override
  Widget build(BuildContext context) {
    final down = (_hold || widget.pressed) && widget.enabled;
    final yOffset = down ? 4.0 : 0.0;

    return GestureDetector(
      onTapDown: (_) {
        if (widget.enabled) setState(() => _hold = true);
      },
      onTapUp: (_) {
        setState(() => _hold = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _hold = false),
      child: SizedBox(
        height: 28,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Base / socket (the dark ring around the button)
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2937),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            // Plunger
            AnimatedContainer(
              duration: const Duration(milliseconds: 60),
              transform: Matrix4.translationValues(0, yOffset, 0),
              height: 22,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: widget.enabled
                      ? const [Color(0xFFFFFFFF), Color(0xFFD1D5DB)]
                      : const [Color(0xFFE5E7EB), Color(0xFFB0B5BB)],
                ),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFF6B7280), width: 1),
                boxShadow: down
                    ? const []
                    : const [
                        BoxShadow(
                          color: Color(0xFF000000),
                          offset: Offset(0, 4),
                          blurRadius: 0,
                        ),
                      ],
              ),
              alignment: Alignment.center,
              child: widget.pressed
                  ? Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDC2626),
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

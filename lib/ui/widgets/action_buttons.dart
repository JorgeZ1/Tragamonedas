import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/game_state.dart';
import '../../state/providers.dart';

/// Action bar: COLLECT | ← | → | START
/// Layout mirrors the reference image.
class ActionButtons extends ConsumerWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s    = ref.watch(gameControllerProvider);
    final ctrl = ref.read(gameControllerProvider.notifier);

    final canPlay  = s.totalSelectedBet > 0 && s.credits >= s.totalSelectedBet;
    final canRebet = s.totalSelectedBet == 0 &&
        s.totalLastBet > 0 &&
        s.credits >= s.totalLastBet;
    final isDouble   = s.canDouble;
    final playEnabled = !s.isBusy && (isDouble || canPlay || canRebet);

    final cashoutEnabled = s.doublingActive
        ? s.doubleResult == DoubleResult.none
        : (!s.isBusy && s.winnings > 0);
    final VoidCallback cashoutAction =
        s.doublingActive ? ctrl.cancelDoubleAndCashout : ctrl.cashout;

    // COLLECT button (very dark grey, like the image)
    final Widget collectBtn = _ArcadeButton(
      label: 'COLLECT',
      topColor: const Color(0xFF4B5563),
      bottomColor: const Color(0xFF1F2937),
      shadowColor: const Color(0xFF000000),
      textColor: Colors.white,
      enabled: cashoutEnabled,
      onTap: cashoutAction,
      flex: 2,
    );

    // ← arrow
    final Widget leftBtn = _ArcadeButton(
      icon: Icons.arrow_back_rounded,
      topColor: const Color(0xFF6B7280),
      bottomColor: const Color(0xFF374151),
      shadowColor: const Color(0xFF111827),
      textColor: Colors.white,
      enabled: !s.isBusy,
      onTap: ctrl.clearBetsAndHighlights,
      flex: 1,
    );

    // → arrow — repeats last bet
    final Widget rightBtn = _ArcadeButton(
      icon: Icons.arrow_forward_rounded,
      topColor: const Color(0xFF6B7280),
      bottomColor: const Color(0xFF374151),
      shadowColor: const Color(0xFF111827),
      textColor: Colors.white,
      enabled: !s.isBusy && s.totalLastBet > 0,
      onTap: () {
        if (s.credits >= s.totalLastBet && s.totalLastBet > 0) {
          ctrl.playOrDouble();
        }
      },
      flex: 1,
    );

    // START / DOBLAR / REPETIR button (green or purple)
    String startLabel;
    Color topGreen   = const Color(0xFF22C55E);
    Color botGreen   = const Color(0xFF15803D);
    Color shadowGreen = const Color(0xFF14532D);
    Color topColor;
    Color bottomColor;
    Color shadowC;
    if (isDouble) {
      startLabel = 'DOBLAR';
      topColor    = const Color(0xFF8B5CF6);
      bottomColor = const Color(0xFF6D28D9);
      shadowC     = const Color(0xFF4C1D95);
    } else if (canRebet) {
      startLabel = 'REPETIR';
      topColor   = topGreen; bottomColor = botGreen; shadowC = shadowGreen;
    } else {
      startLabel = 'START';
      topColor   = topGreen; bottomColor = botGreen; shadowC = shadowGreen;
    }

    final Widget startBtn = _ArcadeButton(
      label: startLabel,
      topColor: topColor,
      bottomColor: bottomColor,
      shadowColor: shadowC,
      textColor: Colors.white,
      enabled: playEnabled,
      onTap: ctrl.playOrDouble,
      flex: 2,
    );

    // When winning: DOBLAR left, COLLECT right
    final List<Widget> buttons = isDouble
        ? [startBtn, const SizedBox(width: 6), leftBtn, const SizedBox(width: 6), rightBtn, const SizedBox(width: 6), collectBtn]
        : [collectBtn, const SizedBox(width: 6), leftBtn, const SizedBox(width: 6), rightBtn, const SizedBox(width: 6), startBtn];

    return Row(children: buttons);
  }
}

class _ArcadeButton extends StatefulWidget {
  final String? label;
  final IconData? icon;
  final Color topColor;
  final Color bottomColor;
  final Color shadowColor;
  final Color textColor;
  final bool enabled;
  final VoidCallback onTap;
  final int flex;

  const _ArcadeButton({
    this.label,
    this.icon,
    required this.topColor,
    required this.bottomColor,
    required this.shadowColor,
    required this.textColor,
    required this.enabled,
    required this.onTap,
    this.flex = 1,
  });

  @override
  State<_ArcadeButton> createState() => _ArcadeButtonState();
}

class _ArcadeButtonState extends State<_ArcadeButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final disabled = !widget.enabled;
    final yOffset  = _pressed && !disabled ? 6.0 : 0.0;

    return Expanded(
      flex: widget.flex,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          if (!disabled) widget.onTap();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 70),
          transform: Matrix4.translationValues(0, yOffset, 0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: disabled
                  ? [
                      widget.topColor.withValues(alpha: 0.45),
                      widget.bottomColor.withValues(alpha: 0.45),
                    ]
                  : [widget.topColor, widget.bottomColor],
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.35),
              width: 1.2,
            ),
            boxShadow: disabled
                ? []
                : [
                    BoxShadow(
                      color: widget.shadowColor,
                      offset: Offset(0, 6 - yOffset),
                      blurRadius: 0,
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.55),
                      offset: Offset(0, 7 - yOffset),
                      blurRadius: 2,
                    ),
                  ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          child: widget.icon != null
              ? Icon(widget.icon, color: widget.textColor, size: 26)
              : FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.label!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: widget.textColor,
                      letterSpacing: 0.6,
                      shadows: const [
                        Shadow(color: Color(0x66000000), offset: Offset(0, 1)),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

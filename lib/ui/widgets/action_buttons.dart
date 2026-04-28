import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/game_state.dart';
import '../../state/providers.dart';
import '../../theme/slot_theme.dart';

class ActionButtons extends ConsumerWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameControllerProvider);
    final ctrl = ref.read(gameControllerProvider.notifier);

    final canPlay = s.totalSelectedBet > 0 && s.credits >= s.totalSelectedBet;
    final canRebet = s.totalSelectedBet == 0 &&
        s.totalLastBet > 0 &&
        s.credits >= s.totalLastBet;
    final isDouble = s.canDouble;
    final playEnabled = !s.isBusy && (isDouble || canPlay || canRebet);

    // Cuando estamos doblando: COBRAR está activo solo antes de elegir.
    // En caso normal: solo si hay ganancias y no estamos ocupados.
    final cashoutEnabled = s.doublingActive
        ? s.doubleResult == DoubleResult.none
        : (!s.isBusy && s.winnings > 0);
    final VoidCallback cashoutAction =
        s.doublingActive ? ctrl.cancelDoubleAndCashout : ctrl.cashout;

    String label;
    Color color;
    Color shadowColor;
    if (isDouble) {
      label = 'DOBLAR';
      color = SlotTheme.doublePurple;
      shadowColor = SlotTheme.doublePurpleShadow;
    } else if (canRebet) {
      label = 'REPETIR';
      color = SlotTheme.playGreen;
      shadowColor = SlotTheme.playGreenShadow;
    } else {
      label = 'JUGAR';
      color = SlotTheme.playGreen;
      shadowColor = SlotTheme.playGreenShadow;
    }

    final Widget cobrarBtn = Expanded(
      child: _ActionButton(
        label: 'COBRAR',
        color: SlotTheme.cashoutYellow,
        shadowColor: SlotTheme.cashoutYellowShadow,
        textColor: const Color(0xFF1F2937),
        enabled: cashoutEnabled,
        onTap: cashoutAction,
      ),
    );

    final Widget playBtn = Expanded(
      child: _ActionButton(
        label: label,
        color: color,
        shadowColor: shadowColor,
        textColor: Colors.white,
        enabled: playEnabled,
        onTap: ctrl.playOrDouble,
      ),
    );

    // Al ganar: DOBLAR (izq) | COBRAR (der)
    // Normal:   COBRAR (izq) | JUGAR/REPETIR (der)
    final List<Widget> buttons = isDouble
        ? [playBtn, const SizedBox(width: 12), cobrarBtn]
        : [cobrarBtn, const SizedBox(width: 12), playBtn];

    return Row(children: buttons);
  }
}

class _ActionButton extends StatefulWidget {
  final String label;
  final Color color;
  final Color shadowColor;
  final Color textColor;
  final bool enabled;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.shadowColor,
    required this.textColor,
    required this.enabled,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final disabled = !widget.enabled;
    final yOffset = _pressed && !disabled ? 6.0 : 0.0;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        if (!disabled) widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        transform: Matrix4.translationValues(0, yOffset, 0),
        decoration: BoxDecoration(
          color: disabled
              ? widget.color.withValues(alpha: 0.5)
              : widget.color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.shadowColor,
              offset: Offset(0, 6 - yOffset),
              blurRadius: 0,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            widget.label,
            style: SlotTheme.gameFont(size: 13, color: widget.textColor),
          ),
        ),
      ),
    );
  }
}

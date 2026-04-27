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
          blink: s.lastWin > 0,
        ),
        _Display(
          label: 'GANANCIA',
          value: s.winnings,
          valueColor: SlotTheme.goldLight,
          blink: s.winnings > 0,
        ),
        _Display(
          label: 'CRÉDITO',
          value: s.credits,
          valueColor: SlotTheme.creditGreen,
          flash: s.flashCredits,
        ),
      ],
    );
  }
}

class _Display extends StatefulWidget {
  final String label;
  final int value;
  final Color valueColor;
  final bool blink;
  final bool flash;

  const _Display({
    required this.label,
    required this.value,
    required this.valueColor,
    this.blink = false,
    this.flash = false,
  });

  @override
  State<_Display> createState() => _DisplayState();
}

class _DisplayState extends State<_Display>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.flash ? SlotTheme.creditGreen : widget.valueColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.label,
          textAlign: TextAlign.center,
          style: SlotTheme.bodyFont(
            size: 11,
            color: const Color(0xFF9CA3AF),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: GlowDecorations.display,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          constraints: const BoxConstraints(minHeight: 44),
          alignment: Alignment.center,
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (context, _) {
              final glow = widget.blink ? _ctrl.value : 0.0;
              final shadows = widget.blink || widget.flash
                  ? [
                      Shadow(
                        color: color,
                        blurRadius: 5 + 10 * glow,
                      ),
                    ]
                  : null;
              return AnimatedScale(
                duration: const Duration(milliseconds: 150),
                scale: widget.flash ? 1.2 : 1.0,
                child: Text(
                  '${widget.value}',
                  style: SlotTheme.gameFont(
                    size: 18,
                    color: color,
                    shadows: shadows,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

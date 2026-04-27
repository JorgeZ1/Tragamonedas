import 'package:flutter/material.dart';

import '../../data/symbols.dart';
import '../../theme/slot_theme.dart';
import '../../util/glow_decoration.dart';

enum SlotVisualState { idle, active, winner, eventWon, deactivated }

class SlotCell extends StatefulWidget {
  final GameSymbol symbol;
  final SlotVisualState visual;

  const SlotCell({
    super.key,
    required this.symbol,
    required this.visual,
  });

  @override
  State<SlotCell> createState() => _SlotCellState();
}

class _SlotCellState extends State<SlotCell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BoxDecoration decoration;
    double scale = 1.0;
    double opacity = 1.0;

    switch (widget.visual) {
      case SlotVisualState.idle:
        decoration = GlowDecorations.slotIdle;
        break;
      case SlotVisualState.active:
        decoration = GlowDecorations.slotActive;
        scale = 1.05;
        break;
      case SlotVisualState.winner:
        decoration = GlowDecorations.slotWinner(pulse: _pulse.value);
        scale = 1.1 + 0.1 * _pulse.value;
        break;
      case SlotVisualState.eventWon:
        decoration = GlowDecorations.slotEventWon;
        opacity = 0.9;
        break;
      case SlotVisualState.deactivated:
        decoration = GlowDecorations.slotDeactivated;
        opacity = 0.4;
        break;
    }

    final isWinner = widget.visual == SlotVisualState.winner;

    Widget cell = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      decoration: decoration,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(2),
      child: _SymbolDisplay(symbol: widget.symbol),
    );

    cell = Transform.scale(scale: scale, child: cell);
    if (opacity < 1.0) {
      cell = Opacity(opacity: opacity, child: cell);
    }

    return isWinner
        ? AnimatedBuilder(animation: _pulse, builder: (_, __) => cell)
        : cell;
  }
}

class _SymbolDisplay extends StatelessWidget {
  final GameSymbol symbol;
  const _SymbolDisplay({required this.symbol});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final base = constraints.biggest.shortestSide;
        return _renderSymbol(symbol, base);
      },
    );
  }

  static Widget _renderSymbol(GameSymbol s, double base) {
    final scale = s.isMini ? 0.55 : 0.85;
    if (s.isOnceMore) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          'ONCE\nMORE',
          textAlign: TextAlign.center,
          style: SlotTheme.gameFont(
            size: base * 0.18,
            color: SymbolColors.onceMore,
          ),
        ),
      );
    }

    if (s.type == 'bar' || s.type == 'mini_bar') {
      return Container(
        padding: EdgeInsets.symmetric(
            horizontal: base * 0.06, vertical: base * 0.03),
        decoration: BoxDecoration(
          color: SymbolColors.barBg,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          'BAR',
          style: SlotTheme.gameFont(
            size: base * scale * 0.4,
            color: Colors.white,
          ),
        ),
      );
    }

    if (s.type == 'seven' || s.type == 'mini_seven') {
      return Text(
        '7',
        style: SlotTheme.gameFont(
          size: base * scale,
          color: SymbolColors.seven,
          shadows: [
            const Shadow(
                color: Color(0xFFC53030), offset: Offset(1, 1)),
            const Shadow(
                color: Color(0xFF9B2C2C), offset: Offset(2, 2)),
          ],
        ),
      );
    }

    return Text(
      s.display,
      style: TextStyle(fontSize: base * scale),
    );
  }
}

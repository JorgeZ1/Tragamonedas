import 'package:flutter/material.dart';

import '../../data/symbols.dart';

enum SlotVisualState { idle, active, winner, eventWon, deactivated }

class SlotCell extends StatefulWidget {
  final GameSymbol symbol;
  final SlotVisualState visual;

  const SlotCell({super.key, required this.symbol, required this.visual});

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
    final isWinner = widget.visual == SlotVisualState.winner;
    final isActive = widget.visual == SlotVisualState.active;
    final isDeactivated = widget.visual == SlotVisualState.deactivated;

    // Border color
    Color borderColor;
    if (isWinner) {
      borderColor = Color.lerp(
          const Color(0xFFFBBF24), const Color(0xFFEF4444), _pulse.value)!;
    } else if (isActive) {
      borderColor = const Color(0xFFFBBF24);
    } else {
      borderColor = Colors.black; // very sharp black line
    }

    // Background
    Color bgColor;
    if (isDeactivated) {
      bgColor = const Color(0xFF6B7280);
    } else if (isWinner) {
      bgColor = Color.lerp(Colors.white, const Color(0xFFFEF9C3), _pulse.value)!;
    } else if (widget.visual == SlotVisualState.eventWon) {
      bgColor = const Color(0xFFD1FAE5);
    } else {
      bgColor = Colors.white;
    }

    Widget cell = AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: borderColor, width: isActive || isWinner ? 2 : 1),
        boxShadow: isActive
            ? [BoxShadow(color: const Color(0xFFFBBF24).withValues(alpha: 0.6), blurRadius: 6)]
            : isWinner
                ? [BoxShadow(color: const Color(0xFFFBBF24).withValues(alpha: 0.8 * _pulse.value), blurRadius: 8, spreadRadius: 1)]
                : null,
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(2),
      child: Opacity(
        opacity: isDeactivated ? 0.4 : 1.0,
        child: _SymbolDisplay(symbol: widget.symbol),
      ),
    );

    if (isWinner) {
      cell = AnimatedBuilder(animation: _pulse, builder: (_, __) => cell);
    }

    return cell;
  }
}

class _SymbolDisplay extends StatelessWidget {
  final GameSymbol symbol;
  const _SymbolDisplay({required this.symbol});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final base = c.biggest.shortestSide;
      return _render(symbol, base);
    });
  }

  static Widget _render(GameSymbol s, double base) {
    // ONCE MORE
    if (s.isOnceMore) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          'once\nmore',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: base * 0.22,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF1D4ED8),
            height: 1.1,
          ),
        ),
      );
    }

    final iconName = s.baseType ?? s.type;
    final scale = s.isMini ? 0.6 : 0.82;
    
    Widget icon = Image.asset(
      'assets/icons/$iconName.png',
      width: base * scale,
      height: base * scale,
      fit: BoxFit.contain,
    );

    if (s.type == 'bar' || s.type == 'bar1000') {
      return FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            Text(
              '${s.prize}',
              style: TextStyle(
                fontSize: base * 0.18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFDC2626),
              ),
            ),
          ],
        ),
      );
    }

    return icon;
  }
}

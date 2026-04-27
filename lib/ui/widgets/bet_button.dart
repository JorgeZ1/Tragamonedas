import 'package:flutter/material.dart';

import '../../data/symbols.dart';
import '../../theme/slot_theme.dart';

class BetButton extends StatelessWidget {
  final String type;
  final int count;
  final bool disabled;
  final bool isBetting;
  final VoidCallback onTap;

  const BetButton({
    super.key,
    required this.type,
    required this.count,
    required this.disabled,
    required this.isBetting,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final symbol = symbolByType(type);
    final selected = count > 0;

    final baseColor = disabled
        ? const Color(0xFF6B7280)
        : selected
            ? SlotTheme.betSelected
            : SlotTheme.betBlue;

    final shadowColor = selected
        ? SlotTheme.betSelectedShadow
        : (disabled ? const Color(0xFF4A5568) : SlotTheme.betBlueShadow);

    final yOffset = selected ? 4.0 : 0.0;

    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 80),
            transform: Matrix4.translationValues(0, yOffset, 0),
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isBetting
                    ? SlotTheme.goldLight
                    : SlotTheme.betBlueLight,
                width: isBetting ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  offset: Offset(0, 6 - yOffset),
                  blurRadius: 0,
                ),
                if (isBetting)
                  const BoxShadow(
                      color: Color(0xCCFDE047),
                      blurRadius: 12,
                      spreadRadius: 2),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _Icon(symbol: symbol),
                const SizedBox(height: 2),
                FittedBox(
                  child: Text(
                    'x${symbol.prize}',
                    style: SlotTheme.gameFont(
                      size: 8,
                      color: SlotTheme.goldLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (count > 0)
            Positioned(
              top: -6,
              right: -6,
              child: Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Icon extends StatelessWidget {
  final GameSymbol symbol;
  const _Icon({required this.symbol});

  @override
  Widget build(BuildContext context) {
    if (symbol.type == 'bar') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: SymbolColors.barBg,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          'BAR',
          style: SlotTheme.gameFont(size: 14, color: Colors.white),
        ),
      );
    }
    if (symbol.type == 'seven') {
      return Text(
        '7',
        style: SlotTheme.gameFont(size: 22, color: SymbolColors.seven),
      );
    }
    return Text(symbol.display, style: const TextStyle(fontSize: 26));
  }
}

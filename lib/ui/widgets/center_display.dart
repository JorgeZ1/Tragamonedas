import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/providers.dart';
import '../../theme/slot_theme.dart';
import 'double_up_overlay.dart';

class CenterDisplay extends ConsumerWidget {
  const CenterDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameControllerProvider);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1F2937), Color(0xFF111827)],
        ),
        boxShadow: const [
          BoxShadow(color: Color(0xCC000000), blurRadius: 8, spreadRadius: -1),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Logo
          AnimatedOpacity(
            duration: const Duration(milliseconds: 350),
            opacity: s.showLogo &&
                    s.messageTitle == null &&
                    !s.doublingActive
                ? 1.0
                : 0.0,
            child: _Logo(),
          ),
          // Message box
          AnimatedScale(
            duration: const Duration(milliseconds: 250),
            scale: s.messageTitle != null ? 1.0 : 0.9,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: s.messageTitle != null && !s.doublingActive ? 1.0 : 0.0,
              child: _MessageBox(
                symbol: s.messageSymbol,
                title: s.messageTitle,
                details: s.messageDetails,
              ),
            ),
          ),
          // Double Up overlay
          if (s.doublingActive) const DoubleUpOverlay(),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xB3000000),
        borderRadius: BorderRadius.circular(10),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('SUPER',
                style: SlotTheme.gameFont(size: 22, color: Colors.white)),
            const SizedBox(height: 6),
            Text('ALIANZA',
                style: SlotTheme.gameFont(
                    size: 22, color: const Color(0xFFEF4444))),
          ],
        ),
      ),
    );
  }
}

class _MessageBox extends StatelessWidget {
  final String? symbol;
  final String? title;
  final String? details;

  const _MessageBox({this.symbol, this.title, this.details});

  @override
  Widget build(BuildContext context) {
    if (title == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xB3000000),
        borderRadius: BorderRadius.circular(10),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (symbol != null)
              Text(symbol!,
                  style: const TextStyle(fontSize: 44),
                  textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text(
              title ?? '',
              style: SlotTheme.gameFont(size: 14, color: SlotTheme.goldLight),
              textAlign: TextAlign.center,
            ),
            if (details != null && details!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                details!,
                style: SlotTheme.gameFont(
                    size: 12, color: SlotTheme.creditGreen),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

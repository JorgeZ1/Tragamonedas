import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/providers.dart';
import '../screens/stats_screen.dart';
import 'led_display.dart';

class HeaderPanel extends ConsumerWidget {
  const HeaderPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _TopActionRow(),
        const SizedBox(height: 12),
        _CountersRow(winnings: s.winnings, credits: s.credits),
      ],
    );
  }
}

class _TopActionRow extends StatelessWidget {
  const _TopActionRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Compras
        _HeaderButton(
          icon: Icons.storefront_rounded,
          label: 'COMPRAS',
          colors: const [Color(0xFF10B981), Color(0xFF047857)],
          onTap: () => _soon(context),
        ),
        
        // Ranking
        _HeaderButton(
          icon: Icons.emoji_events_rounded,
          label: 'RANKING',
          colors: const [Color(0xFFF59E0B), Color(0xFFB45309)],
          onTap: () => _soon(context),
        ),

        // Estadísticas
        _HeaderButton(
          icon: Icons.bar_chart_rounded,
          label: 'ESTADÍSTICAS',
          colors: const [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const StatsScreen()),
          ),
        ),
      ],
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<Color> colors;
  final VoidCallback onTap;

  const _HeaderButton({
    required this.icon,
    required this.label,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: colors[1].withValues(alpha: 0.5),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 26),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountersRow extends StatelessWidget {
  final int winnings;
  final int credits;

  const _CountersRow({required this.winnings, required this.credits});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _RetroCounter(
            title: 'GANANCIAS',
            value: winnings,
            ledColor: const Color(0xFF10B981), // Emerald/Green Neon
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _RetroCounter(
            title: 'MONEDAS',
            value: credits,
            ledColor: const Color(0xFFF59E0B), // Amber Neon
          ),
        ),
      ],
    );
  }
}

class _RetroCounter extends StatelessWidget {
  final String title;
  final int value;
  final Color ledColor;

  const _RetroCounter({
    required this.title,
    required this.value,
    required this.ledColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A), // Very dark slate
        borderRadius: BorderRadius.circular(4), // Square look
        border: Border.all(
          color: const Color(0xFF334155),
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          LedDisplay(
            value: value,
            digits: 6,
            height: 32,
            onColor: ledColor,
            offColor: ledColor.withValues(alpha: 0.08),
          ),
        ],
      ),
    );
  }
}

void _soon(BuildContext context) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(const SnackBar(
      duration: Duration(milliseconds: 800),
      content: Text('Próximamente'),
    ));
}

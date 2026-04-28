import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/providers.dart';

/// Full Mexican-arcade header. Three rows:
///   1) level + name input + Mina/Jackpot/Clásico stack
///   2) Ranking + cart + ad banners
///   3) WIN / Gem / Spin / $ counters
class HeaderPanel extends ConsumerWidget {
  const HeaderPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Row1(credits: s.credits, totalBet: s.totalSelectedBet),
        const SizedBox(height: 6),
        const _Row2Ads(),
        const SizedBox(height: 6),
        _Row3Counters(winnings: s.winnings, credits: s.credits),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// ROW 1: level | name | mina/jackpot/clasico
// ─────────────────────────────────────────────────────────────────────────
class _Row1 extends StatelessWidget {
  final int credits;
  final int totalBet;
  const _Row1({required this.credits, required this.totalBet});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Level + SUBIR NIVEL ─────────────────────────────────
          Expanded(
            flex: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 18, height: 18,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFBBF24),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Text('\$',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '$credits/ Nivel: 2',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                _SmallButton(
                  label: 'SUBIR\nNIVEL',
                  bg: Colors.black,
                  fg: Colors.white,
                  onTap: () => _soon(context),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),

          // ── Centre: bet badge + name input ──────────────────────
          Expanded(
            flex: 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(
                    '$totalBet',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4B6B7A),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: const Color(0xFF1F2937), width: 1),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Apodo o Nombre',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        width: 22, height: 22,
                        decoration: BoxDecoration(
                          color: const Color(0xFF22C55E),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: const Icon(Icons.check,
                            color: Colors.white, size: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),

          // ── Right stack: MINA / JACKPOT / CLASICO ──────────────
          Expanded(
            flex: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SideTab(
                  label: 'MINA',
                  fg: Colors.white,
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFBBF24), Color(0xFFD97706)],
                  ),
                  trailing: const Icon(Icons.diamond,
                      size: 14, color: Color(0xFF10B981)),
                  onTap: () => _soon(context),
                ),
                const SizedBox(height: 3),
                _SideTab(
                  label: 'Jackpot',
                  fg: Colors.white,
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFEF4444), Color(0xFF991B1B)],
                  ),
                  trailing: const Icon(Icons.casino,
                      size: 14, color: Colors.white),
                  onTap: () => _soon(context),
                ),
                const SizedBox(height: 3),
                _SideTab(
                  label: 'TRAGAMONEDAS\nCLASICO',
                  fontSize: 8,
                  fg: Colors.white,
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF374151), Color(0xFF111827)],
                  ),
                  onTap: () => _soon(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallButton extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  final VoidCallback onTap;
  const _SmallButton(
      {required this.label,
      required this.bg,
      required this.fg,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: const Color(0xFF6B7280), width: 0.7),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: fg,
            fontSize: 9,
            fontWeight: FontWeight.w900,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}

class _SideTab extends StatelessWidget {
  final String label;
  final Color fg;
  final Gradient gradient;
  final Widget? trailing;
  final double fontSize;
  final VoidCallback onTap;

  const _SideTab({
    required this.label,
    required this.fg,
    required this.gradient,
    required this.onTap,
    this.trailing,
    this.fontSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 18,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: Colors.black.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: fg,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                  ),
                ),
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 3),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// ROW 2: Ranking + cart + 2 ad banners
// ─────────────────────────────────────────────────────────────────────────
class _Row2Ads extends StatelessWidget {
  const _Row2Ads();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: Row(
        children: [
          // RANKING
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () => _soon(context),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFEF08A), Color(0xFFE0B100)],
                  ),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color: const Color(0xFF7C2D12), width: 1.5),
                ),
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('Ranking',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFB91C1C),
                              height: 1.0)),
                      Text('TOP 100',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF7C2D12),
                              height: 1.1)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          // CART
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () => _soon(context),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2C5984),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFF1E40AF)),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.shopping_cart,
                    color: Colors.white, size: 22),
              ),
            ),
          ),
          const SizedBox(width: 4),
          // AD 1: $200 + 5 SPIN + 3 VIDEO
          Expanded(
            flex: 5,
            child: _AdBanner(
              parts: const [
                _AdPart(text: '200', leading: '\$', bg: Color(0xFFFBBF24)),
                _AdPart(text: '5', leading: 'SPIN', bg: Color(0xFFDC2626)),
                _AdPart(text: '3', leading: 'VIDEO', bg: Color(0xFF15803D)),
              ],
              onTap: () => _soon(context),
            ),
          ),
          const SizedBox(width: 4),
          // AD 2: $100 + 3 SPIN AD
          Expanded(
            flex: 4,
            child: _AdBanner(
              parts: const [
                _AdPart(text: '100', leading: '\$', bg: Color(0xFFFBBF24)),
                _AdPart(text: '3', leading: 'SPIN', bg: Color(0xFFDC2626)),
                _AdPart(text: 'AD', leading: '', bg: Color(0xFF374151)),
              ],
              onTap: () => _soon(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdPart {
  final String text;
  final String leading;
  final Color bg;
  const _AdPart(
      {required this.text, required this.leading, required this.bg});
}

class _AdBanner extends StatelessWidget {
  final List<_AdPart> parts;
  final VoidCallback onTap;
  const _AdBanner({required this.parts, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: const Color(0xFF1F2937),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            for (var i = 0; i < parts.length; i++) ...[
              if (i > 0)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  child: Text('+',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 12)),
                ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 2, vertical: 2),
                  decoration: BoxDecoration(
                    color: parts[i].bg,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (parts[i].leading.isNotEmpty)
                          Text(parts[i].leading,
                              style: const TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  height: 1.0)),
                        Text(parts[i].text,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                height: 1.0)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// ROW 3: counters
// ─────────────────────────────────────────────────────────────────────────
class _Row3Counters extends StatelessWidget {
  final int winnings;
  final int credits;
  const _Row3Counters({required this.winnings, required this.credits});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: _Counter(
              icon: const Icon(Icons.attach_money,
                  size: 16, color: Color(0xFFFBBF24)),
              labelText: 'WIN',
              value: '$winnings',
              top: const Color(0xFF16A34A),
              bottom: const Color(0xFF14532D),
              border: const Color(0xFF166534),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            flex: 3,
            child: _Counter(
              icon: const Icon(Icons.diamond,
                  size: 14, color: Color(0xFF10B981)),
              labelText: '',
              value: '0',
              top: const Color(0xFF111827),
              bottom: const Color(0xFF030712),
              border: const Color(0xFF065F46),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            flex: 3,
            child: _Counter(
              icon: const Icon(Icons.replay,
                  size: 14, color: Color(0xFFFBBF24)),
              labelText: 'SPIN',
              value: '1',
              top: const Color(0xFFD97706),
              bottom: const Color(0xFF7C2D12),
              border: const Color(0xFFA16207),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            flex: 4,
            child: _Counter(
              icon: const Icon(Icons.monetization_on,
                  size: 16, color: Color(0xFFFBBF24)),
              labelText: '',
              value: '$credits',
              top: const Color(0xFF1D4ED8),
              bottom: const Color(0xFF1E3A8A),
              border: const Color(0xFF1E40AF),
            ),
          ),
        ],
      ),
    );
  }
}

class _Counter extends StatelessWidget {
  final Widget icon;
  final String labelText;
  final String value;
  final Color top;
  final Color bottom;
  final Color border;

  const _Counter({
    required this.icon,
    required this.labelText,
    required this.value,
    required this.top,
    required this.bottom,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [top, bottom],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: 1.5),
        boxShadow: const [
          BoxShadow(color: Color(0x55000000), blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 4),
          if (labelText.isNotEmpty) ...[
            Text(
              labelText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 10,
              ),
            ),
            const SizedBox(width: 4),
          ],
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(3),
              ),
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFFFBBF24),
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ),
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

import 'package:flutter/material.dart';

/// Bright red 7-segment LED display, like the bet counters on a Mexican
/// arcade slot machine. Black recessed background, glowing red segments.
class LedDisplay extends StatelessWidget {
  final int value;
  final int digits;
  final double height;
  final Color onColor;
  final Color offColor;

  const LedDisplay({
    super.key,
    required this.value,
    this.digits = 1,
    this.height = 22,
    this.onColor = const Color(0xFFFF2A2A),
    this.offColor = const Color(0x14FF2A2A),
  });

  @override
  Widget build(BuildContext context) {
    final str = value.toString().padLeft(digits, '0');

    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0000),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: onColor.withValues(alpha: 0.3), width: 1),
        boxShadow: const [
          // Inner darkening
          BoxShadow(color: Color(0xCC000000), blurRadius: 1, offset: Offset(0, 1)),
        ],
      ),
      child: CustomPaint(
        painter: _SevenSegPainter(
          text: str,
          onColor: onColor,
          offColor: offColor,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _SevenSegPainter extends CustomPainter {
  final String text;
  final Color onColor;
  final Color offColor;

  // segment map per digit ['a','b','c','d','e','f','g']
  static const Map<String, List<int>> _segments = {
    '0': [1, 1, 1, 1, 1, 1, 0],
    '1': [0, 1, 1, 0, 0, 0, 0],
    '2': [1, 1, 0, 1, 1, 0, 1],
    '3': [1, 1, 1, 1, 0, 0, 1],
    '4': [0, 1, 1, 0, 0, 1, 1],
    '5': [1, 0, 1, 1, 0, 1, 1],
    '6': [1, 0, 1, 1, 1, 1, 1],
    '7': [1, 1, 1, 0, 0, 0, 0],
    '8': [1, 1, 1, 1, 1, 1, 1],
    '9': [1, 1, 1, 1, 0, 1, 1],
    '-': [0, 0, 0, 0, 0, 0, 1],
    ' ': [0, 0, 0, 0, 0, 0, 0],
  };

  _SevenSegPainter({required this.text, required this.onColor, required this.offColor});

  @override
  void paint(Canvas canvas, Size size) {
    final n = text.length;
    if (n == 0) return;

    // Reserve aspect ratio ~0.55 per digit, fill height.
    final digitH = size.height;
    final digitW = digitH * 0.55;
    final spacing = digitW * 0.18;
    final totalW = digitW * n + spacing * (n - 1);
    final startX = (size.width - totalW) / 2;

    for (var i = 0; i < n; i++) {
      final x = startX + i * (digitW + spacing);
      _drawDigit(canvas, text[i], x, 0, digitW, digitH);
    }
  }

  void _drawDigit(Canvas c, String ch, double x, double y, double w, double h) {
    final segs = _segments[ch] ?? _segments[' ']!;
    final t = w * 0.16; // segment thickness
    final pad = w * 0.08;

    final innerW = w - pad * 2;
    final innerH = h - pad * 2;
    final midY = y + h / 2;

    final on = Paint()
      ..color = onColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 0.6);
    final off = Paint()..color = offColor;

    // a — top horizontal
    _hSeg(c, x + pad + t, y + pad, innerW - t * 2, t, segs[0] == 1 ? on : off);
    // b — top-right vertical
    _vSeg(c, x + pad + innerW - t, y + pad + t, t, (innerH / 2) - t * 1.5, segs[1] == 1 ? on : off);
    // c — bottom-right vertical
    _vSeg(c, x + pad + innerW - t, midY + t * 0.5, t, (innerH / 2) - t * 1.5, segs[2] == 1 ? on : off);
    // d — bottom horizontal
    _hSeg(c, x + pad + t, y + pad + innerH - t, innerW - t * 2, t, segs[3] == 1 ? on : off);
    // e — bottom-left vertical
    _vSeg(c, x + pad, midY + t * 0.5, t, (innerH / 2) - t * 1.5, segs[4] == 1 ? on : off);
    // f — top-left vertical
    _vSeg(c, x + pad, y + pad + t, t, (innerH / 2) - t * 1.5, segs[5] == 1 ? on : off);
    // g — middle horizontal
    _hSeg(c, x + pad + t, midY - t / 2, innerW - t * 2, t, segs[6] == 1 ? on : off);
  }

  void _hSeg(Canvas c, double x, double y, double w, double h, Paint p) {
    final path = Path()
      ..moveTo(x, y + h / 2)
      ..lineTo(x + h / 2, y)
      ..lineTo(x + w - h / 2, y)
      ..lineTo(x + w, y + h / 2)
      ..lineTo(x + w - h / 2, y + h)
      ..lineTo(x + h / 2, y + h)
      ..close();
    c.drawPath(path, p);
  }

  void _vSeg(Canvas c, double x, double y, double w, double h, Paint p) {
    final path = Path()
      ..moveTo(x + w / 2, y)
      ..lineTo(x + w, y + w / 2)
      ..lineTo(x + w, y + h - w / 2)
      ..lineTo(x + w / 2, y + h)
      ..lineTo(x, y + h - w / 2)
      ..lineTo(x, y + w / 2)
      ..close();
    c.drawPath(path, p);
  }

  @override
  bool shouldRepaint(_SevenSegPainter old) => old.text != text;
}

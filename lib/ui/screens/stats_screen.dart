import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/providers.dart';
import '../../theme/slot_theme.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncStats = ref.watch(statsProvider);

    return Scaffold(
      backgroundColor: SlotTheme.bgOuter,
      appBar: AppBar(
        title: Text('STATS', style: SlotTheme.gameFont(size: 14)),
        backgroundColor: SlotTheme.bgOuter,
        foregroundColor: Colors.white,
      ),
      body: asyncStats.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (stats) {
          final rtpPct = (stats.rtp * 100).toStringAsFixed(2);
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _StatCard(
                    label: 'RTP REAL',
                    value: '$rtpPct %',
                    color: SlotTheme.creditGreen),
                const SizedBox(height: 12),
                _StatCard(
                    label: 'TOTAL APOSTADO',
                    value: '${stats.totalBet}',
                    color: SlotTheme.goldLight),
                _StatCard(
                    label: 'TOTAL GANADO',
                    value: '${stats.totalPrize}',
                    color: SlotTheme.goldLight),
                _StatCard(
                    label: 'GIROS',
                    value: '${stats.totalSpins}',
                    color: Colors.white),
                _StatCard(
                    label: 'PREMIO MAYOR',
                    value: '${stats.biggestWin}',
                    color: SlotTheme.creditGreen),
                _StatCard(
                    label: 'EVENTOS DISPARADOS',
                    value: '${stats.eventCount}',
                    color: Colors.white),
                const SizedBox(height: 8),
                if (stats.eventBreakdown.isNotEmpty)
                  Text(
                    'POR TIPO: ${stats.eventBreakdown.entries.map((e) => '${e.key}=${e.value}').join('  •  ')}',
                    style: SlotTheme.bodyFont(
                        size: 12, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    final ctrl = ref.read(gameControllerProvider.notifier);
                    await ctrl.resetWallet();
                    ref.invalidate(statsProvider);
                    if (context.mounted) Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SlotTheme.cashoutYellow,
                    foregroundColor: const Color(0xFF1F2937),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text('RESET (saldo y stats)',
                      style: SlotTheme.gameFont(
                          size: 12, color: const Color(0xFF1F2937))),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: SlotTheme.frameDark,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: SlotTheme.frameLight),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: SlotTheme.bodyFont(size: 13, color: Colors.white)),
            Text(value, style: SlotTheme.gameFont(size: 14, color: color)),
          ],
        ),
      ),
    );
  }
}

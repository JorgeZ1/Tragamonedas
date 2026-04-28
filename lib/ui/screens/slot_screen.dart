import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/providers.dart';
import '../../theme/slot_theme.dart';
import '../widgets/action_buttons.dart';
import '../widgets/bet_grid.dart';
import '../widgets/header_panel.dart';
import '../widgets/slot_board.dart';
import 'stats_screen.dart';

class SlotScreen extends ConsumerWidget {
  const SlotScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameControllerProvider);

    return Scaffold(
      backgroundColor: SlotTheme.bgOuter,
      appBar: AppBar(
        backgroundColor: SlotTheme.bgOuter,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'TRAGAMONEDAS',
          style: SlotTheme.gameFont(size: 12, color: SlotTheme.goldLight),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const StatsScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: SlotTheme.frameDark,
                        border:
                            Border.all(color: SlotTheme.goldLight, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const HeaderPanel(),
                    ),
                    const SizedBox(height: 4),
                    // Board
                    Container(
                      decoration: BoxDecoration(
                        color: SlotTheme.frameLight,
                        border:
                            Border.all(color: SlotTheme.goldLight, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(3),
                      height: 280,
                      child: const SlotBoard(),
                    ),
                    const SizedBox(height: 4),
                    // Bets
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: SlotTheme.frameDark,
                        border:
                            Border.all(color: SlotTheme.goldLight, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const BetGrid(),
                    ),
                    const SizedBox(height: 4),
                    // Actions
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: SlotTheme.frameDark,
                        border:
                            Border.all(color: SlotTheme.goldLight, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const ActionButtons(),
                    ),
                    const SizedBox(height: 4),
                    // Debug info
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Estado: ${s.phase.name} | Luz: ${s.currentLightIndex} | Apuestas: ${s.selectedBets.length}',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

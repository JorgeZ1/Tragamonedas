import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/providers.dart';
import '../widgets/action_buttons.dart';
import '../widgets/bet_grid.dart';
import '../widgets/header_panel.dart';
import '../widgets/reward_button.dart';
import '../widgets/slot_board.dart';
import 'stats_screen.dart';

class SlotScreen extends ConsumerWidget {
  const SlotScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(gameControllerProvider); // keep reactive

    return Scaffold(
      backgroundColor: const Color(0xFF3DA5C9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [

                    // ── Header (Mexican-arcade style) ──────────────────
                    HeaderPanel(),
                    SizedBox(height: 6),

                    // ── Reward (kept as a slim banner) ─────────────────
                    RewardButton(),
                    SizedBox(height: 6),

                    // ── Main board (7×7) ───────────────────────────────
                    SlotBoard(),
                    SizedBox(height: 8),

                    // ── Action buttons: COLLECT | ← | → | START ────────
                    SizedBox(height: 56, child: ActionButtons()),
                    SizedBox(height: 6),

                    // ── Bet panel ──────────────────────────────────────
                    BetGrid(),

                    SizedBox(height: 8),
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

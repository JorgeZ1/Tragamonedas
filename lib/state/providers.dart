import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/db/credits_dao.dart';
import '../data/db/stats_dao.dart';
import 'game_controller.dart';
import 'game_state.dart';
import 'spin_engine.dart';

final creditsDaoProvider = Provider<CreditsDao>((_) => CreditsDao());
final statsDaoProvider = Provider<StatsDao>((_) => StatsDao());
final spinEngineProvider = Provider<SpinEngine>((_) => SpinEngine());

/// Loads the persisted credits from SQLite once at app start.
final initialCreditsProvider = FutureProvider<int>((ref) async {
  return ref.read(creditsDaoProvider).read();
});

/// Main game controller. Depends on initialCredits being resolved.
final gameControllerProvider =
    StateNotifierProvider<GameController, GameState>((ref) {
  final initial = ref.watch(initialCreditsProvider).maybeWhen(
        data: (v) => v,
        orElse: () => 100,
      );
  return GameController(
    creditsDao: ref.read(creditsDaoProvider),
    statsDao: ref.read(statsDaoProvider),
    engine: ref.read(spinEngineProvider),
    initialCredits: initial,
  );
});

final statsProvider = FutureProvider.autoDispose<GameStats>((ref) async {
  return ref.read(statsDaoProvider).read();
});

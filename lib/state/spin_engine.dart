import 'dart:math';

import '../data/light_path.dart';
import '../data/symbols.dart';

class SpinEngine {
  final Random _rng;
  SpinEngine([Random? rng]) : _rng = rng ?? Random();

  /// Build the 20-slot board. Mirrors HTML setupBoard():
  ///   - slot 3 fixed = bar
  ///   - slots 8 and 18 fixed = once_more
  ///   - rest filled by shuffled pool of fruit + mini variants
  List<GameSymbol> buildBoard() {
    final board = List<GameSymbol?>.filled(20, null);
    board[3] = kSymbols['bar']!;
    board[8] = kSymbols['once_more']!;
    board[18] = kSymbols['once_more']!;

    final pool = <GameSymbol>[
      kSymbols['seven']!, kSymbols['mini_seven']!,
      kSymbols['mini_bar']!,
      kSymbols['star']!, kSymbols['mini_star']!,
      kSymbols['bell']!, kSymbols['mini_bell']!,
      kSymbols['watermelon']!, kSymbols['mini_watermelon']!,
      kSymbols['orange']!, kSymbols['mini_orange']!,
      kSymbols['lemon']!, kSymbols['mini_lemon']!,
      kSymbols['apple']!, kSymbols['mini_apple']!,
      kSymbols['cherry']!, kSymbols['mini_cherry']!,
    ]..shuffle(_rng);

    var poolIndex = 0;
    for (var i = 0; i < board.length; i++) {
      if (board[i] == null) {
        board[i] = pool[poolIndex];
        poolIndex = (poolIndex + 1) % pool.length;
      }
    }
    return board.cast<GameSymbol>();
  }

  /// Compute delay (ms) for the next light step, replicating the HTML curve:
  ///   - Steps 0..9: speed decreases from 120 ms to topSpeed (30 ms), -10 each.
  ///   - Cruise.
  ///   - Last `slowdownSteps` (15): speed += 10 + (intoSlowdown * 2).
  static int stepDelayMs({
    required int currentStep,
    required int totalSteps,
    int initialSpeed = 120,
    int topSpeed = 30,
    int slowdownSteps = 16,   // 16 pasos → ~1920 ms de frenado
  }) {
    int speed;
    if (currentStep < 10) {
      speed = max(topSpeed, initialSpeed - currentStep * 10);
    } else if (currentStep > totalSteps - slowdownSteps) {
      final intoSlowdown = currentStep - (totalSteps - slowdownSteps);
      speed = topSpeed + intoSlowdown * 2 + 10 * intoSlowdown;
    } else {
      speed = topSpeed;
    }
    return speed.clamp(20, 600);
  }

  /// Steps calibrated to match 'videoplayback (mp3cut.net) (1).wav' (5.652 s).
  /// N=125, slowdownSteps=16:
  ///   Accel  : ~750 ms  (pasos 0-9)
  ///   Crucero: ~2970 ms (pasos 10-108)  → velocidad maxima
  ///   Frenado: ~1920 ms (pasos 109-124) → empieza en ~3.72 s ("sonido 4")
  ///   Total  :  5640 ms  Δ = -12 ms vs audio (5652 ms)
  int randomTotalSteps() => 124 + _rng.nextInt(3); // 124-126 ≈ 5.61-5.67 s

  int randomSnakeSteps() => 60 + _rng.nextInt(20);

  int randomDoubleSteps() => 15 + _rng.nextInt(10);

  String pickSpecialEvent() {
    const events = ['snake', 'three_prizes', 'free_spin'];
    return events[_rng.nextInt(events.length)];
  }

  String pickDoubleWinner() => _rng.nextBool() ? 'left' : 'right';

  /// Returns up to 3 light-path indices (slot ids) where a prize can be paid
  /// (excludes once_more slots and slots without an active bet).
  List<int> pickThreePrizeTargets({
    required List<GameSymbol> board,
    required Map<String, int> selectedBets,
  }) {
    final candidates = <int>[];
    for (final slotId in kLightPath) {
      final s = board[slotId];
      if (s.isOnceMore) continue;
      if (s.prize == 0) continue;
      final bet = selectedBets[s.effectiveType] ?? 0;
      if (bet == 0) continue;
      candidates.add(slotId);
    }
    candidates.shuffle(_rng);
    return candidates.take(3).toList();
  }

  /// Resolve the snake's 3 cells (head + 2 trailing) given the final
  /// head position in the light path.
  List<int> snakePartsFromHead(int headLightIndex) {
    final n = kLightPath.length;
    return [
      headLightIndex,
      (headLightIndex - 1 + n) % n,
      (headLightIndex - 2 + n) % n,
    ];
  }

  /// Number of steps to reach a specific light index (always at least one
  /// full lap so the animation has visual weight).
  int stepsToTarget(int currentLightIndex, int targetLightIndex) {
    final n = kLightPath.length;
    var stepsToTarget = (targetLightIndex - currentLightIndex + n) % n;
    if (stepsToTarget == 0) stepsToTarget = n;
    return stepsToTarget + n * 2;
  }
}

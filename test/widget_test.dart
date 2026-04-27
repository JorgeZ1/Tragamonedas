// Smoke tests intentionally minimal — UI is heavily animation-driven and
// requires SQLite + animation timers, which are out of scope for this MVP.
import 'package:flutter_test/flutter_test.dart';

import 'package:tragamonedas/state/spin_engine.dart';

void main() {
  test('SpinEngine builds a 20-slot board with fixed BAR and ONCE MORE', () {
    final board = SpinEngine().buildBoard();
    expect(board.length, 20);
    expect(board[3].type, 'bar');
    expect(board[8].isOnceMore, true);
    expect(board[18].isOnceMore, true);
  });

  test('stepDelayMs accelerates then decelerates', () {
    final start = SpinEngine.stepDelayMs(currentStep: 0, totalSteps: 50);
    final cruise = SpinEngine.stepDelayMs(currentStep: 20, totalSteps: 50);
    final end = SpinEngine.stepDelayMs(currentStep: 49, totalSteps: 50);
    expect(start, greaterThan(cruise));
    expect(end, greaterThan(cruise));
  });
}

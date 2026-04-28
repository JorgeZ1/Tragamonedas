import 'package:audioplayers/audioplayers.dart';

/// Identifiers for every sound effect in the game.
enum SoundEffect {
  bet,        // Click al apostar
  betLimit,   // Error: límite de apuesta o sin crédito
  spin,       // Tick durante el giro
  win,        // Premio normal
  bigWin,     // Premio grande
  lose,       // Sin suerte
  doubleWin,  // Dobló y ganó
  doubleLose, // Dobló y perdió
  cashout,    // Cobrar ganancias
  special,    // Evento especial disparado
}

/// Maps every [SoundEffect] to its asset path inside the assets/ folder.
const Map<SoundEffect, String> _kAssets = {
  SoundEffect.bet:        'sounds/bet.wav',
  SoundEffect.betLimit:   'sounds/bet_limit.wav',
  SoundEffect.spin:       'sounds/spin.wav',
  SoundEffect.win:        'sounds/win.wav',
  SoundEffect.bigWin:     'sounds/big_win.wav',
  SoundEffect.lose:       'sounds/lose.wav',
  SoundEffect.doubleWin:  'sounds/double_win.wav',
  SoundEffect.doubleLose: 'sounds/double_lose.wav',
  SoundEffect.cashout:    'sounds/cashout.wav',
  SoundEffect.special:    'sounds/special.wav',
};

// ──────────────────────────────────────────────────────────
// Spin pool – keeps N independent AudioPlayers that rotate
// so rapid tick sounds never interrupt each other.
// ──────────────────────────────────────────────────────────
const int _kSpinPoolSize = 4;

class SoundService {
  bool muted = false;

  /// One AudioPlayer per non-spin effect.
  final Map<SoundEffect, AudioPlayer> _players = {};

  /// Rotating pool for the spin tick so rapid calls never
  /// call stop() on a player that is still starting up.
  final List<AudioPlayer> _spinPool = [];
  int _spinPoolIndex = 0;

  /// Throttle: minimum ms between spin ticks to avoid
  /// overloading the audio thread.
  static const int _spinThrottleMs = 60;
  int _lastSpinMs = 0;

  // ── init ────────────────────────────────────────────────

  Future<void> init() async {
    // Spin pool
    for (int i = 0; i < _kSpinPoolSize; i++) {
      final p = AudioPlayer();
      await p.setReleaseMode(ReleaseMode.stop);
      await p.setVolume(0.4);
      _spinPool.add(p);
    }

    // One player per non-spin effect
    for (final effect in SoundEffect.values) {
      if (effect == SoundEffect.spin) continue;
      final p = AudioPlayer();
      await p.setReleaseMode(ReleaseMode.stop);
      await p.setVolume(1.0);
      _players[effect] = p;
    }
  }

  // ── play ────────────────────────────────────────────────

  void play(SoundEffect effect) {
    if (muted) return;

    if (effect == SoundEffect.spin) {
      _playSpin();
      return;
    }

    final player = _players[effect];
    final path   = _kAssets[effect];
    if (player == null || path == null) return;

    // For one-shot effects: just call play() directly.
    // AudioPlayer with ReleaseMode.stop will restart cleanly
    // without the async stop→play race condition.
    try {
      player.play(AssetSource(path));
    } catch (_) {
      // Silently ignore audio errors so a sound glitch
      // never crashes the game.
    }
  }

  void _playSpin() {
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    if (nowMs - _lastSpinMs < _spinThrottleMs) return;
    _lastSpinMs = nowMs;

    // Pick the next idle player from the pool.
    final player = _spinPool[_spinPoolIndex];
    _spinPoolIndex = (_spinPoolIndex + 1) % _kSpinPoolSize;

    final path = _kAssets[SoundEffect.spin]!;
    try {
      player.play(AssetSource(path));
    } catch (_) {}
  }

  // ── dispose ─────────────────────────────────────────────

  void dispose() {
    for (final p in _players.values) { p.dispose(); }
    for (final p in _spinPool)        { p.dispose(); }
    _players.clear();
    _spinPool.clear();
  }
}

/// Global singleton – initialised once in main.dart.
final soundService = SoundService();

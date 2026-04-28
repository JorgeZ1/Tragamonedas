import 'package:audioplayers/audioplayers.dart';

/// Identifiers for every sound effect in the game.
enum SoundEffect {
  bet,        // Click al apostar
  betLimit,   // Error: límite de apuesta o sin crédito
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
  SoundEffect.win:        'sounds/win.wav',
  SoundEffect.bigWin:     'sounds/big_win.wav',
  SoundEffect.lose:       'sounds/lose.wav',
  SoundEffect.doubleWin:  'sounds/double_win.wav',
  SoundEffect.doubleLose: 'sounds/double_lose.wav',
  SoundEffect.cashout:    'sounds/cashout.wav',
  SoundEffect.special:    'sounds/special.wav',
};

class SoundService {
  bool muted = false;

  /// One AudioPlayer per one-shot effect.
  final Map<SoundEffect, AudioPlayer> _players = {};

  /// Dedicated looping player for the spin reel sound.
  AudioPlayer? _spinPlayer;

  // ── init ────────────────────────────────────────────────

  Future<void> init() async {
    // Spin player – uses the real machine recording (10.96 s),
    // long enough to cover any spin (5-8 s) without looping.
    _spinPlayer = AudioPlayer();
    await _spinPlayer!.setReleaseMode(ReleaseMode.stop);
    await _spinPlayer!.setVolume(0.85);

    // One-shot players
    for (final effect in SoundEffect.values) {
      final p = AudioPlayer();
      await p.setReleaseMode(ReleaseMode.stop);
      await p.setVolume(1.0);
      _players[effect] = p;
    }
  }

  // ── spin loop ───────────────────────────────────────────

  /// Call when the reel starts spinning.
  void startSpinLoop() {
    if (muted) return;
    try {
      // 'videoplayback (mp3cut.net).wav' = 5.748 s, coordinado con
      // la animacion (N=129 pasos = 5.760 s, Δ = +12 ms).
      // ReleaseMode.stop: el archivo suena una sola vez y stopSpinLoop()
      // lo corta los 12 ms finales si el audio no terminó antes.
      _spinPlayer?.play(AssetSource('sounds/videoplayback (mp3cut.net) (1).wav'));
    } catch (_) {}
  }

  /// Call when the reel stops.
  void stopSpinLoop() {
    try {
      _spinPlayer?.stop();
    } catch (_) {}
  }

  // ── one-shot effects ─────────────────────────────────────

  void play(SoundEffect effect) {
    if (muted) return;
    final player = _players[effect];
    final path   = _kAssets[effect];
    if (player == null || path == null) return;
    try {
      player.play(AssetSource(path));
    } catch (_) {}
  }

  // ── dispose ─────────────────────────────────────────────

  void dispose() {
    _spinPlayer?.dispose();
    for (final p in _players.values) { p.dispose(); }
    _players.clear();
  }
}

/// Global singleton – initialised once in main.dart.
final soundService = SoundService();

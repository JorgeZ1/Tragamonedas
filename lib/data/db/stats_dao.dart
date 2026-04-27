import 'database.dart';

class SpinRecord {
  final int totalBet;
  final int prize;
  final bool wasEvent;
  final String? eventType;

  SpinRecord({
    required this.totalBet,
    required this.prize,
    required this.wasEvent,
    this.eventType,
  });
}

class GameStats {
  final int totalSpins;
  final int totalBet;
  final int totalPrize;
  final int biggestWin;
  final int eventCount;
  final Map<String, int> eventBreakdown;

  GameStats({
    required this.totalSpins,
    required this.totalBet,
    required this.totalPrize,
    required this.biggestWin,
    required this.eventCount,
    required this.eventBreakdown,
  });

  /// RTP = SUM(prize) / SUM(total_bet). Free spins (total_bet == 0) excluded
  /// from the denominator so they don't artificially inflate RTP.
  double get rtp => totalBet == 0 ? 0 : totalPrize / totalBet;
}

class StatsDao {
  Future<void> recordSpin(SpinRecord r) async {
    final db = await AppDatabase.instance.db;
    await db.insert('spins', {
      'ts': DateTime.now().millisecondsSinceEpoch,
      'total_bet': r.totalBet,
      'prize': r.prize,
      'was_event': r.wasEvent ? 1 : 0,
      'event_type': r.eventType,
    });
  }

  Future<GameStats> read() async {
    final db = await AppDatabase.instance.db;
    final agg = await db.rawQuery('''
      SELECT
        COUNT(*) AS total_spins,
        COALESCE(SUM(total_bet), 0) AS total_bet,
        COALESCE(SUM(prize), 0) AS total_prize,
        COALESCE(MAX(prize), 0) AS biggest,
        COALESCE(SUM(was_event), 0) AS events
      FROM spins
      WHERE total_bet > 0
    ''');
    final row = agg.first;

    final byType = await db.rawQuery('''
      SELECT event_type, COUNT(*) AS c FROM spins
      WHERE event_type IS NOT NULL GROUP BY event_type
    ''');
    final breakdown = <String, int>{
      for (final r in byType) (r['event_type'] as String): (r['c'] as int),
    };

    return GameStats(
      totalSpins: (row['total_spins'] as int?) ?? 0,
      totalBet: (row['total_bet'] as int?) ?? 0,
      totalPrize: (row['total_prize'] as int?) ?? 0,
      biggestWin: (row['biggest'] as int?) ?? 0,
      eventCount: (row['events'] as int?) ?? 0,
      eventBreakdown: breakdown,
    );
  }

  Future<void> reset() async {
    final db = await AppDatabase.instance.db;
    await db.delete('spins');
  }
}

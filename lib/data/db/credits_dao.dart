import 'database.dart';

class CreditsDao {
  Future<int> read() async {
    final db = await AppDatabase.instance.db;
    final rows = await db.query('wallet', where: 'id = 1', limit: 1);
    if (rows.isEmpty) return 100;
    return rows.first['credits'] as int;
  }

  Future<void> write(int credits) async {
    final db = await AppDatabase.instance.db;
    await db.update('wallet', {'credits': credits}, where: 'id = 1');
  }

  Future<void> reset({int credits = 100}) async {
    final db = await AppDatabase.instance.db;
    await db.update('wallet', {'credits': credits}, where: 'id = 1');
  }
}

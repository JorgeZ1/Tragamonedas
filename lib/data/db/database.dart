import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  Database? _db;

  Future<Database> get db async {
    return _db ??= await _open();
  }

  Future<Database> _open() async {
    DatabaseFactory factory;
    String dbPath;

    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      factory = databaseFactoryFfi;
      final dir = await getApplicationSupportDirectory();
      dbPath = p.join(dir.path, 'tragamonedas.db');
    } else {
      factory = databaseFactory;
      final dir = await getApplicationDocumentsDirectory();
      dbPath = p.join(dir.path, 'tragamonedas.db');
    }

    return factory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, v) async {
          await db.execute('''
            CREATE TABLE wallet (
              id INTEGER PRIMARY KEY CHECK (id = 1),
              credits INTEGER NOT NULL
            )
          ''');
          await db.execute('''
            CREATE TABLE spins (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              ts INTEGER NOT NULL,
              total_bet INTEGER NOT NULL,
              prize INTEGER NOT NULL,
              was_event INTEGER NOT NULL,
              event_type TEXT
            )
          ''');
          await db.insert('wallet', {'id': 1, 'credits': 100});
        },
      ),
    );
  }
}

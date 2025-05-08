import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<int> insert(Map<String, dynamic> memo) async {
    final db = await database;
    return await db.insert('notes', memo);
  }

  static Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> update(Map<String, dynamic> memo) async {
    final db = await database;
    return await db.update(
      'notes', // テーブル名
      memo, // 更新するデータ
      where: 'id = ?', // 更新条件
      whereArgs: [memo['id']], // 条件に使う値
    );
  }

  static Future<List<Map<String, dynamic>>> select() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notes');
    if (maps.isNotEmpty) {
      return maps;
    } else {
      return [];
    }
  }

  static Future<Map<String, dynamic>> selectAt(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('notes', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return {};
    }
  }

  static Future<Database> _initDB() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'tabi_memo.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            body TEXT,
            date TEXT,
            imagePath TEXT,
            category TEXT,
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            ALTER TABLE notes ADD COLUMN category TEXT
          ''');
        }
      },
    );
  }
}

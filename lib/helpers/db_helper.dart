import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

class DBHelper {
  static const _userBookTable = 'user_books';

  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'books.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_books(id TEXT PRIMARY KEY, title TEXT, author TEXT, publisher TEXT, isbn TEXT, remarks TEXT, favorite INTEGER, lent INTEGER, lend_to TEXT, wish_list INTEGER)');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, Object>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<void> _update(String id, Map<String, dynamic> values) async {
    final db = await DBHelper.database();
    db.update(
      _userBookTable,
      values,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> updateFavorite(String id, bool isFavorite) async {
    _update(id, {'favorite': isFavorite ? 1 : 0});
  }

  static Future<void> updateLent(String id, bool isLent, String lendTo) async {
    _update(id, {'lent': isLent ? 1 : 0, 'lend_to': lendTo});
  }

  static Future<void> updateWishList(String id, bool isWishList) async {
    _update(id, {'wish_list': isWishList ? 1 : 0});
  }


  static Future<void> deleteBook(String id) async {
    final db = await DBHelper.database();
    db.delete(_userBookTable, where: 'id = ?', whereArgs: [id]);
  }
}

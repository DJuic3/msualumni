import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'home/store_data/account_model.dart';

// class DBHelper {
//   static Database? _db;
//   static const int _version = 1;
//   static const String _tableName = 'accounts';
//
//   static Future<void> initDb() async {
//     if (_db != null) {
//       debugPrint('not null db');
//       return;
//     }
//
//     try {
//       String _path = await getDatabasesPath() + 'account.db';
//       debugPrint('in database path');
//       _db = await openDatabase(_path, version: _version,
//           onCreate: (Database db, int version) async {
//             debugPrint('creating a new one');
//             return db.execute(
//               'CREATE TABLE $_tableName('
//                   'id INTEGER PRIMARY KEY AUTOINCREMENT, '
//                   'fullname STRING, country TEXT, date STRING, '
//                   'date STRING, empstatus STRING, '
//                   'graduationclass STRING, phone STRING, '
//                   'color INTEGER, '
//                   'isCompleted INTEGER)',
//             );
//           });
//       print('Database Created');
//     } catch (e) {
//       print('Error = $e');
//     }
//   }
//
//   static Future<int> insert(Account? account) async {
//     print('insert function called');
//     return await _db!.insert(_tableName, account!.toJson());
//   }
//
//   static Future<int> delete(Account account) async {
//     print('delete function called');
//     return await _db!.delete(_tableName, where: 'id = ?', whereArgs: [account.id]);
//   }
//   static Future<int> deleteAll() async {
//     print('delete All function called');
//     return await _db!.delete(_tableName);
//   }
//
//   static Future<List<Map<String, dynamic>>> query() async {
//     print('query function called');
//     return await _db!.query(_tableName);
//   }
//
//   static Future<int> update(int id) async {
//     print('update function called');
//     return await _db!.rawUpdate('''
//     UPDATE accounts
//     SET isCompleted = ?
//     WHERE id = ?
//    ''', [1, id]);
//   }
// }
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'home/store_data/account_model.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = 'accounts';

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }

    try {
      String _path = await getDatabasesPath() + '/account.db'; // Add the path separator
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (Database db, int version) async {
          await db.execute(

            'CREATE TABLE $_tableName('
                'id INTEGER PRIMARY KEY AUTOINCREMENT, '
                'fullname TEXT, '
                // 'entryDate STRING,'
                'date STRING, '
                'gender STRING,'
                'country TEXT, '
                'email STRING,'
                'entryDate STRING, '
                'graduationDate STRING, '
                'empstatus STRING, '
                'graduationclass STRING, '
                'phone STRING, '
                'color INTEGER, '
                'isCompleted INTEGER)',
          );
        },
      );
      print('Database Created');
    } catch (e) {
      print('Error = $e');
    }
  }

  static Future<int> insert(Account? account) async {
    if (_db == null) {
      await initDb(); // Initialize the database if it's null.
    }
    print('insert function called');
    return await _db!.insert(_tableName, account!.toJson());
  }

  static Future<int> delete(Account account) async {
    if (_db == null) {
      await initDb(); // Initialize the database if it's null.
    }
    print('delete function called');
    return await _db!.delete(_tableName, where: 'id = ?', whereArgs: [account.id]);
  }

  static Future<int> deleteAll() async {
    if (_db == null) {
      await initDb(); // Initialize the database if it's null.
    }
    print('delete All function called');
    return await _db!.delete(_tableName);
  }

  static Future<List<Map<String, dynamic>>> query() async {
    if (_db == null) {
      await initDb(); // Initialize the database if it's null.
    }
    print('query function called');
    return await _db!.query(_tableName);
  }

  static Future<int> update(int id) async {
    if (_db == null) {
      await initDb(); // Initialize the database if it's null.
    }
    print('update function called');
    return await _db!.rawUpdate('''
      UPDATE $_tableName
      SET isCompleted = ?
      WHERE id = ?
     ''', [1, id]);
  }
}

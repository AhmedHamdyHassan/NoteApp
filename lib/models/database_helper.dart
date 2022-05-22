import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  //Make Data fields for Most Used Fields in the code
  static const _dbName = 'myNotesDataBase.db';
  static const _dbVersion = 1;
  static const _tableName = 'Notes';
  static const _columnId = '_id';
  static const _columnTitle = 'title';
  static const _columnContant = 'contant';
  static const _columnDate = 'date';
  static const _columnColor = 'color';
  static const _columnIsUpdatedBefore = 'is_updated_before';

  //Make Singleton Class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  //Make Instanse of Database that will be used
  static Database? _database;

  Future<Database> get database async {
    // ignore: unnecessary_null_comparison
    if (_database != null) {
      return _database!;
    }
    _database = await initializeDatabase();
    return _database!;
  }

  //Intialize the Database
  initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    _database = await openDatabase(path, version: _dbVersion,
        onCreate: (Database db, int version) async {
      await db.execute('''
              CREATE TABLE $_tableName (
                $_columnId INTEGER PRIMARY KEY,
                $_columnTitle TEXT NOT NULL,
                $_columnContant TEXT NOT NULL,
                $_columnDate TEXT NOT NULL,
                $_columnColor TEXT NOT NULL,
                $_columnIsUpdatedBefore INTEGER NOT NULL )
             ''');
    });
  }

  //Database CRUD
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableName, row);
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    Database db = await instance.database;
    return await db.query(_tableName);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.update(_tableName, row,
        where: '$_columnId = ?', whereArgs: [row[_columnId]]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db
        .delete(_tableName, where: '$_columnId = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>> getById(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> singleElement = await db.query(_tableName);
    final returnedElement = singleElement.reduce((value, element) {
      if (value['_id'] == id) {
        return value;
      } else {
        return element;
      }
    });
    return returnedElement;
  }
}

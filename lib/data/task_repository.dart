import 'dart:io';

import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:sqflite/sqflite.dart' as sqlite;

import 'package:tech_demo_app/data/task.dart';

abstract class TaskRepository {
  Future<void> create(Task task);
  Future<List<Task>> readAll();
  Future<void> update(Task task);
  Future<void> delete(Task task);
}

class TaskRepositoryImpl implements TaskRepository {
  @override
  Future<void> create(Task task) async {
    final db = await _dbInstance();

    await db.insert(_tableName, task.toJson());
  }

  @override
  Future<List<Task>> readAll() async {
    final db = await _dbInstance();

    var queryResult = await db.query(_tableName);
    if (queryResult.isEmpty) {
      return [];
    }

    return queryResult.map((c) => Task.fromJson(c)).toList();
  }

  @override
  Future<void> update(Task task) async {
    final db = await _dbInstance();

    await db.update(_tableName, task.toJson(), where: 'id = ?', whereArgs: [task.id]);
  }

  @override
  Future<void> delete(Task task) async {
    final db = await _dbInstance();

    await db.delete(_tableName, where: 'id = ?', whereArgs: [task.id]);
  }

  /////////////////////////////////////////////////////////////////////////////////

  static String _tableName = 'tasks';

  Future<sqlite.Database> _dbInstance() async {
    if (_database != null) {
      return _database;
    }

    _database = await _initDatabase();
    return _database;
  }

  Future<sqlite.Database> _initDatabase() async {
    Directory documentsDirectory = await path_provider.getApplicationDocumentsDirectory();
    final dbPath = '${documentsDirectory.path}/data.db';

    return await sqlite.openDatabase(
      dbPath,
      version: 1,
      onOpen: (db) {},
      onCreate: (sqlite.Database db, int version) async {
        await db.execute(
          'CREATE TABLE $_tableName ('
            'id INTEGER PRIMARY KEY,'
            'name TEXT,'
            'description TEXT,'
            'creationDate TEXT,'
            'expirationDate TEXT,'
            'priority INTEGER'
          ')'
        );
    });
  }

  sqlite.Database _database;
}

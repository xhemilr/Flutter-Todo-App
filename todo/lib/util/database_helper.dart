import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo/model/nodo_item.dart';

class DatabaseHelper{

  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String TABLE_NOTODO = "notodoTable";
  final String COLUMN_ID = "id";
  final String COLUMN_ITEMNAME = "itemName";
  final String COLUMN_DATECREATED = "dateCreated";

  static Database _db;

  Future<Database> get db async{
    if(_db != null){
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "nodo_db.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int newVersion) async{
    await db.execute(
      "CREATE TABLE $TABLE_NOTODO"
          "("
            "$COLUMN_ID INTEGER PRIMARY KEY, "
            "$COLUMN_ITEMNAME TEXT, "
            "$COLUMN_DATECREATED TEXT"
          ")"
    );
  }

  Future<int> saveUser(NoDoItem item) async{
    var dbClient = await db;
    int res = await dbClient.insert(TABLE_NOTODO, item.toMap());
    return res;
  }

  Future<List> getAllUsers() async {
    var dbClient = await db;
    var result = dbClient.rawQuery('SELECT * FROM $TABLE_NOTODO ORDER BY $COLUMN_ITEMNAME ASC');
    return result;
  }

  Future<int> getCount() async{
    var dbClient = await db;
    return Sqflite.firstIntValue(
      await dbClient.rawQuery(
        'SELECT COUNT(*) FROM $TABLE_NOTODO'
      )
    );
  }

  Future<NoDoItem> getUser(int id) async{
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT * FROM $TABLE_NOTODO WHERE $COLUMN_ID=$id');
    if(result.length == 0) return null;
    return new NoDoItem.fromMap(result.first);
  }

  Future<int> deleteUser(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE_NOTODO, where: '$COLUMN_ID = ?', whereArgs: [id]);
  }

  Future<int> updateUser(NoDoItem item) async {
    var dbClient = await db;
    return await dbClient.update(TABLE_NOTODO, item.toMap(), where: '$COLUMN_ID = ?', whereArgs: [item.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
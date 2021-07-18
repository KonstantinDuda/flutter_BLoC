import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'root_task.dart';

class RootDBProvider {

  Database _db;
  RootDBProvider();

  static const String nameTableRoot = "ROOT_TASKS";

  Future<Database> get database async {
    WidgetsFlutterBinding.ensureInitialized();
    if(_db != null)
      return _db;

    _db = await initDB();
    return _db;
  }

  initDB() async {
    
    Directory dbPath = await getApplicationDocumentsDirectory();
    
    print("my_db initDB() dbPath == $dbPath");
    String path = join(dbPath.path, "BLoCListBuilder.db");
    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE IF NOT EXISTS $nameTableRoot ("
          "id INTEGER PRIMARY KEY,"
          "position INTEGER,"
          "text TEXT,"
          "allTaskCount INTEGER,"
          "completedTaskCount INTEGER," 
          "completedTaskProcent REAL)");
      },
    );
  }

  getTask(int id) async {
    print("my_db getTask() id == $id");
    final ndb = await database;
    var res = await ndb.query("$nameTableRoot", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? RootTask.fromMap(res.first) : Null;
  }

  Future<List<RootTask>> getAllTasks() async {
    final ndb = await database;
    print('getAllTasks()');
    var res = await ndb.query("$nameTableRoot");
    print("my_db getAllTask() res == $res");
    List<RootTask> list = 
      res.isNotEmpty ? res.map((t) => RootTask.fromMap(t)).toList() : [];
    return list;
  }

  newTask(RootTask newTask) async {
    final ndb = await database;
    var table = await ndb.rawQuery("SELECT MAX(id)+1 as id FROM $nameTableRoot");
    int id = table.first["id"];
    //if(id != null) {
    print("my_db newTask() id == $id");
    var raw = await ndb.rawInsert(
      "INSERT Into $nameTableRoot (id,position,text,allTaskCount,completedTaskCount,completedTaskProcent)"
      " VALUES (?,?,?,?,?,?)",
      [id, newTask.position, newTask.text, newTask.allTaskCount, newTask.completedTaskCount, newTask.completedTaskProcent]);
    return raw;
  }

  updateTask(RootTask newTask) async {
    print("my_db updateTask() newTask == $newTask");
    final ndb = await database;
    var res = await ndb.update("$nameTableRoot", newTask.toMap(),
      where: "id = ?", whereArgs: [newTask.id]);
    return res;
  }

  deleteTask(int id) async {
    print("my_db deleteTask() id == $id");
    final ndb = await database;
    return ndb.delete("$nameTableRoot", where: "id = ?", whereArgs: [id]);
  }

}
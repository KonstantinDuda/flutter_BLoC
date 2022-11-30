import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'root_task.dart';
import 'check_task.dart';

class RootDBProvider {
  Database _db;
  Database _dbCheck;
  RootDBProvider() {
    initDB();
    initDBcheck();
  }

  static const String nameTableRoot = "ROOT_TASKS";
  static const String nameTableCheck = "CHECK_TASKS";

  Future<Database> get database async {
    WidgetsFlutterBinding.ensureInitialized();
    if (_db != null) return _db;

    _db = await initDB();
    //_db = await initDBcheck();
    return _db;
  }

  Future<Database> get secondDatabase async {
    WidgetsFlutterBinding.ensureInitialized();
    if (_dbCheck != null) return _dbCheck;

    _dbCheck = await initDBcheck();
    return _dbCheck;
  }

  initDB() async {
    Directory dbPath = await getApplicationDocumentsDirectory();

    print("my_db initDB() dbPath == $dbPath");
    String path = join(dbPath.path, "BLoCListBuilder.db");
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
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

  initDBcheck() async {
    //Directory dbPath = await getApplicationDocumentsDirectory();
    var docDirectory = await getDatabasesPath();
    print("my_db initDB() dbPath == $docDirectory");
    String path = join(docDirectory/*dbPath.path*/, "BLoCListBuilder.db");
    return await openDatabase(
      path,
      version: 2,
      onOpen: (db) {},
      onUpgrade: (db, int oldVersion, int newVersion) async {
        await db.execute("CREATE TABLE IF NOT EXISTS $nameTableCheck ("
            "id INTEGER PRIMARY KEY,"
            "position INTEGER,"
            "text TEXT,"
            "rootID INTEGER,"
            "checkBox INTEGER)");
      },
    );
  }

  getTask(int id) async {
    print("my_db getTask() id == $id");
    final ndb = await database;
    if (ndb != null) {
      
      var res =
          await ndb.query("$nameTableRoot", where: "id = ?", whereArgs: [id]);
      return res.isNotEmpty ? RootTask.fromMap(res.first) : null;
    } else {
      await initDB();
      return null;
    }
  }

  getTaskCheck(int id) async {
    print("my_db getTaskCheck() id == $id");
    final ndb = await secondDatabase;
    if (ndb != null) {
      
      var res =
          await ndb.query("$nameTableCheck", where: "id = ?", whereArgs: [id]);
      return res.isNotEmpty ? CheckTask.fromMap(res.first) : null;
    } else {
      await initDBcheck();
      return null;
    }
  }

  Future<List<RootTask>> getAllTasks() async {
    final ndb = await database;
    print('getAllTasks()');
    if (ndb != null) {
      //final ndb = await database;
      var res = await ndb.query("$nameTableRoot");
      print("my_db getAllTask() res == $res");
      List<RootTask> list =
          res.isNotEmpty ? res.map((t) => RootTask.fromMap(t)).toList() : [];
      return list;
    } else {
      await initDB();
      return [];
    }
  }

  Future<List<CheckTask>> getGroupTasksCheck(int id) async {
    print('getGroupTasksCheck');
    if(id == null) {
      print('id == null');
      return [];
    } else {
      print('id != null');
      final ndb = await secondDatabase;
      if (ndb != null) {
        var list = await ndb
          .query("$nameTableCheck", where: "rootID = ?", whereArgs: [id]);

        List<CheckTask> tasks =
          list.isNotEmpty ? list.map((f) => CheckTask.fromMap(f)).toList() : [];
        print('tasks == $tasks');
        return tasks;
      } else {
        print('ndb == null');
        await initDBcheck();
        //return getGroupTasksCheck(id);
        return [];
      }
    }
  }

  newTask(RootTask task) async {
    final ndb = await database;
    if (ndb != null) {
      
      var table =
          await ndb.rawQuery("SELECT MAX(id)+1 as id FROM $nameTableRoot");
      var id;
      if (table.first["id"] == null)
        id = 1;
      else
        id = table.first["id"];
      print("my_db newTask() id == $id");
      var raw = await ndb.rawInsert(
          "INSERT Into $nameTableRoot (id,position,text,allTaskCount,completedTaskCount,completedTaskProcent)"
          " VALUES (?,?,?,?,?,?)",
          [
            id,
            task.position,
            task.text,
            task.allTaskCount,
            task.completedTaskCount,
            task.completedTaskProcent
          ]);
      return raw;
    } else {
      initDB();
      await newTask(task);
    }
  }

  newTaskCheck(CheckTask newTask) async {
    final ndb = await secondDatabase;
    if (ndb != null) {
      
      var table =
          await ndb.rawQuery("SELECT MAX(id)+1 as id FROM $nameTableCheck");
      int id;
      if (table.first["id"] == null)
        id = 1;
      else
        id = table.first["id"];
        /*int check;
      if(newTask.check == 1){
        check = 1;
      } else check = 0;*/
      print("my_db newTaskCheck() id == ${newTask.id}");
      var raw = await ndb.rawInsert(
          "INSERT Into $nameTableCheck (id,position,text,rootID,checkBox)"
          " VALUES (?,?,?,?,?)",
          [id, newTask.position, newTask.text, newTask.rootID, newTask.check]);
      return raw;
    } else {
      await initDBcheck();
      await newTaskCheck(newTask);
    }
  }

  updateTask(RootTask newTask) async {
    print("my_db updateTask() newTask == $newTask");
    final ndb = await database;
    if (ndb != null) {
      
      var res = await ndb.update("$nameTableRoot", newTask.toMap(),
          where: "id = ?", whereArgs: [newTask.id]);
      return res;
    } else {
      print('updateTask: ndb == null');
    }
  }

  updateTaskCheck(CheckTask newTask) async {
    print("my_db updateTaskCheck() newTask == $newTask");
    final ndb = await secondDatabase;
    if (ndb != null) {
      
      var res = await ndb.update("$nameTableCheck", newTask.toMap(),
          where: "id = ?", whereArgs: [newTask.id]);
      return res;
    } else {
      print('updateTaskCheck: ndb == null');
    }
  }

  deleteTask(int id) async {
    print("my_db deleteTask() id == $id");
    final ndb = await database;
    if (ndb != null) {
      
      return ndb.delete("$nameTableRoot", where: "id = ?", whereArgs: [id]);
    }
  }

  deleteTaskCheck(int id) async {
    print("my_db deleteTask() id == $id");
    final ndb = await secondDatabase;
    if (ndb != null) {
      
      return ndb.delete("$nameTableCheck", where: "id = ?", whereArgs: [id]);
    }
  }

  deleteGroupTasksCheck(int id) async {
    final ndb = await secondDatabase;
    if (ndb != null) {
      
      var list = await ndb
          .query("$nameTableCheck", where: "rootID = ?", whereArgs: [id]);

      if (list.length > 1)
        return ndb
            .rawDelete('DELETE FROM "$nameTableCheck" WHERE rootId = ?', [id]);
      else if (list.length == 1)
        return ndb
            .delete("$nameTableCheck", where: "rootId = ?", whereArgs: [id]);
    }
  }
}

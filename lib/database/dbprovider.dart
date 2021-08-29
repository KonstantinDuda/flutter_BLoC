import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'root_task.dart';
import 'chack_task.dart';

class RootDBProvider {
  Database _db;
  Database _dbChack;
  RootDBProvider() {
    initDB();
    initDBchack();
  }

  static const String nameTableRoot = "ROOT_TASKS";
  static const String nameTableChack = "CHACK_TASKS";

  Future<Database> get database async {
    WidgetsFlutterBinding.ensureInitialized();
    if (_db != null) return _db;

    _db = await initDB();
    //_db = await initDBchack();
    return _db;
  }

  Future<Database> get secondDatabase async {
    WidgetsFlutterBinding.ensureInitialized();
    if (_dbChack != null) return _dbChack;

    _dbChack = await initDBchack();
    return _dbChack;
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

  initDBchack() async {
    //Directory dbPath = await getApplicationDocumentsDirectory();
    var docDirectory = await getDatabasesPath();
    print("my_db initDB() dbPath == $docDirectory");
    String path = join(docDirectory/*dbPath.path*/, "BLoCListBuilder.db");
    return await openDatabase(
      path,
      version: 2,
      onOpen: (db) {},
      onUpgrade: (db, int oldVersion, int newVersion) async {
        await db.execute("CREATE TABLE IF NOT EXISTS $nameTableChack ("
            "id INTEGER PRIMARY KEY,"
            "position INTEGER,"
            "text TEXT,"
            "rootID INTEGER,"
            "chack INTEGER)");
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

  getTaskChack(int id) async {
    print("my_db getTaskChack() id == $id");
    final ndb = await secondDatabase;
    if (ndb != null) {
      
      var res =
          await ndb.query("$nameTableChack", where: "id = ?", whereArgs: [id]);
      return res.isNotEmpty ? ChackTask.fromMap(res.first) : null;
    } else {
      await initDBchack();
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

  Future<List<ChackTask>> getGroupTasksChack(int id) async {
    print('getGroupTasksChack');
    if(id == null) {
      print('id == null');
      return [];
    } else {
      print('id != null');
      final ndb = await secondDatabase;
      if (ndb != null) {
        var list = await ndb
          .query("$nameTableChack", where: "rootID = ?", whereArgs: [id]);

        List<ChackTask> tasks =
          list.isNotEmpty ? list.map((f) => ChackTask.fromMap(f)).toList() : [];
        print('tasks == $tasks');
        return tasks;
      } else {
        print('ndb == null');
        await initDBchack();
        //return getGroupTasksChack(id);
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

  newTaskChack(ChackTask newTask) async {
    final ndb = await secondDatabase;
    if (ndb != null) {
      
      var table =
          await ndb.rawQuery("SELECT MAX(id)+1 as id FROM $nameTableChack");
      int id;
      if (table.first["id"] == null)
        id = 1;
      else
        id = table.first["id"];
        /*int chack;
      if(newTask.chack == 1){
        chack = 1;
      } else chack = 0;*/
      print("my_db newTaskChack() id == ${newTask.id}");
      var raw = await ndb.rawInsert(
          "INSERT Into $nameTableChack (id,position,text,rootID,chack)"
          " VALUES (?,?,?,?,?)",
          [id, newTask.position, newTask.text, newTask.rootID, newTask.chack]);
      return raw;
    } else {
      await initDBchack();
      await newTaskChack(newTask);
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

  updateTaskChack(ChackTask newTask) async {
    print("my_db updateTaskChack() newTask == $newTask");
    final ndb = await secondDatabase;
    if (ndb != null) {
      
      var res = await ndb.update("$nameTableChack", newTask.toMap(),
          where: "id = ?", whereArgs: [newTask.id]);
      return res;
    } else {
      print('updateTaskChack: ndb == null');
    }
  }

  deleteTask(int id) async {
    print("my_db deleteTask() id == $id");
    final ndb = await database;
    if (ndb != null) {
      
      return ndb.delete("$nameTableRoot", where: "id = ?", whereArgs: [id]);
    }
  }

  deleteTaskChack(int id) async {
    print("my_db deleteTask() id == $id");
    final ndb = await secondDatabase;
    if (ndb != null) {
      
      return ndb.delete("$nameTableChack", where: "id = ?", whereArgs: [id]);
    }
  }

  deleteGroupTasksChack(int id) async {
    final ndb = await secondDatabase;
    if (ndb != null) {
      
      var list = await ndb
          .query("$nameTableChack", where: "rootID = ?", whereArgs: [id]);

      if (list.length > 1)
        return ndb
            .rawDelete('DELETE FROM "$nameTableChack" WHERE rootId = ?', [id]);
      else if (list.length == 1)
        return ndb
            .delete("$nameTableChack", where: "rootId = ?", whereArgs: [id]);
    }
  }
}

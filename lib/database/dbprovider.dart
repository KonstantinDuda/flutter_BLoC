import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'root_task.dart';
import 'check_task.dart';

class RootDBProvider {
  //Database _db;
  Database _dbNewRoot;
  //Database _dbCheck;
  Database _dbNewCheck;

  RootDBProvider() {
    //initDB();
    //initDBcheck();
    initDBnewRoot();
    initDBnewCheck();
  }

  //static const String nameTableRoot = "ROOT_TASKS";
  static const String nameTableNewRoot = "NEW_ROOT_TASKS";
  //static const String nameTableCheck = "CHECK_TASKS";
  static const String nameTableNewCheck = "NEW_CHECK_TASKS";

  /*Future<Database> get database async {
    WidgetsFlutterBinding.ensureInitialized();
    if (_db != null) return _db;

    _db = await initDB();
    //_db = await initDBcheck();
    return _db;
  }*/

  Future<Database> get rootDatabase async {
    WidgetsFlutterBinding.ensureInitialized();
    if (_dbNewRoot != null) return _dbNewRoot;

    _dbNewRoot = await initDBnewRoot();
    return _dbNewRoot;
  }  

  /*Future<Database> get secondDatabase async {
    WidgetsFlutterBinding.ensureInitialized();
    if (_dbCheck != null) return _dbCheck;

    _dbCheck = await initDBcheck();
    return _dbCheck;
  }*/

  Future<Database> get checkDatabase async {
    WidgetsFlutterBinding.ensureInitialized();
    if (_dbNewCheck != null) return _dbNewCheck;

    _dbNewCheck = await initDBnewCheck();
    return _dbNewCheck;
  }

  /*initDB() async {
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
  }*/

  /*initDBcheck() async {
    //Directory dbPath = await getApplicationDocumentsDirectory();
    var docDirectory = await getDatabasesPath();
    print("my_db initDBcheck() dbPath == $docDirectory");
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
  }*/

  initDBnewRoot() async {
    //var docDirectory = await getDatabasesPath();
    //print("my_db initDBnewRoot() dbPath == $docDirectory");
    //String path = join(docDirectory/*dbPath.path*/, "BLoCListBuilder.db");
    Directory dbPath = await getApplicationDocumentsDirectory();
    String path = join(dbPath.path, "BLoCListBuilder.db");
    return await openDatabase(
      path,
      version: 1, //3,
      onOpen: (db) {},
      //onUpgrade: (db, int oldVersion, int newVersion) async {
      onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE IF NOT EXISTS $nameTableNewRoot ("
            "id INTEGER PRIMARY KEY,"
            "position INTEGER,"
            "text TEXT,"
            "allTaskCount INTEGER,"
            "completedTaskCount INTEGER,"
            "completedTaskProcent REAL,"
            "rightMargin REAL,"
            "height REAL,"
            "updateRightMargin REAL,"
            "updateHeight REAL)");
      },
    );
  }

  initDBnewCheck() async {
    var docDirectory = await getDatabasesPath();
    print("my_db initDBnewCheck() dbPath == $docDirectory");
    String path = join(docDirectory/*dbPath.path*/, "BLoCListBuilder.db");
    return await openDatabase(
      path,
      version: 2, //4,
      onOpen: (db) {},
      onUpgrade: (db, int oldVersion, int newVersion) async {
        await db.execute("CREATE TABLE IF NOT EXISTS $nameTableNewCheck ("
            "id INTEGER PRIMARY KEY,"
            "position INTEGER,"
            "text TEXT,"
            "rootID INTEGER,"
            "checkBox INTEGER,"
            "rightMargin REAL,"
            "height REAL,"
            "updateRightMargin REAL,"
            "updateHeight REAL)");
      },
    );
  }

  /*getTask(int id) async {
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
  }*/

  /*getTaskCheck(int id) async {
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
  }*/

  getNewRootTask(int id) async {
    print("my_db getNewRootTask() id == $id");
    final ndb = await rootDatabase;
    if (ndb != null) {
      
      var res =
          await ndb.query("$nameTableNewRoot", where: "id = ?", whereArgs: [id]);
      return res.isNotEmpty ? RootTaskNew.fromMap(res.first) : null;
    } else {
      await initDBnewRoot();
      return null;
    }
  }

  getNewTaskCheck(int id) async {
    print("my_db getNewTaskCheck() id == $id");
    final ndb = await checkDatabase;
    if (ndb != null) {
      
      var res =
          await ndb.query("$nameTableNewCheck", where: "id = ?", whereArgs: [id]);
      return res.isNotEmpty ? CheckTaskNew.fromMap(res.first) : null;
    } else {
      await initDBnewCheck();
      return null;
    }
  }

  /*Future<List<RootTask>> getAllTasks() async {
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
  }*/

  /*Future<List<CheckTask>> getGroupTasksCheck(int id) async {
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
  }*/

  Future<List<RootTaskNew>> getAllNewRootTasks() async {
    final ndb = await rootDatabase;
    print('getAllRootTasks()');
    if (ndb != null) {
      //final ndb = await database;
      var res = await ndb.query("$nameTableNewRoot");
      print("my_db getAllRootTask() res == $res");
      List<RootTaskNew> list =
          res.isNotEmpty ? res.map((t) => RootTaskNew.fromMap(t)).toList() : [];
      return list;
    } else {
      await initDBnewRoot();
      return [];
    }
  }

  Future<List<CheckTaskNew>> getGroupNewTasksCheck(int id) async {
    print('getGroupNewTasksCheck');
    if(id == null) {
      print('id == null');
      return [];
    } else {
      print('id != null');
      final ndb = await checkDatabase;
      if (ndb != null) {
        var list = await ndb
          .query("$nameTableNewCheck", where: "rootID = ?", whereArgs: [id]);

        List<CheckTaskNew> tasks =
          list.isNotEmpty ? list.map((f) => CheckTaskNew.fromMap(f)).toList() : [];
        print('tasks == $tasks');
        return tasks;
      } else {
        print('ndb == null');
        await initDBnewCheck();
        //return getGroupTasksCheck(id);
        return [];
      }
    }
  }

  /*newTask(RootTask task) async {
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
  }*/

  /*newTaskCheck(CheckTask newTask) async {
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
  }*/

  newRootTask(RootTaskNew task) async {
    final ndb = await rootDatabase;
    if (ndb != null) {
      
      var table =
          await ndb.rawQuery("SELECT MAX(id)+1 as id FROM $nameTableNewRoot");
      var id;
      if (table.first["id"] == null)
        id = 1;
      else
        id = table.first["id"];
      print("my_db newRootTask() id == $id");
      var raw = await ndb.rawInsert(
          "INSERT Into $nameTableNewRoot (id,position,text,allTaskCount,completedTaskCount,completedTaskProcent,rightMargin,height,updateRightMargin,updateHeight)"
          " VALUES (?,?,?,?,?,?,?,?,?,?)",
          [
            id,
            task.position,
            task.text,
            task.allTaskCount,
            task.completedTaskCount,
            task.completedTaskProcent,
            task.rightMargin,
            task.height,
            task.updateRightMargin,
            task.updateHeight
          ]);
      return raw;
    } else {
      initDBnewRoot();
      await newRootTask(task);
    }
  }

  newCheckTask(CheckTaskNew newTask) async {
    final ndb = await checkDatabase;
    if (ndb != null) {
      
      var table =
          await ndb.rawQuery("SELECT MAX(id)+1 as id FROM $nameTableNewCheck");
      int id;
      if (table.first["id"] == null)
        id = 1;
      else
        id = table.first["id"];
      print("my_db newCheckTask() id == ${newTask.id}");
      var raw = await ndb.rawInsert(
          "INSERT Into $nameTableNewCheck (id,position,text,rootID,checkBox,rightMargin,height,updateRightMargin,updateHeight)"
          " VALUES (?,?,?, ?,?,?, ?,?,?)",
          [id, newTask.position, newTask.text, newTask.rootID, newTask.check, newTask.rightMargin, newTask.height, newTask.updateRightMargin, newTask.updateHeight]);
      return raw;
    } else {
      await initDBnewCheck();
      await newCheckTask(newTask);
    }
  }

  /*updateTask(RootTask newTask) async {
    print("my_db updateTask() newTask == $newTask");
    final ndb = await database;
    if (ndb != null) {
      
      var res = await ndb.update("$nameTableRoot", newTask.toMap(),
          where: "id = ?", whereArgs: [newTask.id]);
      return res;
    } else {
      print('updateTask: ndb == null');
    }
  }*/

  /*updateTaskCheck(CheckTask newTask) async {
    print("my_db updateTaskCheck() newTask == $newTask");
    final ndb = await secondDatabase;
    if (ndb != null) {
      
      var res = await ndb.update("$nameTableCheck", newTask.toMap(),
          where: "id = ?", whereArgs: [newTask.id]);
      return res;
    } else {
      print('updateTaskCheck: ndb == null');
    }
  }*/

  updateNewRootTask(RootTaskNew newTask) async {
    print("my_db updateRootTask() newTask == $newTask");
    final ndb = await rootDatabase;
    if (ndb != null) {
      
      var res = await ndb.update("$nameTableNewRoot", newTask.toMap(),
          where: "id = ?", whereArgs: [newTask.id]);
      return res;
    } else {
      print('updateRootTask: ndb == null');
    }
  }

  updateNewCheckTask(CheckTaskNew newTask) async {
    print("my_db updateNewCheckTask() newTask == $newTask");
    final ndb = await checkDatabase;
    if (ndb != null) {
      
      var res = await ndb.update("$nameTableNewCheck", newTask.toMap(),
          where: "id = ?", whereArgs: [newTask.id]);
      return res;
    } else {
      print('updateTaskNewCheck: ndb == null');
    }
  }

  /*deleteTask(int id) async {
    print("my_db deleteTask() id == $id");
    final ndb = await database;
    if (ndb != null) {
      
      return ndb.delete("$nameTableRoot", where: "id = ?", whereArgs: [id]);
    }
  }*/

  /*deleteTaskCheck(int id) async {
    print("my_db deleteTask() id == $id");
    final ndb = await secondDatabase;
    if (ndb != null) {
      
      return ndb.delete("$nameTableCheck", where: "id = ?", whereArgs: [id]);
    }
  }*/

  deleteNewRootTask(int id) async {
    print("my_db deleteRootTask() id == $id");
    final ndb = await rootDatabase;
    if (ndb != null) {
      
      return ndb.delete("$nameTableNewRoot", where: "id = ?", whereArgs: [id]);
    }
  }

  deleteNewCheckTask(int id) async {
    print("my_db deleteTask() id == $id");
    final ndb = await checkDatabase;
    if (ndb != null) {
      
      return ndb.delete("$nameTableNewCheck", where: "id = ?", whereArgs: [id]);
    }
  }

  /*deleteGroupTasksCheck(int id) async {
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
  }*/

  deleteGroupNewCheckTasks(int id) async {
    final ndb = await checkDatabase;
    if (ndb != null) {
      
      var list = await ndb
          .query("$nameTableNewCheck", where: "rootID = ?", whereArgs: [id]);

      if (list.length > 1)
        return ndb
            .rawDelete('DELETE FROM "$nameTableNewCheck" WHERE rootId = ?', [id]);
      else if (list.length == 1)
        return ndb
            .delete("$nameTableNewCheck", where: "rootId = ?", whereArgs: [id]);
    }
  }
}

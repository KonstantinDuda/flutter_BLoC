import 'dart:io';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';

class ThemeStateFile {
  Future<String> get _localPath async {
    WidgetsFlutterBinding.ensureInitialized();
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    WidgetsFlutterBinding.ensureInitialized();
    final path = await _localPath;
    return File('$path/state.txt');
  }

  Future<int> readState() async {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      final file = await _localFile;

      final contents = await file.readAsString();
      int result = int.parse(contents);
      //print('readState return = $result');
      return result;
    } catch (e) {
      return 0;
    }
  }

  Future<File> writeState(int state) async {
    final file = await _localFile;
    int a = await readState();
    //print('state == $state');
    //print(a);

    if(state == 0)
      return file.writeAsString('$a');
    else {
      if(a == 0)
        return file.writeAsString('1');
      else
        return file.writeAsString('0');
    }
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import '../database/theme_state_file.dart';

class ThemeCubit extends Cubit<ThemeData> {
  // Передаем родительскому классу стартовое значение
  ThemeCubit() : super(_lightTheme);

  static final _lightTheme = ThemeData(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
    ),
    /*buttonTheme: const ButtonThemeData(
      buttonColor: Colors.blue,
    ),*/
    /*iconTheme: const IconThemeData(
      color: Colors.black,
    ),*/
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.white,
        fontSize: 28.0,
      ),
      headline5: TextStyle(
        color: Colors.black,
        fontSize: 26.0,
      ),
    ),
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    primaryColorDark: Colors.orange,
    accentColor: Colors.blue,
  );

  static final _darkTheme = ThemeData(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.black,
    ),
    /*buttonTheme: ButtonThemeData(
      buttonColor: Colors.orange,
    ),*/
    /*iconTheme: const IconThemeData(
      color: Colors.white,
    ),*/
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.black,
        fontSize: 28.0,
      ),
      headline5: TextStyle(
        color: Colors.white,
        fontSize: 26.0,
      ),
    ),
    brightness: Brightness.dark,
    primaryColor: Colors.orange,
    primaryColorDark: Colors.blue,
    accentColor: Colors.orange,
  );

  void toggleTheme() {
    //print('toggletheme?');
    //state.brightness == Brightness.dark ? ThemeStateFile().writeState(0) : ThemeStateFile().writeState(1);
    emit(state.brightness == Brightness.dark ? _lightTheme : _darkTheme);
  }
}
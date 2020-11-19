import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeData> {
  // Передаем родительскому классу стартовое значение
  ThemeCubit() : super(_lightTheme);

  static final _lightTheme = ThemeData(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
    ),
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.white,
        fontSize: 28.0,
      ),
    ),
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    accentColor: Colors.blue,
  );

  static final _darkTheme = ThemeData(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.black,
    ),
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.black,
        fontSize: 28.0,
      ),
    ),
    brightness: Brightness.dark,
    primaryColor: Colors.orange,
    accentColor: Colors.orange,
  );

  void toggleTheme() {
    emit(state.brightness == Brightness.dark ? _lightTheme : _darkTheme);
  }
}
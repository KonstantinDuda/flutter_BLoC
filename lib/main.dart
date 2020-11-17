import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/counter_observer.dart';
import 'app.dart';


void main() {
  Bloc.observer = CounterObserver(); // Создается для реагирования на все переходы
    // Блок делегат. По сути наблюдает за всеми изменениями состояний в приложении
    // Создается наследованием от BlocObserver 
    // и перегрузкой метода onChange()
  runApp(const CounterApp());
}
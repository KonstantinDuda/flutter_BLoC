import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/counter_cubit.dart';
import 'view/counter_view.dart';

// Наследуемся от Материала и передаем ему ключи и
//    домашний виджет Счетчик
class CounterApp extends MaterialApp {
  const CounterApp({Key key}) : super (key: key, home: const CounterPage());
}

// Наследуемся от статического виджета
// Передаем ему ключи
// Перегружаем функцию рисования в которой
//    возвращаем Блок провайдер который создает
//    наш счетчик-кубит класс ( который
//    отвечает за изменение состояний )
//    и имеет дочерний виджет отвечающий за представление
class CounterPage extends StatelessWidget {

  const CounterPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: CounterView(),
    );
  }
}
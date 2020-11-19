import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/counter_bloc.dart';
import '../bloc/theme_cubit.dart';

class CounterPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter on SwitchTheme')),
      drawer: Drawer(
        child: Center( 
          child: Container(
            width: 50.0,
            height: 50.0,
            child: FloatingActionButton(
              mini: true,
              child: Icon(Icons.brightness_6),
              onPressed: () => context.read<ThemeCubit>().toggleTheme(),
            ),
          ),
        ),
      ),
      // Блок строитель обрабатывает создание виджета в 
      // ответ на новое состояние. 
      // (потенциально) Функция строитель может 
      // вызываться несколько раз.
      // Является дженериком. Использует класс управляющий 
      // состоянием и состояние как второй елемент
      body: BlocBuilder<CounterBloc, int>(
        builder: (_, count) {
          return Center(
            child: Container(
              //width: 50.0,
              //height: 50.0,
              child: FloatingActionButton(
                child: Center(
                child: Text(
                // Выводим каунт которым управляет и который
                // прослушивает Блок строитель
                '$count',
                // Указываем стиль текста, чтоб менялся цвет
                // когда меняет тему приложения
                style: Theme.of(context).textTheme.headline6,
                ),),
                onPressed: (){},
              ),
              //),
            ),
          );
        },
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () =>
                context.read<CounterBloc>().add(CounterEvent.increment),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              child: const Icon(Icons.remove),
              onPressed: () => 
                // Благодаря тому, что у нас есть доступ к блоку счетчика
                // так-как мы добавили его в провайдере
                // теперь мы можем считать из контекста с указанием 
                // класса управляющего счетчиком и добавить событие
                context.read<CounterBloc>().add(CounterEvent.decrement),
            ),
          ),/*
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              child: const Icon(Icons.brightness_6),
              // Благодаря тому, что у нас есть доступ к кубиту темы
              // так-как мы добавили его в провайдере
              // теперь мы можем считать из контекста с указанием 
              // класса управляющего темой и вызвать событие
              onPressed: () => context.read<ThemeCubit>().toggleTheme(),
            ),
          ),*/
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              backgroundColor: Colors.red,
              child: const Icon(Icons.error),
              onPressed: () => context.read<CounterBloc>().add(null),
            ),
          ),
        ],
      ),
    );
  }
}
    
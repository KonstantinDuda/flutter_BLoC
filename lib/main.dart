import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'view/counter_page.dart';
import 'bloc/observer.dart';
import 'bloc/theme_cubit.dart';
import 'bloc/counter_bloc.dart';

void main() {
  // Обьявляем, что нужно использовать наш Делегат (Observer)
  Bloc.observer = SimpleBlocObserver();
  runApp(App());
}

// Создаем класс - виджет
class App extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    // Поставщик предоставляет блок своим дочерним елементам
    // через контекст. Он используется как виджет внедрения
    // зависимостей. Чаще используется для создания новых
    // блоков, которые будут доступны остальному в поддереву.
    // Если отвечает за создание блока, автоматически 
    // обрабатывает закрытие блока
    // Может использоваться для предоставления существующего 
    // блока новой части дерева виджетов
    return BlocProvider(
      // Возвращает ThemeCubit через context
      create: (_) => ThemeCubit(),
      // Блок строитель обрабатывает создание виджета в 
      // ответ на новое состояние. (потенциально) Функция строитель может 
      // вызываться несколько раз.
      // Является дженериком. Использует класс управляющий 
      // состоянием и состояние как второй елемент (в данном случае)
      child: BlocBuilder<ThemeCubit, ThemeData>(
        // При необходимости можно указать  кубит, ограниченный
        // одним виджетом и недоступный через провайдер и текущий контекст 
        builder: (_, theme) {
          return MaterialApp(
            theme: theme,
            home: BlocProvider(
              // Добавляем в контекст блок счетчика
              create: (_) => CounterBloc(),
              child: CounterPage(),
            ),
          );
        },
      ),
    );
  }
}
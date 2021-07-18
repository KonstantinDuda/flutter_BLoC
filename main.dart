import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_sheduler/bloc/chack_task_bloc.dart';


import 'view/horizontal_page.dart';
import 'view/root_page.dart';
import 'view/chack_page.dart';
import 'view/my_dialog.dart';
import 'view/update_page.dart';

import 'bloc/root_task_bloc.dart';
import 'bloc/chack_task_bloc.dart';
//import 'bloc/chack_task_bloc.dart';
import 'bloc/observer.dart';
import 'bloc/theme_cubit.dart';
import 'bloc/provider_bloc.dart';

import 'database/root_task.dart';
import 'database/chack_task.dart';
import 'database/root_task_event.dart';
import 'database/chack_task_event.dart';

void main() {
  // Обьявляем, что нужно использовать наш Делегат (Observer)
  Bloc.observer = SimpleBlocObserver();
  runApp(
    BlocProvider(
      create: (context) => ProviderBloc(),
      child: App(),
    ),
    );
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
      // TODO Изменить или переместить
      create: (_) => TaskBloc(list: new List<RootTask>())..add(RootTaskLoadSuccessEvent()),//CounterBloc(), 
      child: BlocProvider(
        create: (_) => ChackTaskBloc(list: new List<ChackTask>())..add(ChackTaskLoadSuccessEvent(null)),
        child: BlocProvider(
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
            home: BlocBuilder<ProviderBloc, ProviderState>(
              builder: (_, state) {
                if(state is RootState) {
                  print("Root State");
                  return RootPage();
                } else if(state is ChackState) {
                  print("ChackState");
                  return ChackPage(state.task);
                } else if(state is UpdateState) {
                  print("Update State");
                  return UpdatePage(state.rootTask, state.chackTask);
                } else if(state is DialogState) {
                  print("Dialog State");
                  return MyDialog(state.changeObj, state.rootTask, state.chackTask);
                }
              }//=> state is RootState ? HorizontalPage() /*RootPage()*/ : ChackPage(),
            ),
            /*routes: {
              '/': (context) {
                return /*BlocProvider(
                  create: (_) => CounterBloc(),
                  child:*/ RootPage();//,
                //);
              },
              '/chackPage': (context) {
                return /*BlocProvider(
                  create: (_) => CounterBloc(),
                  child:*/ ChackPage();//,
                //);
              },
            },
            initialRoute: '/',*/
            theme: theme,
            /*home: BlocProvider(
              // Добавляем в контекст блок счетчика
              create: (_) => CounterBloc(),
              child: CounterPage(),
            ),*/
          );
        },
      ),
      ),
      ),
    );
  }
}
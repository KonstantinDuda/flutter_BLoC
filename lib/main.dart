import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:task_sheduler/bloc/check_task_bloc.dart';


//import 'view/horizontal_page.dart';
import 'view/root_page.dart';
import 'view/check_page.dart';
import 'view/my_dialog.dart';
import 'view/update_page.dart';

import 'bloc/root_task_bloc.dart';
import 'bloc/check_task_bloc.dart';
//import 'bloc/check_task_bloc.dart';
import 'bloc/observer.dart';
import 'bloc/theme_cubit.dart';
import 'bloc/provider_bloc.dart';

//import 'database/root_task.dart';
//import 'database/check_task.dart';
import 'database/root_task_event.dart';
import 'database/check_task_event.dart';
import 'database/theme_state_file.dart';


void main() {
  // Обьявляем, что нужно использовать наш Делегат (Observer)
  Bloc.observer = SimpleBlocObserver();
  
  void getState() async {
    int themeState = await ThemeStateFile().readState();
    runApp(
    BlocProvider(
      create: (context) => ProviderBloc(),
      child: App(themeState),
    ),
    );
  }

  getState();
  //ThemeStateFile();
  
}

// Создаем класс - виджет
class App extends StatelessWidget {
  final themeState;
  App(this.themeState);
  //int _state = 0;
  //int _state;
  /*void fn(BuildContext context) async {
    print('fn');
      await ThemeStateFile().readState().then((value) {
        print('value == $value');
        if(value > 0) {
          print('value > 0; value == $value');
          BlocProvider.of<ThemeCubit>(context).toggleTheme();
          //ThemeStateFile().writeState(1);
          }
        return value;
      });
      //print('th == $_state');
    }*/
  
  /*Future<ThemeCubit> _calculateThemeCubit() async {
    _state = await ThemeStateFile().readState();
    if(_state == 0)
      return ThemeCubit();
    else
      return ThemeCubit()..toggleTheme();
  }*/

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
      create: (_) => TaskBloc(list: [] /*new List<RootTask>()*/)..add(RootTaskLoadSuccessEvent()),//CounterBloc(), 
      child: BlocProvider(
        create: (_) => CheckTaskBloc(list: [] /*new List<CheckTask>()*/)..add(CheckTaskLoadSuccessEvent(null)),
        child: BlocProvider(
      // Возвращает ThemeCubit через context
      create: (_) {

        //fn(context);
        if(themeState == 0)
          return ThemeCubit();
        else 
          return ThemeCubit()..toggleTheme();
        },
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
                } else if(state is CheckState) {
                  print("CheckState");
                  return CheckPage(state.task);
                } else if(state is UpdateState) {
                  print("Update State");
                  return UpdatePage(state.rootTask, state.checkTask);
                } else if(state is DialogState) {
                  print("Dialog State");
                  return MyDialog(state.changeObj, state.rootTask, state.checkTask);
                } else {return RootPage();}
              }//=> state is RootState ? HorizontalPage() /*RootPage()*/ : CheckPage(),
            ),
            /*routes: {
              '/': (context) {
                return /*BlocProvider(
                  create: (_) => CounterBloc(),
                  child:*/ RootPage();//,
                //);
              },
              '/checkPage': (context) {
                return /*BlocProvider(
                  create: (_) => CounterBloc(),
                  child:*/ CheckPage();//,
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
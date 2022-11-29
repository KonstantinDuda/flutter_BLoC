import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'view/loading_page.dart';

import 'view/root_page.dart';
import 'view/check_page.dart';
import 'view/my_dialog.dart';
import 'view/update_page.dart';

import 'bloc/root_task_bloc.dart';
import 'bloc/check_task_bloc.dart';
//import 'bloc/observer.dart';

import 'bloc/theme_cubit.dart';
import 'bloc/provider_bloc.dart';

import 'database/root_task_event.dart';
import 'database/check_task_event.dart';
import 'database/theme_state_file.dart';
import 'view/view_calculate_check_task.dart';
import 'view/view_calculate_root_task.dart';


void main() {
  
  void getState() async {
    int themeState = await ThemeStateFile().readState();
    //BlocOverrides.runZoned(
    /*() =>*/runApp(
    BlocProvider(
      create: (context) => ProviderBloc(),
      child: App(themeState),
    ),
    );
    //blocObserver: SimpleBlocObserver(),);
  }

  getState();
  //ThemeStateFile();
  
}

// Создаем класс - виджет
class App extends StatelessWidget {
  final themeState;
  App(this.themeState);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskBloc(list: [] )..add(RootTaskLoadSuccessEvent()),
      child: BlocProvider(
        create: (_) => CheckTaskBloc(list: [] )..add(CheckTaskLoadSuccessEvent(null)),
        child: BlocProvider(
      // Возвращает ThemeCubit через context
      create: (_) {
        if(themeState == 0)
          return ThemeCubit();
        else 
          return ThemeCubit()..toggleTheme();
        },
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (_, theme) {
          return MaterialApp(
            home: BlocBuilder<ProviderBloc, ProviderState>(
              builder: (_, state) {
                if(state is LoadingState) {
                  print("LoadingPage");
                  return LoadingPage();
                } else if(state is RootState) {
                  print("Root State");
                  return RootPageState();
                } else if(state is ViewCalculateRootState) {
                  print("ViewCalculateRootState");
                  return ViewCalculateRootTaskPageState(state.task);
                } else if(state is CheckState) {
                  print("CheckState");
                  return CheckPage(state.task);
                } else if(state is ViewCalculateCheckState) {
                  print("ViewCalculateCheckState");
                  return ViewCalculateCheckTaskPageState(state.task, state.parentTask);
                } else if(state is UpdateState) {
                  print("Update State");
                  return UpdatePage(state.rootTask, state.checkTask);
                } else if(state is DialogState) {
                  print("Dialog State");
                  return MyDialog(state.changeObj, state.rootTask, state.checkTask);
                } else {return RootPageState();}
              }
            ),
            theme: theme,
          );
        },
      ),
      ),
      ),
    );
  }
}
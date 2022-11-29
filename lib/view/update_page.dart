import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/root_task_bloc.dart';
import '../bloc/provider_bloc.dart';
import '../database/root_task.dart';
import '../database/root_task_event.dart';
import '../database/root_task_state.dart';

import '../bloc/check_task_bloc.dart';
import '../database/check_task.dart';
import '../database/check_task_event.dart';
import '../database/check_task_state.dart';
//import '../';

class UpdatePage extends StatelessWidget {
  final RootTask rootTask;
  final CheckTask checkTask;
  UpdatePage(this.rootTask, this.checkTask);

  @override
  Widget build(BuildContext context) {
    print("build update page");
    print("Update Task == ${rootTask.toMap()}");
    return WillPopScope(
      onWillPop: () async { 
        //BlocProvider.of<ProviderBloc>(context).add(RootEvent());
        checkTask == null 
          ? context.read<ProviderBloc>().add(RootEvent())
          : context.read<ProviderBloc>().add(CheckEvent(rootTask));
      return false; },
      child: checkTask == null ? checkTaskIsNull(rootTask) : checkTaskIsNotNull(rootTask, checkTask)
      );
    /*if (checkTask == null) {
      return checkTaskIsNull(rootTask);
    } else {
      return checkTaskIsNotNull(rootTask, checkTask);
    }*/
  }

  myFloatingActionButton(BuildContext context, bool checkTaskIsNull,
      CheckTask check, RootTask root) {
    return Container(
      // При перемещении на телефоне активный обьект перерисовывается в синий цвет...
      child: Column(
        //Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
            child: FloatingActionButton(
              onPressed: () {
                if (checkTaskIsNull == true) {
                  //BlocProvider.of<ProviderBloc>(context).add(RootEvent());
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 3),
                      content: Row(
                        children: <Widget>[
                          CircularProgressIndicator(
                            //value: 0.4,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                              child: Text("Удалить ${root.text}?"),
                            ),
                          ),
                          TextButton(
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(
                                  Size(80.0, 50.0)),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).primaryColor),
                            ),
                            child: Text("Да"),
                            onPressed: () {
                              //BlocProvider.of<TaskBloc>(context)
                                //  .add(RootTaskDeletedEvent(root.id));
                              //print('delete ${root.toMap()}');
                              context.read<TaskBloc>().add(RootTaskDeletedEvent(root.id));
                              ScaffoldMessenger.of(context)
                                  .removeCurrentSnackBar();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  //BlocProvider.of<ProviderBloc>(context).add(CheckEvent(rootTask));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 3),
                      content: Row(
                        children: <Widget>[
                          CircularProgressIndicator(
                            //value: 0.4,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                              child: Text("Удалить ${check.text}?"),
                            ),
                          ),
                          TextButton(
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(
                                  Size(80.0, 50.0)),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).primaryColor),
                            ),
                            child: Text("Да"),
                            onPressed: () {
                              //BlocProvider.of<CheckTaskBloc>(context)
                                //  .add(CheckTaskDeletedEvent(check.id));

                              context.read<CheckTaskBloc>().add(CheckTaskDeletedEvent(check.id));
                              ScaffoldMessenger.of(context)
                                  .removeCurrentSnackBar();
                              context.read<TaskBloc>().add(RootTaskUpdateEvent(root.id, 0, root.text, 0, -1));

                              //BlocProvider.of<TaskBloc>(context).add(
                                //  RootTaskUpdateEvent(
                                  //    root.id, 0, root.text, 0, -1));
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
              child: Icon(Icons.delete_forever_outlined),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget> [
          Container(
            margin: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
            child: FloatingActionButton(
              onPressed: () {
                print('press Up');
                if (checkTaskIsNull == true) {
                  //BlocProvider.of<TaskBloc>(context).add(RootTaskUpdateEvent(
                    //  rootTask.id, -1, rootTask.text, 0, 0));
                  context.read<TaskBloc>().add(RootTaskUpdateEvent(rootTask.id, -1, rootTask.text, 0, 0));
                } else {
                  //BlocProvider.of<CheckTaskBloc>(context).add(
                    //  CheckTaskUpdateEvent(
                      //    checkTask.id, -1, checkTask.text, false));
                  context.read<CheckTaskBloc>().add(CheckTaskUpdateEvent(checkTask.id, -1, checkTask.text, false));
                }
              },
              child: Icon(Icons.arrow_upward),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
            child: FloatingActionButton(
              onPressed: () {
                print('press Bottom');
                if (checkTaskIsNull == true) {
                  //BlocProvider.of<TaskBloc>(context).add(
                    //  RootTaskUpdateEvent(rootTask.id, 1, rootTask.text, 0, 0));
                  context.read<TaskBloc>().add(RootTaskUpdateEvent(rootTask.id, 1, rootTask.text, 0, 0));
                
                } else {
                  //BlocProvider.of<CheckTaskBloc>(context).add(
                    //  CheckTaskUpdateEvent(
                      //    checkTask.id, 1, checkTask.text, false));
                  context.read<CheckTaskBloc>().add(CheckTaskUpdateEvent(checkTask.id, 1, checkTask.text, false));
                
                }
              },
              child: Icon(Icons.arrow_downward),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
            child: FloatingActionButton.extended(
              onPressed: () {
                if (checkTaskIsNull == true) {
                  print('root rewrite');
                  //BlocProvider.of<ProviderBloc>(context)
                    //  .add(DialogEvent(true, rootTask, null));
                  context.read<ProviderBloc>().add(DialogEvent(true, rootTask, null));
                } else {
                  print('check rewrite');
                  //BlocProvider.of<ProviderBloc>(context)
                    //  .add(DialogEvent(true, rootTask, checkTask));
                  context.read<ProviderBloc>().add(DialogEvent(true, rootTask, checkTask));
                }
              },
              label: Text('Редактировать'),
              icon: Icon(Icons.create),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  checkTaskIsNull(RootTask rootTask) {
    print('check task is null');
    return 
    BlocBuilder<TaskBloc, RootTaskState>(builder: (context, state) {
      List<RootTask> tasks;
      if (state is RootTaskLoadSuccessState) {
        //print('tasks = state.tasks');

        if (state.tasks == null) {
          tasks = [];
          //print('tasks == null; now $tasks');
        } else
          tasks = state.tasks;
      } else {
        //print('tasks = [] because state is not a TaskLoadSuccessState');
        tasks = [];
      }
      //print('tasks == $tasks');
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).textTheme.headline6.color,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              //BlocProvider.of<ProviderBloc>(context).add(RootEvent());
              context.read<ProviderBloc>().add(RootEvent());
            },
          ),
          title: Text('Изменить ${rootTask.text}'),
        ),
        body: ListView.builder(
            itemCount: tasks == []
                ? 0
                : tasks.length, //.db.getAllTask().length,//MyDB.db.myDB.length,
            itemBuilder: (context, index) {
              print("${tasks[index].toMap()} == ${rootTask.toMap()}  ?");
              //print("ListView.builder");
              return GestureDetector(
                onTap: () {
                  print(tasks[index].id);
                  print(tasks[index].text);
                  //BlocProvider.of<ProviderBloc>(context)
                    //  .add(UpdateEvent(tasks[index], null));
                  context.read<ProviderBloc>().add(UpdateEvent(tasks[index], null));
                },
                onLongPress: () {
                  print("Long press on ${tasks[index].id}");
                  //setState(() { borderColor = Colors.orange; });
                },
                child: Container(
                  //height: MyDB.db.myDB[index].heightContainer,    //62, // Не должно быть константным // Задается в обьекте
                  //width: 500,
                  margin: EdgeInsets.fromLTRB(20.0, 5.0, 10.0, 5.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: tasks[index].id == rootTask.id
                          ? Theme.of(context).primaryColorDark
                          : Theme.of(context).primaryColor,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                    color: Theme.of(context).textTheme.headline6.color,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: Text(
                                  " ${tasks[index].text}",
                                  style: tasks[index].id == rootTask.id
                                      ? TextStyle(fontWeight: FontWeight.bold)
                                      : TextStyle(
                                          fontWeight: FontWeight.normal),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
        floatingActionButton: myFloatingActionButton(context,
            true, null, rootTask), 
      );
    });
  }

  checkTaskIsNotNull(RootTask rootTask, CheckTask checkTask) {
    print('check task is NOT null');
    return BlocBuilder<CheckTaskBloc, CheckTaskState>(
        builder: (context, state) {
      List<CheckTask> tasks;
      if (state is CheckTaskLoadSuccessState) {
        //print('tasks = state.tasks');

        if (state.tasks == null) {
          tasks = [];
          //print('tasks == null; now $tasks');
        } else
          tasks = state.tasks;
      } else {
        //print('tasks = [] because state is not a TaskLoadSuccessState');
        tasks = [];
      }
      //print('tasks == $tasks');
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).textTheme.headline6.color,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              //BlocProvider.of<ProviderBloc>(context).add(CheckEvent(rootTask));
              context.read<ProviderBloc>().add(CheckEvent(rootTask));
            },
          ),
          title: Text('Изменить ${checkTask.text}'),
        ),
        body: ListView.builder(
            itemCount: tasks == []
                ? 0
                : tasks.length, //.db.getAllTask().length,//MyDB.db.myDB.length,
            itemBuilder: (context, index) {
              print("${tasks[index].toMap()} == ${checkTask.toMap()}  ?");
              //print("ListView.builder");
              return GestureDetector(
                onTap: () {
                  print(tasks[index].id);
                  print(tasks[index].text);
                  //BlocProvider.of<ProviderBloc>(context)
                    //  .add(UpdateEvent(rootTask, tasks[index]));
                  context.read<ProviderBloc>().add(UpdateEvent(rootTask, tasks[index]));
                },
                onLongPress: () {
                  print("Long press on ${tasks[index].id}");
                  //setState(() { borderColor = Colors.orange; });
                },
                child: Container(
                  //height: MyDB.db.myDB[index].heightContainer,    //62, // Не должно быть константным // Задается в обьекте
                  //width: 500,
                  margin: EdgeInsets.fromLTRB(20.0, 5.0, 10.0, 5.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: tasks[index].id == checkTask.id
                          ? Theme.of(context).primaryColorDark
                          : Theme.of(context).primaryColor,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                    color: Theme.of(context)
                        .textTheme
                        .headline6
                        .color, //Colors.white,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: Text(
                                  " ${tasks[index].text}",
                                  style: tasks[index].id == checkTask.id
                                      ? TextStyle(fontWeight: FontWeight.bold)
                                      : TextStyle(
                                          fontWeight: FontWeight.normal),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
        floatingActionButton: myFloatingActionButton(context,
            false, checkTask, rootTask), 
      );
    });
  }
}

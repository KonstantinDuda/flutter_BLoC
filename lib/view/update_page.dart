import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_sheduler/view/my_snack_bar.dart';

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

class UpdatePage extends StatefulWidget {
  final RootTaskNew rootTask;
  final CheckTaskNew checkTask;
  UpdatePage(this.rootTask, this.checkTask);

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {


  List<RootTaskNew> rootTasks;
  List<CheckTaskNew> checkTasks;

  var stantartRightMargin = 10.0;
  var bigRightMargin = 0.0;
  var rootFirstShortTask;
  var checkFirstShortTask;
  var maxNotification = 0.0;
  var notificationStep = 0.0;

  @override
  Widget build(BuildContext context) {
    print("build update page");
    print("Update Task == ${widget.rootTask.toMap()}");
    return WillPopScope(
        onWillPop: () async {
          //BlocProvider.of<ProviderBloc>(context).add(RootEvent());
          widget.checkTask == null
              ? context.read<ProviderBloc>().add(RootEvent())
              : context.read<ProviderBloc>().add(CheckEvent(widget.rootTask));
          return false;
        },
        child: widget.checkTask == null
            ? checkTaskIsNull(widget.rootTask)
            : checkTaskIsNotNull(widget.rootTask, widget.checkTask));
    /*if (checkTask == null) {
      return checkTaskIsNull(rootTask);
    } else {
      return checkTaskIsNotNull(rootTask, checkTask);
    }*/
  }

  myFloatingActionButton(BuildContext context, bool checkTaskIsNull,
      CheckTaskNew check, RootTaskNew root) {
    rootDeleteOnPressed() {
     var result = {context.read<TaskBloc>().add(RootTaskDeletedEvent(root.id)),
      ScaffoldMessenger.of(context).removeCurrentSnackBar()};
      return result;
    }
    checkDeleteOnPressed() {
      var result = {context.read<CheckTaskBloc>().add(CheckTaskDeletedEvent(check.id)),
      ScaffoldMessenger.of(context).removeCurrentSnackBar(),
      context.read<TaskBloc>().add(RootTaskUpdateCountEvent(widget.rootTask.id,
          -1, 0) /*RootTaskUpdateEvent(root.id, 0, root.text, 0, -1)*/)};
          return result;
    };
    return Container(
      // При перемещении на телефоне активный обьект перерисовывается в синий цвет...
      child: Column(
        //Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
                child: FloatingActionButton(
                  onPressed: () {
                    print('press Up');
                    if (checkTaskIsNull == true) {
                      context.read<TaskBloc>().add(
                          RootTaskUpdatePositionEvent(widget.rootTask.id, -1)
                          /*RootTaskUpdateEvent(
                          widget.rootTask.id, -1, widget.rootTask.text, 0, 0)*/
                          );
                    } else {
                      context.read<CheckTaskBloc>().add(
                          CheckTaskUpdatePositionEvent(widget.checkTask.id,
                              -1) /*CheckTaskUpdateEvent(
                          widget.checkTask.id, -1, widget.checkTask.text, false)*/
                          );
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
                      context.read<TaskBloc>().add(
                          RootTaskUpdatePositionEvent(widget.rootTask.id, 1)
                          /*RootTaskUpdateEvent(
                          widget.rootTask.id, 1, widget.rootTask.text, 0, 0)*/
                          );
                    } else {
                      context.read<CheckTaskBloc>().add(
                          CheckTaskUpdatePositionEvent(widget.checkTask.id,
                              1) /*CheckTaskUpdateEvent(
                          widget.checkTask.id, 1, widget.checkTask.text, false)*/
                          );
                    }
                  },
                  child: Icon(Icons.arrow_downward),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    if (checkTaskIsNull == true) {
                      //print('root rewrite');
                      context
                          .read<ProviderBloc>()
                          .add(DialogEvent(true, widget.rootTask, null));
                    } else {
                      //print('check rewrite');
                      context.read<ProviderBloc>().add(
                          DialogEvent(true, widget.rootTask, widget.checkTask));
                    }
                  },
                  label: Icon(Icons.create), //Text('Редактировать'),
                  //icon: Icon(Icons.create),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
                child: FloatingActionButton(
                  onPressed: () {
                    if (checkTaskIsNull == true) {
                      //BlocProvider.of<ProviderBloc>(context).add(RootEvent());
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 3),
                          content: MySnackBar(root.text, rootDeleteOnPressed()),
                          /*Row(
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
                              context.read<TaskBloc>().add(RootTaskDeletedEvent(root.id));
                              ScaffoldMessenger.of(context)
                                  .removeCurrentSnackBar();
                            },
                          ),
                        ],
                      ),*/
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 3),
                          content: MySnackBar(check.text, checkDeleteOnPressed()),

                          /*Row(
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
                              context.read<CheckTaskBloc>().add(CheckTaskDeletedEvent(check.id));
                              ScaffoldMessenger.of(context)
                                  .removeCurrentSnackBar();
                              context.read<TaskBloc>().add(RootTaskUpdateEvent(root.id, 0, root.text, 0, -1));
                            },
                          ),
                        ],
                      ),*/
                        ),
                      );
                    }
                  },
                  child: Icon(Icons.delete_forever_outlined),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  checkTaskIsNull(RootTaskNew rootTask) {
    print('check task is null');
    return BlocBuilder<TaskBloc, RootTaskState>(builder: (context, state) {
      //List<RootTaskNew> tasks;
      if (state is RootTaskLoadSuccessState) {
        //print('tasks = state.tasks');

        if (state.tasks == null) {
          rootTasks = [];
          //print('tasks == null; now $tasks');
        } else {
          rootTasks = state.tasks;
           for (var i=0; i < rootTasks.length; i++) {
             if(rootTasks[i].rightMargin > rootTasks[i-1].rightMargin && rootFirstShortTask == null) {
              rootFirstShortTask = rootTasks[i];
              bigRightMargin = rootTasks[i].rightMargin;
            }
           }
        }
      } else {
        //print('tasks = [] because state is not a TaskLoadSuccessState');
        rootTasks = [];
      }
      //print('tasks == $tasks');
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).textTheme.headline6.color,
          leading: IconButton(
            icon: Icon(
              Icons.check,
              size: 30.0,
            ),
            onPressed: () {
              //BlocProvider.of<ProviderBloc>(context).add(RootEvent());
              context.read<ProviderBloc>().add(RootEvent());
            },
          ),
          title: Text('Изменить ${rootTask.text}'),
        ),
        body: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              _notificationPositions(notification.metrics.pixels);

              //print(notification.metrics.pixels);

              //_setMargins();
              return true;
            },
            child: ListView.builder(
            itemCount: rootTasks == []
                ? 0
                : rootTasks.length, //.db.getAllTask().length,//MyDB.db.myDB.length,
            itemBuilder: (context, index) {
              //print("${tasks[index].toMap()} == ${rootTask.toMap()}  ?");
              //print("ListView.builder");
              return GestureDetector(
                onTap: () {
                  print(rootTasks[index].id);
                  print(rootTasks[index].text);
                  context
                      .read<ProviderBloc>()
                      .add(UpdateEvent(rootTasks[index], null));
                },
                onLongPress: () {
                  print("Long press on ${rootTasks[index].id}");
                },
                child: AnimatedContainer(
                  margin: EdgeInsets.fromLTRB(20.0, 5.0, rootTasks[index].rightMargin, 5.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: rootTasks[index].id == rootTask.id
                          ? Theme.of(context).primaryColorDark
                          : Theme.of(context).primaryColor,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                    color: Theme.of(context).textTheme.headline6.color,
                  ),
                  duration: const Duration(seconds: 1),
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
                                  " ${rootTasks[index].text}",
                                  style: rootTasks[index].id == rootTask.id
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
            }),),
        floatingActionButton:
            myFloatingActionButton(context, true, null, rootTask),
      );
    });
  }

  checkTaskIsNotNull(RootTaskNew rootTask, CheckTaskNew checkTask) {
    print('check task is NOT null');
    return BlocBuilder<CheckTaskBloc, CheckTaskState>(
        builder: (context, state) {
      //List<CheckTaskNew> tasks;
      if (state is CheckTaskLoadSuccessState) {
        //print('tasks = state.tasks');

        if (state.tasks == null) {
          checkTasks = [];
          //print('tasks == null; now $tasks');
        } else {
          checkTasks = state.tasks; 
          for (var i=0; i < checkTasks.length; i++) {
             if(checkTasks[i].rightMargin > checkTasks[i-1].rightMargin && checkFirstShortTask == null) {
              checkFirstShortTask = checkTasks[i];
              bigRightMargin = checkTasks[i].rightMargin;
            }
           }
          }
      } else {
        //print('tasks = [] because state is not a TaskLoadSuccessState');
        checkTasks = [];
      }
      //print('tasks == $tasks');
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).textTheme.headline6.color,
          leading: IconButton(
            icon: Icon(
              Icons.check,
              size: 30.0,
            ),
            onPressed: () {
              //BlocProvider.of<ProviderBloc>(context).add(CheckEvent(rootTask));
              context.read<ProviderBloc>().add(CheckEvent(rootTask));
            },
          ),
          title: Text('Изменить ${checkTask.text}'),
        ),
        body: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              _notificationPositions(notification.metrics.pixels);

              //print(notification.metrics.pixels);

              //_setMargins();
              return true;
            },
            child: ListView.builder(
            itemCount: checkTasks == []
                ? 0
                : checkTasks.length, //.db.getAllTask().length,//MyDB.db.myDB.length,
            itemBuilder: (context, index) {
              //print("${tasks[index].toMap()} == ${checkTask.toMap()}  ?");
              //print("ListView.builder");
              return GestureDetector(
                onTap: () {
                  print(checkTasks[index].id);
                  print(checkTasks[index].text);
                  //BlocProvider.of<ProviderBloc>(context)
                  //  .add(UpdateEvent(rootTask, tasks[index]));
                  context
                      .read<ProviderBloc>()
                      .add(UpdateEvent(rootTask, checkTasks[index]));
                },
                onLongPress: () {
                  print("Long press on ${checkTasks[index].id}");
                  //setState(() { borderColor = Colors.orange; });
                },
                child: AnimatedContainer(
                  //height: MyDB.db.myDB[index].heightContainer,    //62, // Не должно быть константным // Задается в обьекте
                  //width: 500,
                  margin: EdgeInsets.fromLTRB(20.0, 5.0, checkTasks[index].rightMargin, 5.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: checkTasks[index].id == checkTask.id
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
                  duration: const Duration(seconds: 1),
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
                                  " ${checkTasks[index].text}",
                                  style: checkTasks[index].id == checkTask.id
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
            }),),
        floatingActionButton:
            myFloatingActionButton(context, false, checkTask, rootTask),
      );
    });
  }
  _notificationPositions(double notification) {
    //print('notificationStep == $notificationStep');
   if(widget.checkTask == null) {
    if (notification > maxNotification) {
        if (notification > notificationStep + rootFirstShortTask.height) {
        setState(() {
          rootTasks[rootFirstShortTask.id].rightMargin = stantartRightMargin;
        });
        
        if (rootTasks.length > (rootFirstShortTask.id + 1)) {
          notificationStep += rootFirstShortTask.height;//notification;
            rootFirstShortTask = rootTasks[rootFirstShortTask.id + 1];
        } else {
          //print('else myTasks.length > (firstShortTask.id + 1)');
        }
      }
      
    } else if(notification < maxNotification){
      if (notification < notificationStep + rootFirstShortTask.height) {
        setState(() {
          rootTasks[rootFirstShortTask.id].rightMargin = bigRightMargin;
        });
        if(notificationStep >= rootFirstShortTask.height && notification < notificationStep) {
          notificationStep -=  rootFirstShortTask.height;
          rootFirstShortTask = rootTasks[rootFirstShortTask.id - 1];
        } else if(notificationStep < rootFirstShortTask.height) {
          notificationStep = 0.0;
        }
      }
    }
   } else {
     if (notification > maxNotification) {
        if (notification > notificationStep + checkFirstShortTask.height) {
        setState(() {
          checkTasks[checkFirstShortTask.id].rightMargin = stantartRightMargin;
        });
        
        if (checkTasks.length > (checkFirstShortTask.id + 1)) {
          notificationStep += checkFirstShortTask.height;//notification;
            checkFirstShortTask = checkTasks[checkFirstShortTask.id + 1];
        } else {
          //print('else myTasks.length > (firstShortTask.id + 1)');
        }
      }
      
    } else if(notification < maxNotification){
      if (notification < notificationStep + checkFirstShortTask.height) {
        setState(() {
          checkTasks[checkFirstShortTask.id].rightMargin = bigRightMargin;
        });
        if(notificationStep >= checkFirstShortTask.height && notification < notificationStep) {
          notificationStep -=  checkFirstShortTask.height;
          checkFirstShortTask = checkTasks[checkFirstShortTask.id - 1];
        } else if(notificationStep < checkFirstShortTask.height) {
          notificationStep = 0.0;
        }
      }
    }
   }
   maxNotification = notification;
  }
}

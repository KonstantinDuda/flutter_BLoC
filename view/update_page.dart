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

class UpdatePage extends StatefulWidget {
  final RootTask rootTask;
  final CheckTask checkTask;
  UpdatePage(this.rootTask, this.checkTask);

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  var ButtonIsActive = true;

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
      CheckTask check, RootTask root) {
    return Container(
      // При перемещении на телефоне активный обьект перерисовывается в синий цвет...
      child: Row(
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
                              child: Text("Delete ${root.text}?"),
                            ),
                          ),
                          TextButton(
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(
                                  Size(80.0, 50.0)),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).primaryColor),
                            ),
                            child: Text("Yes"),
                            onPressed: () {
                              context
                                  .read<TaskBloc>()
                                  .add(RootTaskDeletedEvent(root.id));
                              ScaffoldMessenger.of(context)
                                  .removeCurrentSnackBar();
                              ButtonIsActive = false;
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
                              child: Text("Delete ${check.text}?"),
                            ),
                          ),
                          TextButton(
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(
                                  Size(80.0, 50.0)),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).primaryColor),
                            ),
                            child: Text("Yes"),
                            onPressed: () {
                              //BlocProvider.of<CheckTaskBloc>(context)
                              //  .add(CheckTaskDeletedEvent(check.id));

                              context
                                  .read<CheckTaskBloc>()
                                  .add(CheckTaskDeletedEvent(check.id));
                              ScaffoldMessenger.of(context)
                                  .removeCurrentSnackBar();
                              context.read<TaskBloc>().add(RootTaskUpdateEvent(
                                  root.id, 0, root.text, 0, -1));
                              ButtonIsActive = false;
                              print('ButtonIsActive == $ButtonIsActive');
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
              backgroundColor:
                  ButtonIsActive ? Theme.of(context).primaryColor : Colors.grey,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
            child: FloatingActionButton(
              onPressed: () {
                print('press Up');
                if (checkTaskIsNull == true) {
                  //BlocProvider.of<TaskBloc>(context).add(RootTaskUpdateEvent(
                  //  rootTask.id, -1, rootTask.text, 0, 0));
                  context.read<TaskBloc>().add(RootTaskUpdateEvent(
                      widget.rootTask.id, -1, widget.rootTask.text, 0, 0));
                } else {
                  //BlocProvider.of<CheckTaskBloc>(context).add(
                  //  CheckTaskUpdateEvent(
                  //    checkTask.id, -1, checkTask.text, false));
                  context.read<CheckTaskBloc>().add(CheckTaskUpdateEvent(
                      widget.checkTask.id, -1, widget.checkTask.text, false));
                }
              },
              child: Icon(Icons.arrow_upward),
              backgroundColor:
                  ButtonIsActive ? Theme.of(context).primaryColor : Colors.grey,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
            child: FloatingActionButton(
              onPressed: () {
                context.read<ProviderBloc>().add(RootEvent());
              },
              child: Icon(Icons.check),
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
                  context.read<TaskBloc>().add(RootTaskUpdateEvent(
                      widget.rootTask.id, 1, widget.rootTask.text, 0, 0));
                } else {
                  //BlocProvider.of<CheckTaskBloc>(context).add(
                  //  CheckTaskUpdateEvent(
                  //    checkTask.id, 1, checkTask.text, false));
                  context.read<CheckTaskBloc>().add(CheckTaskUpdateEvent(
                      widget.checkTask.id, 1, widget.checkTask.text, false));
                }
              },
              child: Icon(Icons.arrow_downward),
              backgroundColor:
                  ButtonIsActive ? Theme.of(context).primaryColor : Colors.grey,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10.0, 5.0, 15.0, 5.0),
            child: FloatingActionButton(
              onPressed: () {
                if (checkTaskIsNull == true) {
                  print('root rewrite');
                  //BlocProvider.of<ProviderBloc>(context)
                  //  .add(DialogEvent(true, rootTask, null));
                  context
                      .read<ProviderBloc>()
                      .add(DialogEvent(true, widget.rootTask, null));
                } else {
                  print('check rewrite');
                  //BlocProvider.of<ProviderBloc>(context)
                  //  .add(DialogEvent(true, rootTask, checkTask));
                  context.read<ProviderBloc>().add(
                      DialogEvent(true, widget.rootTask, widget.checkTask));
                }
              },
              child: Icon(Icons.create),
              backgroundColor:
                  ButtonIsActive ? Theme.of(context).primaryColor : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  checkTaskIsNull(RootTask rootTask) {
    print('check task is null');
    return BlocBuilder<TaskBloc, RootTaskState>(builder: (context, state) {
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
          /*leading: IconButton(
            icon: Icon(
              Icons.check,
              size: 30,
            ),
            onPressed: () {
              //BlocProvider.of<ProviderBloc>(context).add(RootEvent());
              context.read<ProviderBloc>().add(RootEvent());
            },
          ),*/
          title: Text('Change ${rootTask.text}'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  itemCount: tasks == []
                      ? 0
                      : tasks
                          .length, //.db.getAllTask().length,//MyDB.db.myDB.length,
                  itemBuilder: (context, index) {
                    print("${tasks[index].toMap()} == ${rootTask.toMap()}  ?");
                    //print("ListView.builder");
                    return GestureDetector(
                      onTap: () {
                        print(tasks[index].id);
                        print(tasks[index].text);
                        //BlocProvider.of<ProviderBloc>(context)
                        //  .add(UpdateEvent(tasks[index], null));
                        ButtonIsActive = true;
                        context
                            .read<ProviderBloc>()
                            .add(UpdateEvent(tasks[index], null));
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
                                margin:
                                    EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Center(
                                      child: Text(
                                        " ${tasks[index].text}",
                                        style: tasks[index].id == rootTask.id
                                            ? TextStyle(
                                                fontWeight: FontWeight.bold)
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
            ),
            myFloatingActionButton(context, true, null, rootTask),
          ],
        ),
        /*floatingActionButton:
            myFloatingActionButton(context, true, null, rootTask),*/
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
          /*leading: IconButton(
            icon: Icon(
              Icons.check,
              size: 30,
            ),
            onPressed: () {
              //BlocProvider.of<ProviderBloc>(context).add(CheckEvent(rootTask));
              context.read<ProviderBloc>().add(CheckEvent(rootTask));
            },
          ),*/
          title: Text('Rewrite ${checkTask.text}'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  itemCount: tasks == []
                      ? 0
                      : tasks
                          .length, //.db.getAllTask().length,//MyDB.db.myDB.length,
                  itemBuilder: (context, index) {
                    print("${tasks[index].toMap()} == ${checkTask.toMap()}  ?");
                    //print("ListView.builder");
                    return GestureDetector(
                      onTap: () {
                        print(tasks[index].id);
                        print(tasks[index].text);
                        //BlocProvider.of<ProviderBloc>(context)
                        //  .add(UpdateEvent(rootTask, tasks[index]));
                        ButtonIsActive = true;
                        context
                            .read<ProviderBloc>()
                            .add(UpdateEvent(rootTask, tasks[index]));
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
                                margin:
                                    EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Center(
                                      child: Text(
                                        " ${tasks[index].text}",
                                        style: tasks[index].id == checkTask.id
                                            ? TextStyle(
                                                fontWeight: FontWeight.bold)
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
            ),
            myFloatingActionButton(context, false, checkTask, rootTask),
          ],
        ),
        /*floatingActionButton:
            myFloatingActionButton(context, false, checkTask, rootTask),*/
      );
    });
  }
}

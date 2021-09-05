import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/root_task_bloc.dart';
import '../bloc/provider_bloc.dart';
import '../database/root_task.dart';
import '../database/root_task_event.dart';
import '../database/root_task_state.dart';

import '../bloc/chack_task_bloc.dart';
import '../database/chack_task.dart';
import '../database/chack_task_event.dart';
import '../database/chack_task_state.dart';
//import '../';

class UpdatePage extends StatelessWidget {
  final RootTask rootTask;
  final ChackTask chackTask;
  UpdatePage(this.rootTask, this.chackTask);

  @override
  Widget build(BuildContext context) {
    print("build update page");
    print("Update Task == ${rootTask.toMap()}");
    if(chackTask == null) {
      return chackTaskIsNull(rootTask);
    }
    else {
      return chackTaskIsNotNull(rootTask, chackTask);
    }
  }

  myFloatingActionButton(BuildContext context, bool chackTaskIsNull) {
    return Container(
          // При перемещении на телефоне активный обьект перерисовывается в синий цвет...
          child: Column(  //Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
                child: FloatingActionButton(
                  onPressed: () {
                    if(chackTaskIsNull == true){
                      BlocProvider.of<ProviderBloc>(context).add(RootEvent());
                    } else {
                      BlocProvider.of<ProviderBloc>(context).add(ChackEvent(rootTask));
                    }
                    
                  },
                  child: Icon(Icons.check),
                  backgroundColor: Theme.of(context).accentColor,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
                child: FloatingActionButton(
                  onPressed: () {
                    print('press Up');
                    if(chackTaskIsNull == true){
                      BlocProvider.of<TaskBloc>(context)
                        .add(RootTaskUpdateEvent(rootTask.id, -1, rootTask.text, 0, 0));
                    } else {
                      BlocProvider.of<ChackTaskBloc>(context)
                        .add(ChackTaskUpdateEvent(chackTask.id, -1, chackTask.text, false));
                    }
                    
                  },
                  child: Icon(Icons.arrow_upward),
                  backgroundColor: Theme.of(context).accentColor,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
                child: FloatingActionButton(
                  onPressed: () {
                    print('press Bottom');
                    if(chackTaskIsNull == true){
                      BlocProvider.of<TaskBloc>(context)
                        .add(RootTaskUpdateEvent(rootTask.id, 1, rootTask.text, 0 ,0));
                    } else {
                      BlocProvider.of<ChackTaskBloc>(context)
                        .add(ChackTaskUpdateEvent(chackTask.id, 1, chackTask.text, false));
                    }
                    
                  },
                  child: Icon(Icons.arrow_downward),
                  backgroundColor: Theme.of(context).accentColor,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    if(chackTaskIsNull == true){
                      print('root rewrite');
                      BlocProvider.of<ProviderBloc>(context).add(DialogEvent(true, rootTask, null));
                    } else {
                      print('chack rewrite');
                      BlocProvider.of<ProviderBloc>(context).add(DialogEvent(true, rootTask, chackTask));
                    }
                    
                  },
                  label: Text('Rewrite'),
                  icon: Icon(Icons.create),
                  backgroundColor: Theme.of(context).accentColor,
                ),
              ),
            ],
          ),
        );
  }

  chackTaskIsNull(RootTask rootTask) {
    print('chack task is null');
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
          backgroundColor: Theme.of(context).accentColor,
          foregroundColor: Theme.of(context).textTheme.headline6.color,
          title: Text('Update ${rootTask.text}'),
        ),
        body: ListView.builder(
            itemCount: tasks == [] ? 0 :
                tasks.length, //.db.getAllTask().length,//MyDB.db.myDB.length,
            itemBuilder: (context, index) {
              print("${tasks[index].toMap()} == ${rootTask.toMap()}  ?");
              //print("ListView.builder");
              return GestureDetector(
                onTap: () {
                  print(tasks[index].id);
                  print(tasks[index].text);
                  BlocProvider.of<ProviderBloc>(context).add(UpdateEvent(tasks[index], null));
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
                                child: Text (
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
        floatingActionButton: myFloatingActionButton(context, true), /*Container(
          // При перемещении на телефоне активный обьект перерисовывается в синий цвет...
          child: Column(  //Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
                child: FloatingActionButton(
                  onPressed: () {
                    BlocProvider.of<ProviderBloc>(context).add(RootEvent());
                  },
                  child: Icon(Icons.check_outlined),
                  backgroundColor: Theme.of(context).accentColor,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
                child: FloatingActionButton(
                  onPressed: () {
                    print('press Up');
                    //BlocProvider.of<TaskBloc>(context).add(TaskEvent(Events.updateTask, oldId: updateIndex, newId: updateIndex -1));
                    BlocProvider.of<TaskBloc>(context)
                        .add(RootTaskUpdateEvent(rootTask.id, -1, rootTask.text, 0, 0));
                    //BlocProvider.of<ProviderBloc>(context).add(UpdateEvent(updateTask));
                  },
                  child: Icon(Icons.arrow_upward),
                  backgroundColor: Theme.of(context).accentColor,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
                child: FloatingActionButton(
                  onPressed: () {
                    //BlocProvider.of<ProviderBloc>(context).add(ProviderEvent.dialog);
                    //BlocProvider.of<TaskBloc>(context).add(TaskEvent(Events.updateTask, oldId: updateIndex, newId: updateIndex +1));
                    //newId(1);
                    print('press Bottom');
                    BlocProvider.of<TaskBloc>(context)
                        .add(RootTaskUpdateEvent(rootTask.id, 1, rootTask.text, 0 ,0));
                  },
                  child: Icon(Icons.arrow_downward),
                  backgroundColor: Theme.of(context).accentColor,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    BlocProvider.of<ProviderBloc>(context).add(DialogEvent(true, rootTask, null));
                  },
                  label: Text('Rewrite'),
                  icon: Icon(Icons.create),
                  backgroundColor: Theme.of(context).accentColor,
                ),
              ),
            ],
          ),
        ),*/
      );
    });
  }

  chackTaskIsNotNull(RootTask rootTask, ChackTask chackTask) {
    print('chack task is NOT null');
    return BlocBuilder<ChackTaskBloc, ChackTaskState>(builder: (context, state) {
      List<ChackTask> tasks;
      if (state is ChackTaskLoadSuccessState) {
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
          title: Text('Update ${chackTask.text}'),
        ),
        body: ListView.builder(
            itemCount: tasks == [] ? 0 :
                tasks.length, //.db.getAllTask().length,//MyDB.db.myDB.length,
            itemBuilder: (context, index) {
              print("${tasks[index].toMap()} == ${chackTask.toMap()}  ?");
              //print("ListView.builder");
              return GestureDetector(
                onTap: () {
                  print(tasks[index].id);
                  print(tasks[index].text);
                  BlocProvider.of<ProviderBloc>(context).add(UpdateEvent(rootTask, tasks[index]));
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
                      color: tasks[index].id == chackTask.id
                          ? Colors.orange
                          : Colors.blue,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                    color: Theme.of(context).textTheme.headline6.color, //Colors.white,
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
                                child: Text (
                                  " ${tasks[index].text}",
                                  style: tasks[index].id == chackTask.id
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
        floatingActionButton: myFloatingActionButton(context, false), /*Container(
          // При перемещении на телефоне активный обьект перерисовывается в синий цвет...
          child: Column(  //Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
                child: FloatingActionButton(
                  onPressed: () {
                    BlocProvider.of<ProviderBloc>(context).add(ChackEvent(rootTask));
                  },
                  child: Icon(Icons.check_outlined),
                  backgroundColor: Theme.of(context).accentColor,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
                child: FloatingActionButton(
                  onPressed: () {
                    print('press Up');
                    //BlocProvider.of<TaskBloc>(context).add(TaskEvent(Events.updateTask, oldId: updateIndex, newId: updateIndex -1));
                    BlocProvider.of<ChackTaskBloc>(context)
                        .add(ChackTaskUpdateEvent(chackTask.id, -1, chackTask.text, false));
                    //BlocProvider.of<ProviderBloc>(context).add(UpdateEvent(updateTask));
                  },
                  child: Icon(Icons.arrow_upward),
                  backgroundColor: Theme.of(context).accentColor,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
                child: FloatingActionButton(
                  onPressed: () {
                    //BlocProvider.of<ProviderBloc>(context).add(ProviderEvent.dialog);
                    //BlocProvider.of<TaskBloc>(context).add(TaskEvent(Events.updateTask, oldId: updateIndex, newId: updateIndex +1));
                    //newId(1);
                    print('press Bottom');
                    BlocProvider.of<ChackTaskBloc>(context)
                        .add(ChackTaskUpdateEvent(chackTask.id, 1, chackTask.text, false));
                  },
                  child: Icon(Icons.arrow_downward),
                  backgroundColor: Theme.of(context).accentColor,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    BlocProvider.of<ProviderBloc>(context).add(DialogEvent(true, rootTask, chackTask));
                  },
                  label: Text('Rewrite'),
                  icon: Icon(Icons.create),
                  backgroundColor: Theme.of(context).accentColor,
                ),
              ),
            ],
          ),
        ),*/
      );
    });
  }
}

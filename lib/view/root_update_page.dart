import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/root_task_bloc.dart';
import '../bloc/provider_bloc.dart';
import '../database/root_task.dart';
import '../database/root_task_event.dart';
import '../database/root_task_state.dart';
//import '../';

class RootUpdatePage extends StatelessWidget {
  final RootTask updateTask;
  RootUpdatePage(this.updateTask);

  @override
  Widget build(BuildContext context) {
    print("build update page");
    print("Update Task == ${updateTask.toMap()}");
    return BlocBuilder<TaskBloc, RootTaskState>(builder: (context, state) {
      List<RootTask> tasks;
      if (state is TaskLoadSuccessState) {
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
          title: Text('Update ${updateTask.text}'),
        ),
        body: ListView.builder(
            itemCount:
                tasks.length, //.db.getAllTask().length,//MyDB.db.myDB.length,
            itemBuilder: (context, index) {
              print("${tasks[index].toMap()} == ${updateTask.toMap()}  ?");
              //print("ListView.builder");
              return GestureDetector(
                onTap: () {
                  print(tasks[index].id);
                  print(tasks[index].text);
                  BlocProvider.of<ProviderBloc>(context).add(UpdateEvent(tasks[index]));
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
                      color: tasks[index].id == updateTask.id
                          ? Colors.orange
                          : Colors.blue,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.white,
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
                                  style: tasks[index].id == updateTask.id
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
        floatingActionButton: Container(
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
                  backgroundColor: Colors.blue,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
                child: FloatingActionButton(
                  onPressed: () {
                    print('press Up');
                    //BlocProvider.of<TaskBloc>(context).add(TaskEvent(Events.updateTask, oldId: updateIndex, newId: updateIndex -1));
                    BlocProvider.of<TaskBloc>(context)
                        .add(RootTaskUpdateEvent(updateTask.id, -1, updateTask.text));
                    //BlocProvider.of<ProviderBloc>(context).add(UpdateEvent(updateTask));
                  },
                  child: Icon(Icons.arrow_upward),
                  backgroundColor: Colors.blue,
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
                        .add(RootTaskUpdateEvent(updateTask.id, 1, updateTask.text));
                  },
                  child: Icon(Icons.arrow_downward),
                  backgroundColor: Colors.blue,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    BlocProvider.of<ProviderBloc>(context).add(DialogEvent(true, updateTask, null));
                  },
                  label: Text('Rewrite'),
                  icon: Icon(Icons.create),
                  backgroundColor: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

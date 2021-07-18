import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../database/root_task.dart';

import '../bloc/root_task_bloc.dart';
import '../bloc/chack_task_bloc.dart';
import '../bloc/provider_bloc.dart';
//import '../bloc/theme_cubit.dart';

import '../database/chack_task.dart';
import '../database/chack_task_event.dart';
import '../database/root_task_event.dart';
import '../database/chack_task_state.dart';

class ChackPage extends StatelessWidget {
  //String id;
  final RootTask task;
  ChackPage(this.task);

  @override
  Widget build(BuildContext context) {
    //var borderColor = Theme.of(context).accentColor;
    print("build RootPage ${task.text}");
    return BlocBuilder<ChackTaskBloc, ChackTaskState>(builder: (context, state) {
      List<ChackTask> tasks = [];
      if (state is ChackTaskLoadSuccessState) {
        if (state.tasks == null) {
          tasks = [];
        } else {
          List<ChackTask> allTasks;
          allTasks = state.tasks;
          for(ChackTask localTask in allTasks) {
            if(localTask.rootID == task.id) {
              tasks.add(localTask);
            }
          }
           
          }
      } else {
        tasks = [];
      }
      print('tasks == $tasks');
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back), 
            onPressed: () {
              BlocProvider.of<ProviderBloc>(context)
                    .add(RootEvent());
            },
          ),
          title: Text(task.text),
        ),
        body: ListView.builder(
            itemCount: tasks == []
                ? 0
                : tasks.length, 
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  print("onTap: ${tasks[index].text}");
                  if(tasks[index].chack == true){
                    BlocProvider.of<TaskBloc>(context).add(RootTaskUpdateEvent(task.id, 0, task.text, -1, 0));
                  } else if(tasks[index].chack == false) {
                    BlocProvider.of<TaskBloc>(context).add(RootTaskUpdateEvent(task.id, 0, task.text, 1, 0));
                  }
                  BlocProvider.of<ChackTaskBloc>(context).add(ChackTaskUpdateEvent(tasks[index].id, 0, tasks[index].text ,true));
                },
                onLongPress: () {
                  print('longPress on ${tasks[index].text}');
                  BlocProvider.of<ProviderBloc>(context)
                      .add(UpdateEvent(task, tasks[index]));
                },
                onHorizontalDragStart: (DragStartDetails start) {
                  print(start);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 3),
                      content: Row(
                        children: <Widget>[
                          CircularProgressIndicator(
                            //value: 0.4,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                              child: Text("Delete ${tasks[index].text}?"),
                            ),
                          ),
                          TextButton(
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(
                                  Size(80.0, 50.0)),
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Theme.of(context).accentColor),
                            ),
                            child: Text("yes"),
                            onPressed: () {
                              BlocProvider.of<ChackTaskBloc>(context)
                                  .add(ChackTaskDeletedEvent(tasks[index].id));
                              ScaffoldMessenger.of(context)
                                  .removeCurrentSnackBar();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).accentColor,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                    color: Theme.of(context).textTheme.headline6.color,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          //color: Colors.red,
                          margin: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: Text (
                                  "${tasks[index].text}",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 15.0),
                        child: Checkbox(
                          activeColor: Theme.of(context).primaryColor,
                          checkColor: Theme.of(context).textTheme.headline6.color,
                          value: tasks[index].chack,
                          onChanged: (bool value) {
                            BlocProvider.of<ChackTaskBloc>(context).add(ChackTaskUpdateEvent(tasks[index].id, 0, tasks[index].text ,true));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            BlocProvider.of<ProviderBloc>(context).add(DialogEvent(false, task, null));
          },
          label: Text('Task'),
          icon: Icon(Icons.add),
          backgroundColor: Theme.of(context).accentColor,
        ),
      );
    });
  }
}

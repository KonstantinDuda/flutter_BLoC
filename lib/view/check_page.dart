import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../database/root_task.dart';

import '../bloc/root_task_bloc.dart';
import '../bloc/check_task_bloc.dart';
import '../bloc/provider_bloc.dart';
//import '../bloc/theme_cubit.dart';

import '../database/check_task.dart';
import '../database/check_task_event.dart';
import '../database/root_task_event.dart';
import '../database/check_task_state.dart';

class CheckPage extends StatelessWidget {
  //String id;
  final RootTask task;
  CheckPage(this.task);

  @override
  Widget build(BuildContext context) {
    //var borderColor = Theme.of(context).accentColor;
    //CheckTaskBloc().add(CheckTaskLoadSuccessEvent(task.id));
    print("build CheckPage on ${task.text}");
    return WillPopScope(
      onWillPop: () async { //BlocProvider.of<ProviderBloc>(context).add(RootEvent());
        context.read<ProviderBloc>().add(RootEvent());
      return false; },
      child:
    BlocBuilder<CheckTaskBloc, CheckTaskState>(builder: (context, state) {
      /*BlocProvider.of<CheckTaskBloc>(context)
                    .add(CheckTaskLoadSuccessEvent(task.id));*/
      List<CheckTask> tasks;
      if (state is CheckTaskLoadSuccessState) {
        if (state.tasks == null) {
          tasks = [];
        } else {
          tasks = state.tasks;
          //List<CheckTask> allTasks;
          //allTasks = state.tasks;
          //for(CheckTask localTask in allTasks) {
          //  if(localTask.rootID == task.id) {
          //    tasks.add(localTask);
          //  }
          //}
          }
      } else {
        tasks = [];
      }
      print('tasks == $tasks');
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).textTheme.headline6.color,
          leading: IconButton(
            icon: Icon(Icons.arrow_back), 
            onPressed: () {
              //BlocProvider.of<ProviderBloc>(context)
                //    .add(RootEvent());
              context.read<ProviderBloc>().add(RootEvent());
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
                  if(tasks[index].check == 1){
                    //BlocProvider.of<TaskBloc>(context).add(RootTaskUpdateEvent(task.id, 0, task.text, -1, 0));
                    context.read<TaskBloc>().add(RootTaskUpdateEvent(task.id, 0, task.text, -1, 0));
                  } else if(tasks[index].check == 0) {
                    //BlocProvider.of<TaskBloc>(context).add(RootTaskUpdateEvent(task.id, 0, task.text, 1, 0));
                    context.read<TaskBloc>().add(RootTaskUpdateEvent(task.id, 0, task.text, 1, 0));
                  }
                  //BlocProvider.of<CheckTaskBloc>(context).add(CheckTaskUpdateEvent(tasks[index].id, 0, tasks[index].text ,true));
                  context.read<CheckTaskBloc>().add(CheckTaskUpdateEvent(tasks[index].id, 0, tasks[index].text, true));
                },
                onLongPress: () {
                  print('longPress on ${tasks[index].text}');
                  //BlocProvider.of<ProviderBloc>(context)
                    //  .add(UpdateEvent(task, tasks[index]));
                  context.read<ProviderBloc>().add(UpdateEvent(task, tasks[index]));
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
                                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                              child: Text("Удалить ${tasks[index].text}?"),
                            ),
                          ),
                          TextButton(
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(
                                  Size(80.0, 50.0)),
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                            ),
                            child: Text("Да"),
                            onPressed: () {
                              //BlocProvider.of<CheckTaskBloc>(context)
                                //  .add(CheckTaskDeletedEvent(tasks[index].id));

                              context.read<CheckTaskBloc>().add(CheckTaskDeletedEvent(tasks[index].id));
                              ScaffoldMessenger.of(context)
                                  .removeCurrentSnackBar();
                              context.read<TaskBloc>().add(RootTaskUpdateEvent(task.id, 0, task.text, 0, -1));


                              //BlocProvider.of<TaskBloc>(context).add(RootTaskUpdateEvent(task.id, 0, task.text, 0, -1));
                  
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
                      color: Theme.of(context).primaryColor,
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
                          value: tasks[index].check == 1 ? true : false,
                          onChanged: (bool value) {
                            if(tasks[index].check == 1){
                              //BlocProvider.of<TaskBloc>(context).add(RootTaskUpdateEvent(task.id, 0, task.text, -1, 0));
                              context.read<TaskBloc>().add(RootTaskUpdateEvent(task.id, 0, task.text, -1, 0));
                            } else if(tasks[index].check == 0) {
                              //BlocProvider.of<TaskBloc>(context).add(RootTaskUpdateEvent(task.id, 0, task.text, 1, 0));
                              context.read<TaskBloc>().add(RootTaskUpdateEvent(task.id, 0, task.text, 1, 0));
                            }
                            //BlocProvider.of<CheckTaskBloc>(context).add(CheckTaskUpdateEvent(tasks[index].id, 0, tasks[index].text ,true));
                            context.read<CheckTaskBloc>().add(CheckTaskUpdateEvent(tasks[index].id, 0, tasks[index].text, true));
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
            //BlocProvider.of<ProviderBloc>(context).add(DialogEvent(false, task, null));
            context.read<ProviderBloc>().add(DialogEvent(false, task, null));
          },
          label: Text('Задача'),
          icon: Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
    }));
  }
}

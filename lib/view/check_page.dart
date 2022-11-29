import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_sheduler/view/my_snack_bar.dart';

import '../database/root_task.dart';

import '../bloc/root_task_bloc.dart';
import '../bloc/check_task_bloc.dart';
import '../bloc/provider_bloc.dart';

import '../database/check_task.dart';
import '../database/check_task_event.dart';
import '../database/root_task_event.dart';
import '../database/check_task_state.dart';

class CheckPage extends StatefulWidget {
  final RootTaskNew task;
  CheckPage(this.task);

  @override
  State<CheckPage> createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  List<CheckTaskNew> tasks;

  var stantartRightMargin = 10.0;
  var bigRightMargin = 0.0;
  var firstShortTask;
  var maxNotification = 0.0;
  var notificationStep = 0.0;

  @override
  Widget build(BuildContext context) {
    //print("build CheckPage on ${widget.task.text}");
    return WillPopScope(onWillPop: () async {
      context.read<ProviderBloc>().add(RootEvent());
      return false;
    }, child:
        BlocBuilder<CheckTaskBloc, CheckTaskState>(builder: (context, state) {
      //int deleteTaskIndex;
      
      if (state is CheckTaskLoadSuccessState) {
        if (state.tasks == null) {
          tasks = [];
        } else {
          tasks = state.tasks;
          for (var i=0; i < tasks.length; i++) {
            if(tasks[i].height == 0.0) {
              context.read<ProviderBloc>().add(ViewCalculateCheckEvent(tasks[i], widget.task));
            }
            if(tasks[i].rightMargin == 0.0) {
              context.read<CheckTaskBloc>().add(CheckTaskUpdateMarginsEvent(tasks[i].id));
            }
            if(i>1) {
            if(tasks[i].rightMargin > tasks[i-1].rightMargin && firstShortTask == null) {
              firstShortTask = tasks[i];
              bigRightMargin = tasks[i].rightMargin;
            }
            }
          }
        }
      } else {
        tasks = [];
      }
      snackBar(var task) {
        var result = {context
            .read<CheckTaskBloc>()
            .add(CheckTaskDeletedEvent(task.id)),
        ScaffoldMessenger.of(context).removeCurrentSnackBar(),
        context
            .read<TaskBloc>()
            .add(RootTaskUpdateCountEvent(widget.task.id, -1, 0
                              )/*RootTaskUpdateEvent(task.id, 0, task.text, 0, -1)*/),};
                              return result;
      }

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).textTheme.headline6.color,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              context.read<ProviderBloc>().add(RootEvent());
            },
          ),
          title: Text(widget.task.text),
        ),
        body: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              _notificationPositions(notification.metrics.pixels);

              //print(notification.metrics.pixels);

              //_setMargins();
              return true;
            },
            child:ListView.builder(
            itemCount: tasks == [] ? 0 : tasks.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (tasks[index].check == 1) {
                    context
                        .read<TaskBloc>()
                        .add(RootTaskUpdateCountEvent(widget.task.id,0, -1)/*RootTaskUpdateEvent(widget.task.id, 0, widget.task.text, -1, 0)*/);
                  } else if (tasks[index].check == 0) {
                    context
                        .read<TaskBloc>()
                        .add(RootTaskUpdateCountEvent(widget.task.id,0, 1)/*RootTaskUpdateEvent(widget.task.id, 0, widget.task.text, 1, 0)*/);
                  }
                  context.read<CheckTaskBloc>().add(CheckTaskUpdateCheckBoxEvent(tasks[index].id)/*CheckTaskUpdateEvent(
                      tasks[index].id, 0, tasks[index].text, true)*/);
                },
                onLongPress: () {
                  context
                      .read<ProviderBloc>()
                      .add(UpdateEvent(widget.task, tasks[index]));
                },
                onHorizontalDragStart: (DragStartDetails start) {
                  //deleteTaskIndex = index;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 3),
                      content: MySnackBar(tasks[index].text, snackBar(tasks[index])),
                      /*Row(
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
                              context.read<CheckTaskBloc>().add(CheckTaskDeletedEvent(tasks[index].id));
                              ScaffoldMessenger.of(context)
                                  .removeCurrentSnackBar();
                              context.read<TaskBloc>().add(RootTaskUpdateEvent(task.id, 0, task.text, 0, -1));
                            },
                          ),
                        ],
                      ),*/
                    ),
                  );
                },
                child: AnimatedContainer(
                  margin: EdgeInsets.fromLTRB(10.0, 5.0, tasks[index].rightMargin, 5.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                    color: Theme.of(context).textTheme.headline6.color,
                  ),
                  duration: const Duration(seconds:  1),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: Text(
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
                          checkColor:
                              Theme.of(context).textTheme.headline6.color,
                          value: tasks[index].check == 1 ? true : false,
                          onChanged: (bool value) {
                            if (tasks[index].check == 1) {
                              context.read<TaskBloc>().add(RootTaskUpdateCountEvent(widget.task.id,0, -1)
                              /*RootTaskUpdateEvent(
                                  widget.task.id, 0, widget.task.text, -1, 0)*/);
                            } else if (tasks[index].check == 0) {
                              context.read<TaskBloc>().add(RootTaskUpdateCountEvent(widget.task.id,0, 1)
                                /*RootTaskUpdateEvent(
                                  widget.task.id, 0, widget.task.text, 1, 0)*/);
                            }
                            context.read<CheckTaskBloc>().add(CheckTaskUpdateCheckBoxEvent(tasks[index].id) /*
                                CheckTaskUpdateEvent(tasks[index].id, 0,
                                    tasks[index].text, true)*/);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),), //),//),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            context.read<ProviderBloc>().add(DialogEvent(false, widget.task, null));
          },
          label: Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
    }));
  }

  _notificationPositions(double notification) {
    //print('notificationStep == $notificationStep');
    if (notification > maxNotification) {
      //if (notification - notificationStep > firstShortTask.height) {
        if (notification > notificationStep + firstShortTask.height) {
        setState(() {
          tasks[firstShortTask.id].rightMargin = stantartRightMargin;
        });
        
        if (tasks.length > (firstShortTask.id + 1)) {
          notificationStep += firstShortTask.height;//notification;
            firstShortTask = tasks[firstShortTask.id + 1];
            //print('firstShortTask == $firstShortTask');
            //print('notificationStep in (notification > maxNotification) == $notificationStep');
        } else {
          //print('else myTasks.length > (firstShortTask.id + 1)');
        }
      }
      
    } else if(notification < maxNotification){
      if (notification < notificationStep + firstShortTask.height) {
        setState(() {
          tasks[firstShortTask.id].rightMargin = bigRightMargin;
        });
        if(notificationStep >= firstShortTask.height && notification < notificationStep) {
          notificationStep -=  firstShortTask.height;
          firstShortTask = tasks[firstShortTask.id - 1];
          //print('firstShortTask == $firstShortTask');
          //print('notificationStep in (notification < maxNotification) == $notificationStep');
        } else if(notificationStep < firstShortTask.height) {
          //print('else notificationStep >= firstShortTask.height');
          notificationStep = 0.0;
        }
      }
    }
   maxNotification = notification;
    //print(notification);
  }
}

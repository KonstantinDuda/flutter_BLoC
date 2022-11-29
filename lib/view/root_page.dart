import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:task_sheduler/view/my_snack_bar.dart';
import '../bloc/check_task_bloc.dart';
import '../database/check_task_event.dart';
//import '../database/check_task_state.dart';

import '../bloc/root_task_bloc.dart';
import '../bloc/provider_bloc.dart';
import '../bloc/theme_cubit.dart';

import '../database/root_task.dart';
import '../database/root_task_event.dart';
import '../database/root_task_state.dart';
import '../database/theme_state_file.dart';

class RootPageState extends StatefulWidget {
  @override
  State<RootPageState> createState() => _RootPage();
}

class _RootPage extends State<RootPageState> {
  final title = 'Scheduler';
  List<RootTaskNew> tasks;

  var stantartRightMargin = 10.0;
  var bigRightMargin = 0.0;
  var firstShortTask;
  var maxNotification = 0.0;
  var notificationStep = 0.0;

  @override
  Widget build(BuildContext context) {

    //print("build RootPage");
    return BlocBuilder<TaskBloc, RootTaskState>(builder: (context, state) {
      //var deleteTaskIndex;
      if (state is RootTaskLoadSuccessState) {
        if (state.tasks == null) {
          tasks = [];
        } else
          tasks = state.tasks;
          for (var i=0; i < tasks.length; i++) {
            if(tasks[i].height == 0.0) {
              context.read<ProviderBloc>().add(ViewCalculateRootEvent(tasks[i]));
            }
            if(tasks[i].rightMargin == 0.0) {
              context.read<TaskBloc>().add(RootTaskUpdateMarginsEvent(tasks[i].id));
            }
            if(i>1) {
            if(tasks[i].rightMargin > tasks[i-1].rightMargin && firstShortTask == null) {
              firstShortTask = tasks[i];
              bigRightMargin = tasks[i].rightMargin;
            }
            }
          }
      } else {
        tasks = [];
      }
      snackBar(var task) {
       var result = {context.read<TaskBloc>().add(RootTaskDeletedEvent(task.id)),
                              ScaffoldMessenger.of(context)
                                  .removeCurrentSnackBar(),};
                                  return result;
      }

      //print('tasks == $tasks');
      return Scaffold(
        appBar: AppBar(
          //shadowColor: Theme.of(context).primaryColor,
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).textTheme.headline6.color,
          title: Text(title),
          leading: IconButton(
            icon: Icon(Icons.brightness_4),
            onPressed: () {
              //BlocProvider.of<ThemeCubit>(context).toggleTheme();
              context.read<ThemeCubit>().toggleTheme();
              ThemeStateFile().writeState(1);
              //print('Change theme');
            },
          ),
        ),
        body: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              _notificationPositions(notification.metrics.pixels);

              //print(notification.metrics.pixels);

              //_setMargins();
              return true;
            },
            child: ListView.builder(
            itemCount: tasks == [] ? 0 : tasks.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  print("onTap: ${tasks[index].toMap()}");
                  context.read<CheckTaskBloc>().add(CheckTaskLoadSuccessEvent(tasks[index].id));
                  context.read<ProviderBloc>().add(CheckEvent(tasks[index]));
                },
                onLongPress: () {
                  print('longPress on ${tasks[index].text}');
                  context.read<ProviderBloc>().add(UpdateEvent(tasks[index], null));
                },
                onHorizontalDragStart: (DragStartDetails start) {
                  print(start);
                  //deleteTaskIndex = index;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 3),
                      content: MySnackBar(tasks[index].text, snackBar(tasks[index])),
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
                              child: Text("Удалить ${tasks[index].text}?"),
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
                                //  .add(RootTaskDeletedEvent(tasks[index].id));

                              context.read<TaskBloc>().add(RootTaskDeletedEvent(tasks[index].id));
                              ScaffoldMessenger.of(context)
                                  .removeCurrentSnackBar();
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
                  duration: const Duration(seconds: 1),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          //color: Colors.red,
                          margin: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: Text(
                                  "${tasks[index].text}",
                                ),
                              ),
                              OrientationBuilder(
                                builder: (context, orientation) {
                                  return orientation == Orientation.portrait
                                      ? _myLinearProcentIndicator(context,
                                          tasks[index].completedTaskProcent, tasks[index])
                                      : _myLinearProcentIndicator(
                                          context,
                                          tasks[index]
                                              .completedTaskProcent, tasks[index]); //_buildHorizontalLayout();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 15.0),
                        child: Text(
                            "${tasks[index].completedTaskCount} / ${tasks[index].allTaskCount}"),
                      ),
                    ],
                  ),
                ),
              );
            }),),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            context.read<ProviderBloc>().add(DialogEvent(false, null, null));
          },
          label: Icon(Icons.add), 
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
    });
  }

  _myLinearProcentIndicator(BuildContext context, double completedTaskProcent, RootTaskNew task) {
    return LinearPercentIndicator(
      alignment: MainAxisAlignment.center,
      padding: EdgeInsets.only(top: 5.0),
      width: MediaQuery.of(context).size.width / 2 - task.rightMargin,
      lineHeight: 3.5,
      percent: completedTaskProcent,
      progressColor: Theme.of(context).primaryColor,
      linearStrokeCap: LinearStrokeCap.roundAll,
    );
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

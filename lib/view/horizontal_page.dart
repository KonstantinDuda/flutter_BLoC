import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_sheduler/database/check_task.dart';
//import 'package:task_sheduler/view/check_page.dart';

import '../bloc/check_task_bloc.dart';
import '../bloc/provider_bloc.dart';
import '../bloc/root_task_bloc.dart';
import '../bloc/theme_cubit.dart';
import '../database/check_task_event.dart';
import '../database/check_task_state.dart';
import '../database/root_task_event.dart';
import '../database/root_task_state.dart';
import '../database/root_task.dart';
import '../database/theme_state_file.dart';
import 'root_page.dart';
import 'check_page.dart';

class HorizontalPage extends StatelessWidget {
  final RootTask rootTask;
  HorizontalPage(this.rootTask);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.portrait
            ? _buildVerticalLayout()
            : _buildHorizontalLayout(
                context, rootTask); //_buildHorizontalLayout();
      },
    );
  }

  _buildVerticalLayout() {
    if (rootTask == null) {
      return RootPage();
    } else {
      return CheckPage(rootTask);
    }
  }

  _buildHorizontalLayout(BuildContext context, RootTask task) {
    return HorizontalLayout(task);
  }
}

class HorizontalLayout extends StatefulWidget {
  final task;
  HorizontalLayout(this.task);

  @override
  State<HorizontalLayout> createState() => _HorizontalLayoutState();
}

class _HorizontalLayoutState extends State<HorizontalLayout> {
  RootTask task;
  List<RootTask> rootTasks;
  List<CheckTask> checkTasks;

  @override
  Widget build(BuildContext context) {
    if (widget.task != null) {
      task = widget.task;
    }
    final widthRootContainer = MediaQuery.of(context).size.width / 3;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).textTheme.headline6.color,
        title: Text('Scheduler'),
      ),
      body: Row(
        children: [
          Container(
            width: widthRootContainer,
            child:
                BlocBuilder<TaskBloc, RootTaskState>(builder: (context, state) {
              if (state is RootTaskLoadSuccessState) {
                if (state.tasks == null) {
                  rootTasks = [];
                } else
                  rootTasks = state.tasks;
              } else {
                rootTasks = [];
              }

              return Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                        itemCount: rootTasks == [] ? 0 : rootTasks.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              print(
                                  "onTap HorisontalPage RootTask: ${rootTasks[index].toMap()}");
                              task = rootTasks[index];
                              context.read<CheckTaskBloc>().add(
                                  CheckTaskLoadSuccessEvent(
                                      rootTasks[index].id));
                            },
                            onLongPress: () {
                              print('longPress on ${rootTasks[index].text}');
                              context
                                  .read<ProviderBloc>()
                                  .add(UpdateEvent(rootTasks[index], null));
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
                                            AlwaysStoppedAnimation<Color>(
                                                Theme.of(context).primaryColor),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              15.0, 0.0, 15.0, 0.0),
                                          child: Text(
                                              "Delete ${rootTasks[index].text}?"),
                                        ),
                                      ),
                                      TextButton(
                                        style: ButtonStyle(
                                          minimumSize:
                                              MaterialStateProperty.all<Size>(
                                                  Size(80.0, 50.0)),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Theme.of(context)
                                                      .primaryColor),
                                        ),
                                        child: Text("Yes"),
                                        onPressed: () {
                                          if (rootTasks[index].id == task.id) {
                                            task = null;
                                            checkTasks = [];
                                            context.read<CheckTaskBloc>().add(
                                                CheckTaskLoadSuccessEvent(-1));
                                          }
                                          context.read<TaskBloc>().add(
                                              RootTaskDeletedEvent(
                                                  rootTasks[index].id));
                                          ScaffoldMessenger.of(context)
                                              .removeCurrentSnackBar();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: RootBodyPage(
                                widthRootContainer, rootTasks[index]),
                          );
                        }),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10.0, 5.0, 15.0, 10.0),
                          child: Text(''),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10.0, 5.0, 15.0, 10.0),
                        child: FloatingActionButton.extended(
                          onPressed: () {
                            context.read<ThemeCubit>().toggleTheme();
                            ThemeStateFile().writeState(1);
                          },
                          extendedPadding: EdgeInsetsDirectional.only(
                              start: 30.0, end: 30.0),
                          label: Icon(Icons.brightness_4),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      ),
                      //),
                      Container(
                        margin: EdgeInsets.fromLTRB(10.0, 5.0, 15.0, 10.0),
                        child: FloatingActionButton.extended(
                          onPressed: () {
                            context
                                .read<ProviderBloc>()
                                .add(DialogEvent(false, null, null));
                          },
                          extendedPadding: EdgeInsetsDirectional.only(
                              start: 30.0, end: 30.0),
                          label: Icon(Icons.add),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
          Expanded(
            child: Container(
              child: BlocBuilder<CheckTaskBloc, CheckTaskState>(
                  builder: (context, state) {
                if (state is CheckTaskLoadSuccessState) {
                  if (state.tasks == null) {
                    checkTasks = [];
                  } else {
                    checkTasks = state.tasks;
                  }
                } else {
                  checkTasks = [];
                }

                return Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                          itemCount: checkTasks == [] ? 0 : checkTasks.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                print(
                                    "onTap HorisontalPage CheckTask: ${checkTasks[index].text}. RootTask == ${task.toMap()}");
                                if (checkTasks[index].check == 1) {
                                  context.read<TaskBloc>().add(
                                      RootTaskUpdateEvent(
                                          task.id, 0, task.text, -1, 0));
                                } else if (checkTasks[index].check == 0) {
                                  context.read<TaskBloc>().add(
                                      RootTaskUpdateEvent(
                                          task.id, 0, task.text, 1, 0));
                                }
                                context.read<CheckTaskBloc>().add(
                                    CheckTaskUpdateEvent(checkTasks[index].id,
                                        0, checkTasks[index].text, true));
                              },
                              onLongPress: () {
                                print('longPress on ${checkTasks[index].text}');
                                context
                                    .read<ProviderBloc>()
                                    .add(UpdateEvent(task, checkTasks[index]));
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
                                          valueColor: AlwaysStoppedAnimation<
                                                  Color>(
                                              Theme.of(context).primaryColor),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.fromLTRB(
                                                15.0, 0.0, 15.0, 0.0),
                                            child: Text(
                                                "Delete ${checkTasks[index].text}?"),
                                          ),
                                        ),
                                        TextButton(
                                          style: ButtonStyle(
                                            minimumSize:
                                                MaterialStateProperty.all<Size>(
                                                    Size(80.0, 50.0)),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    Theme.of(context)
                                                        .primaryColor),
                                          ),
                                          child: Text("Yes"),
                                          onPressed: () {
                                            context.read<CheckTaskBloc>().add(
                                                CheckTaskDeletedEvent(
                                                    checkTasks[index].id));
                                            ScaffoldMessenger.of(context)
                                                .removeCurrentSnackBar();
                                            context.read<TaskBloc>().add(
                                                RootTaskUpdateEvent(task.id, 0,
                                                    task.text, 0, -1));
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: CheckBodyPage(checkTasks[index]),
                            );
                          }),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10.0, 5.0, 15.0, 10.0),
                            child: Text(''),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10.0, 5.0, 15.0, 10.0),
                          child: FloatingActionButton.extended(
                            onPressed: () {
                              context
                                  .read<ProviderBloc>()
                                  .add(DialogEvent(false, task, null));
                            },
                            extendedPadding: EdgeInsetsDirectional.only(
                                start: 30.0, end: 30.0),
                            label: Icon(Icons.add),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

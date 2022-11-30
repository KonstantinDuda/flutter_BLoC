import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';
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

class RootPage extends StatelessWidget {
  //String id;
  //final title = 'Scheduler';

  @override
  Widget build(BuildContext context) {
    //var borderColor = Theme.of(context).accentColor;

    //print("build RootPage");
    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.portrait
            ? _buildVerticalLayout(context)
            : _buildHorizontalLayout(context); //_buildHorizontalLayout();
      },
    );
  }

  _buildVerticalLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //shadowColor: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).textTheme.headline6.color,
        title: Text('Scheduler'),
      ),
      body: //RootBodyPage(MediaQuery.of(context).size.width),
          BlocBuilder<TaskBloc, RootTaskState>(builder: (context, state) {
        List<RootTask> tasks;
        if (state is RootTaskLoadSuccessState) {
          if (state.tasks == null) {
            tasks = [];
          } else
            tasks = state.tasks;
        } else {
          tasks = [];
        }

        return Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  itemCount: tasks == [] ? 0 : tasks.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        print("onTap: ${tasks[index].toMap()}");
                        context
                            .read<CheckTaskBloc>()
                            .add(CheckTaskLoadSuccessEvent(tasks[index].id));
                        context
                            .read<ProviderBloc>()
                            .add(CheckEvent(tasks[index]));
                        //myOnTap(context, tasks[index]);
                      },
                      onLongPress: () {
                        print('longPress on ${tasks[index].text}');
                        /*BlocProvider.of<ProviderBloc>(context)
                      .add(UpdateEvent(tasks[index], null));*/
                        context
                            .read<ProviderBloc>()
                            .add(UpdateEvent(tasks[index], null));
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
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(
                                        15.0, 0.0, 15.0, 0.0),
                                    child: Text("Delete ${tasks[index].text}?"),
                                  ),
                                ),
                                TextButton(
                                  style: ButtonStyle(
                                    minimumSize:
                                        MaterialStateProperty.all<Size>(
                                            Size(80.0, 50.0)),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Theme.of(context).primaryColor),
                                  ),
                                  child: Text("Yes"),
                                  onPressed: () {
                                    //BlocProvider.of<TaskBloc>(context)
                                    //  .add(RootTaskDeletedEvent(tasks[index].id));

                                    context.read<TaskBloc>().add(
                                        RootTaskDeletedEvent(tasks[index].id));
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
                          MediaQuery.of(context).size.width, tasks[index]),
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
                    extendedPadding:
                        EdgeInsetsDirectional.only(start: 30.0, end: 30.0),
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
                    extendedPadding:
                        EdgeInsetsDirectional.only(start: 30.0, end: 30.0),
                    label: Icon(Icons.add),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  _buildHorizontalLayout(BuildContext context) {
    context.read<ProviderBloc>().add(HorizontalEvent(null));
    return Text('');
  }
}

class RootBodyPage extends StatelessWidget {
  final width;
  final task;
  RootBodyPage(this.width, this.task);

  @override
  Widget build(BuildContext context) {
    //var borderColor = Theme.of(context).accentColor;

    //print("build RootBodyPage");
    return Container(
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
              margin: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text(
                      "${task.text}",
                    ),
                  ),
                  OrientationBuilder(
                    builder: (context, orientation) {
                      return orientation == Orientation.portrait
                          ? _myLinearProcentIndicator(
                              context, task.completedTaskProcent)
                          : _myLinearProcentIndicator(context,
                              task.completedTaskProcent); //_buildHorizontalLayout();
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 15.0),
            child: Text("${task.completedTaskCount} / ${task.allTaskCount}"),
          ),
        ],
      ),
    );
  }

  _myLinearProcentIndicator(BuildContext context, double completedTaskProcent) {
    return LinearPercentIndicator(
      alignment: MainAxisAlignment.center,
      padding: EdgeInsets.only(top: 5.0),
      // Переменную ширины нужно брать из блока
      width: width / 2, // MediaQuery.of(context).size.width / 2,
      lineHeight: 3.5,
      percent: completedTaskProcent,
      //leading: Text("0"),
      //center: Text("50"),
      //trailing: Text("100%"), // Задается в обьекте
      progressColor: Theme.of(context).primaryColor,
      linearStrokeCap: LinearStrokeCap.roundAll,
    );
  }
}

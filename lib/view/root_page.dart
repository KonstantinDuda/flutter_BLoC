import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../bloc/chack_task_bloc.dart';
import '../database/chack_task_event.dart';
//import '../database/chack_task_state.dart';

import '../bloc/root_task_bloc.dart';
import '../bloc/provider_bloc.dart';
import '../bloc/theme_cubit.dart';

import '../database/root_task.dart';
import '../database/root_task_event.dart';
import '../database/root_task_state.dart';
import '../database/theme_state_file.dart';

class RootPage extends StatelessWidget {
  //String id;
  final title = 'Flutter Root Page';

  @override
  Widget build(BuildContext context) {
    //var borderColor = Theme.of(context).accentColor;

    print("build RootPage");
    return BlocBuilder<TaskBloc, RootTaskState>(builder: (context, state) {
      //fn(context);
      //if(th == null)
      //  fn();
      //if(th != 0)
      //  BlocProvider.of<ThemeCubit>(context).toggleTheme();
      
      List<RootTask> tasks;
      if (state is RootTaskLoadSuccessState) {
        if (state.tasks == null) {
          tasks = [];
        } else
          tasks = state.tasks;
      } else {
        tasks = [];
      }
      print('tasks == $tasks');
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: IconButton(
            icon: Icon(Icons.brightness_4),
            onPressed: () {
              BlocProvider.of<ThemeCubit>(context).toggleTheme();
              ThemeStateFile().writeState(1);
              print('Change theme');
            },
          ),
        ),
        body: ListView.builder(
            itemCount: tasks == [] ? 0 : tasks.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  print("onTap: ${tasks[index].toMap()}");
                  BlocProvider.of<ChackTaskBloc>(context)
                    .add(ChackTaskLoadSuccessEvent(tasks[index].id));
                  BlocProvider.of<ProviderBloc>(context)
                    .add(ChackEvent(tasks[index]));
                },
                onLongPress: () {
                  print('longPress on ${tasks[index].text}');
                  BlocProvider.of<ProviderBloc>(context)
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
                                Theme.of(context).accentColor),
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
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).accentColor),
                            ),
                            child: Text("yes"),
                            onPressed: () {
                              BlocProvider.of<TaskBloc>(context)
                                  .add(RootTaskDeletedEvent(tasks[index].id));
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
                                          tasks[index].completedTaskProcent)
                                      : _myLinearProcentIndicator(
                                          context,
                                          tasks[index]
                                              .completedTaskProcent); //_buildHorizontalLayout();
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
            }),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            BlocProvider.of<ProviderBloc>(context)
                .add(DialogEvent(false, null, null));
          },
          label: Text('Task'),
          icon: Icon(Icons.add),
          backgroundColor: Theme.of(context).accentColor,
        ),
      );
    });
  }

  _myLinearProcentIndicator(BuildContext context, double completedTaskProcent) {
    return LinearPercentIndicator(
      alignment: MainAxisAlignment.center,
      padding: EdgeInsets.only(top: 5.0),
      // Переменную ширины нужно брать из блока
      width: MediaQuery.of(context).size.width /
          2, // MediaQuery.of(context).size.width / 2,
      lineHeight: 3.5,
      percent: completedTaskProcent,
      //leading: Text("0"),
      //center: Text("50"),
      //trailing: Text("100%"), // Задается в обьекте
      progressColor: Theme.of(context).accentColor,
      linearStrokeCap: LinearStrokeCap.roundAll,
    );
  }
}

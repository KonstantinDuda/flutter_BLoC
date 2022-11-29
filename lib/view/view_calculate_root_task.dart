import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:task_sheduler/bloc/provider_bloc.dart';
import 'package:task_sheduler/bloc/root_task_bloc.dart';
import 'package:task_sheduler/database/root_task.dart';
import 'package:task_sheduler/database/root_task_event.dart';
//import 'package:task_sheduler/database/root_task_event.dart';
import 'package:task_sheduler/database/root_task_state.dart';

class ViewCalculateRootTaskPageState extends StatefulWidget {
  final RootTaskNew task;
  const ViewCalculateRootTaskPageState(this.task, {Key key}) : super(key: key);

  @override
  createState() => _ViewCalculateRootTaskPage();
}

class _ViewCalculateRootTaskPage extends State<ViewCalculateRootTaskPageState> {
  //final MyTask task;
  _ViewCalculateRootTaskPage();

  var standartMargin = const EdgeInsets.fromLTRB(10, 1, 10, 1);
  GlobalKey rootGlobalKey = GlobalKey();
  GlobalKey updateGlobalKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getPositions();
    });
  }

  _getPositions() {
    var myTask = widget.task;
    var renderRootTask = rootGlobalKey.currentContext;
    var renderUpdateTask = updateGlobalKey.currentContext;
    var rootHeight = renderRootTask?.size?.height;
    var updateHeight = renderUpdateTask?.size?.height;
    myTask.height = rootHeight ?? 0.0;
    myTask.updateHeight = updateHeight ?? 0.0;
    //print('result task == ( $myTask )');

    context
        .read<TaskBloc>()
        .add(RootTaskUpdateHeightsEvent(widget.task.id, myTask.height, myTask.updateHeight));
    context.read<ProviderBloc>().add(RootEvent());
  }

  _createRootKey() {
    GlobalKey myKey = GlobalKey();
    rootGlobalKey = myKey;
    //print('_createGlobalKey/ myGlobalKey == $myGlobalKey');
    return myKey;
  }

  _createUpdateKey() {
    GlobalKey myKey = GlobalKey();
    updateGlobalKey = myKey;
    //print('_createGlobalKey/ myGlobalKey == $myGlobalKey');
    return myKey;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, RootTaskState>(builder: (_, state) {
      if (state is RootTaskLoadSuccessState) {
        //var newTask = MyTask(text: task.text, id: task.id, rightMargin: task.rightMargin, height: task.height);

      }
      return Scaffold(
        appBar: AppBar(
          title: const Text('Checking height'),
        ),
        body: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Row(
              children: <Widget>[
                Container(
                  key: _createRootKey(),
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
                                  "${widget.task.text}",
                                ),
                              ),
                              OrientationBuilder(
                                builder: (context, orientation) {
                                  return orientation == Orientation.portrait
                                      ? _myLinearProcentIndicator(context,
                                          widget.task.completedTaskProcent)
                                      : _myLinearProcentIndicator(
                                          context,
                                          widget.task
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
                            "${widget.task.completedTaskCount} / ${widget.task.allTaskCount}"),
                      ),
                    ],
                  ),
                ),
                Container(
                  key: _createUpdateKey(),
                  margin: EdgeInsets.fromLTRB(20.0, 5.0, 10.0, 5.0),
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
                          margin: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: Text(" ${widget.task.text}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );

            /*AnimatedContainer(
                  key: _createGlobalKey(),
                  margin: standartMargin,
                  duration: const Duration(seconds: 1),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      widget.task.text,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  curve: Curves.slowMiddle,
                );*/
          },
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
      progressColor: Theme.of(context).primaryColor,
      linearStrokeCap: LinearStrokeCap.roundAll,
    );
  }
}

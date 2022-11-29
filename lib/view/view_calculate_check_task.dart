import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_sheduler/bloc/check_task_bloc.dart';
import 'package:task_sheduler/bloc/provider_bloc.dart';
import 'package:task_sheduler/bloc/root_task_bloc.dart';
import 'package:task_sheduler/database/check_task.dart';
import 'package:task_sheduler/database/check_task_event.dart';
import 'package:task_sheduler/database/check_task_state.dart';
import 'package:task_sheduler/database/root_task.dart';
import 'package:task_sheduler/database/root_task_event.dart';

class ViewCalculateCheckTaskPageState extends StatefulWidget {
  final CheckTaskNew task;
  final RootTaskNew perentTask;
  const ViewCalculateCheckTaskPageState(this.task, this.perentTask, {Key key})
      : super(key: key);

  @override
  createState() => _ViewCalculateCheckTaskPage();
}

class _ViewCalculateCheckTaskPage extends State<ViewCalculateCheckTaskPageState> {
  //final MyTask task;
  _ViewCalculateCheckTaskPage();

  var standartMargin = const EdgeInsets.fromLTRB(10, 1, 10, 1);
  GlobalKey checkGlobalKey = GlobalKey();
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
    var renderCheckTask = checkGlobalKey.currentContext;
    var renderUpdateTask = updateGlobalKey.currentContext;
    var checkHeight = renderCheckTask?.size?.height;
    var updateHeight = renderUpdateTask?.size?.height;
    myTask.height = checkHeight ?? 0;
    myTask.updateHeight = updateHeight ?? 0;
    //print('result task == ( $myTask )');

    context
        .read<CheckTaskBloc>()
        .add(CheckTaskUpdateHeightsEvent(widget.task.id, myTask.height, myTask.updateHeight));
    context.read<ProviderBloc>().add(CheckEvent(widget.perentTask));
  }

  _createCheckKey() {
    GlobalKey myKey = GlobalKey();
    checkGlobalKey = myKey;
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
    return BlocBuilder<CheckTaskBloc, CheckTaskState>(builder: (_, state) {
      if (state is CheckTaskLoadSuccessState) {
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
                  key: _createCheckKey(),
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
                          margin: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: Text(
                                  "${widget.task.text}",
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
                          value: widget.task.check == 1 ? true : false,
                          onChanged: (bool value) {
                            if (widget.task.check == 1) {
                              context.read<TaskBloc>().add(RootTaskUpdateCountEvent(
                                widget.perentTask.id,
                                0, -1
                              )
                                /*RootTaskUpdateEvent(
                                  widget.perentTask.id,
                                  0,
                                  widget.perentTask.text,
                                  -1,
                                  0)*/);
                            } else if (widget.task.check == 0) {
                              context.read<TaskBloc>().add(RootTaskUpdateCountEvent(
                                widget.perentTask.id,
                                0, 1
                              )
                                
                                /*RootTaskUpdateEvent(
                                  widget.perentTask.id,
                                  0,
                                  widget.perentTask.text,
                                  1,
                                  0)*/);
                            }
                            context.read<CheckTaskBloc>().add(
                                CheckTaskUpdateCheckBoxEvent(widget.task.id));
                          },
                        ),
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
                    color: Theme.of(context)
                        .textTheme
                        .headline6
                        .color, //Colors.white,
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
                                child: Text(
                                  " ${widget.task.text}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
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
          },
        ),
      );
    });
  }
}

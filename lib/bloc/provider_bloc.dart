//import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
//import '../view/loading_page.dart';
//import '../view/view_calculate_root_task.dart';
//import '../database/dbprovider.dart';

import '../database/root_task.dart';
import '../database/check_task.dart';

class ProviderEvent extends Equatable {
  ProviderEvent();

  @override
  List<Object> get props => [];
}

class LoadingEvent extends ProviderEvent {}

class RootEvent extends ProviderEvent {}

class ViewCalculateRootEvent extends ProviderEvent {
  final RootTaskNew task;

  ViewCalculateRootEvent(this.task);

  @override 
  List<Object> get props => [task];
}

class CheckEvent extends ProviderEvent {
  final RootTaskNew task;

  CheckEvent(this.task);

  @override
  List<Object> get props => [task];
}

class ViewCalculateCheckEvent extends ProviderEvent {
  final CheckTaskNew task;
  final RootTaskNew parentTask;

  ViewCalculateCheckEvent(this.task, this.parentTask);

  @override 
  List<Object> get props => [task, parentTask];
}

class DialogEvent extends ProviderEvent {
  final RootTaskNew rootTask;
  final CheckTaskNew checkTask;
  final bool changeObj;
  DialogEvent(this.changeObj, this.rootTask, this.checkTask);

  @override
  List<Object> get props => [changeObj, rootTask, checkTask];
}

class UpdateEvent extends ProviderEvent {
  final RootTaskNew rootTask;
  final CheckTaskNew checkTask;

  UpdateEvent(this.rootTask, this.checkTask);

  @override
  List<Object> get props => [rootTask, checkTask];
}

//@immutable
class ProviderState extends Equatable {
  ProviderState();

  @override
  List<Object> get props => [];
}

class LoadingState extends ProviderState {}

class RootState extends ProviderState {}

class ViewCalculateRootState extends ProviderState {
  final RootTaskNew task;

  ViewCalculateRootState(this.task);

  @override 
  List<Object> get props => [task];
}

class CheckState extends ProviderState {
  final RootTaskNew task;

  CheckState(this.task);

  @override
  List<Object> get props => [task];
}

class ViewCalculateCheckState extends ProviderState {
  final CheckTaskNew task;
  final RootTaskNew parentTask;

  ViewCalculateCheckState(this.task, this.parentTask);

  @override 
  List<Object> get props => [task, parentTask];
}

class DialogState extends ProviderState {
  final RootTaskNew rootTask;
  final CheckTaskNew checkTask;
  final bool changeObj;
  DialogState(this.changeObj, this.rootTask, this.checkTask);

  @override
  List<Object> get props => [changeObj, rootTask, checkTask];
}

class UpdateState extends ProviderState {
  final RootTaskNew rootTask;
  final CheckTaskNew checkTask;

  UpdateState(this.rootTask, this.checkTask);

  @override
  List<Object> get props => [rootTask, checkTask];
}

class ProviderBloc extends Bloc<ProviderEvent, ProviderState> {
  //final _database = RootDBProvider();

  ProviderBloc() : super(/*RootState()*/LoadingState()) {
    //LoadingState()) {
    on<LoadingEvent>(/*_loadToState*/(event, emit) => emit(LoadingState()));
    on<RootEvent>((event, emit)                   => emit(RootState()));
    on<ViewCalculateRootEvent>((event, emit)      => emit(ViewCalculateRootState(event.task)));
    on<ViewCalculateCheckEvent>((event, emit)     => emit(ViewCalculateCheckState(event.task, event.parentTask)));
    on<DialogEvent>((event, emit) =>
        emit(DialogState(event.changeObj, event.rootTask, event.checkTask)));
    on<UpdateEvent>(
        (event, emit) => emit(UpdateState(event.rootTask, event.checkTask)));
    on<CheckEvent>((event, emit)                  => emit(CheckState(event.task)));
  }

  /*_loadToState(LoadingEvent event, Emitter<ProviderState> emitter) async {
    
    List<RootTask> list = await _database.getAllTasks();
    //List<RootTaskNew> listNew = list;
    List<CheckTaskNew> listCheckNew = [];

    /*for (int i = 0; i < list.length; i++) {
      listCheck.addAll(await _database.getGroupTasksCheck(list[i].id));
    }*/

    //List<CheckTaskNew> listCheckNew = listCheck;

    for (int i = 0; i < list.length; i++) {
      //_database.newRootTask(listNew[i]);
      RootTaskNew task = new RootTaskNew(
        id: list[i].id,
        text: list[i].text,
        position: list[i].position,
        completedTaskCount: list[i].completedTaskCount,
        allTaskCount: list[i].allTaskCount,
        completedTaskProcent: list[i].completedTaskProcent,
        rightMargin: 10.0,
        height: 0.0,
        updateHeight: 0.0,
        updateRightMargin: 10.0,
      );
      _database.newRootTask(task);
      if (list[i].allTaskCount > 0) {
        listCheckNew.addAll(_getGroupCheckTasks(list[i].id));
      }
    }
    List<RootTaskNew> listNew = await _database.getAllNewRootTasks();
    
    print(list);
    if (list.length == listNew.length) {
      for (var i = 0; i < list.length; i++) {
        _database.deleteTask(list[i].id);
      }
    } else {
      print("_loadToState: list.length != listNew.length");
    }
    /*if (listCheck.length == listCheckNew.length) {
      for (var i = 0; i < listCheckNew.length; i++) {
        _database.deleteTaskCheck(listCheckNew[i].id);
      }
    } else {
      print("_loadToState: listCheck.length != listCheckNew.length");
    }*/
  }

  _getGroupCheckTasks(int id) async {
    List<CheckTask> list = await _database.getGroupTasksCheck(id);
    //List<CheckTaskNew> newList = [];
    for (var i = 0; i < list.length; i++) {
      CheckTaskNew task = new CheckTaskNew(
        id: list[i].id,
        text: list[i].text,
        position: list[i].position,
        rootID: list[i].rootID,
        check: list[i].check,
        height: 0.0,
        rightMargin: 10.0,
        updateHeight: 0.0,
        updateRightMargin: 10.0,
      );
      _database.newCheckTask(task);
      //newList.add(task);
    }
    _database.deleteGroupTasksCheck(id);
    List<CheckTaskNew> newList = await _database.getGroupNewTasksCheck(id);
    return newList;
  }*/
}

/*@override 
  Stream<ProviderState> mapEventToState(ProviderEvent event) async* {
    if(event is RootEvent) {
      yield RootState();
    } else if(event is DialogEvent) {
      yield DialogState(event.changeObj, event.rootTask, event.checkTask);
    } else if(event is UpdateEvent) {
      yield UpdateState(event.rootTask, event.checkTask);
    } else if(event is CheckEvent) {
      yield CheckState(event.task);
    }*/

/*class ProviderBloc extends Bloc<ProviderEvent, ProviderState> {
  ProviderBloc() : super(RootState());

  @override 
  Stream<ProviderState> mapEventToState(ProviderEvent event) async* {
    if(event is RootEvent) {
      yield RootState();
    } else if(event is DialogEvent) {
      yield DialogState(event.changeObj, event.rootTask, event.checkTask);
    } else if(event is UpdateEvent) {
      yield UpdateState(event.rootTask, event.checkTask);
    } else if(event is CheckEvent) {
      yield CheckState(event.task);
    }
  }
}*/

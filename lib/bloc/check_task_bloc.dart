import 'package:flutter_bloc/flutter_bloc.dart';

import '../database/dbprovider.dart';
import '../database/check_task.dart';
import '../database/check_task_event.dart';
import '../database/check_task_state.dart';

class CheckTaskBloc extends Bloc<CheckTaskEvent, CheckTaskState> {
  
  List<CheckTask> list = [];
  final _database = new RootDBProvider();

  CheckTaskBloc({this.list}) : super(CheckTaskLoadInProgressState()) {
    on<CheckTaskLoadSuccessEvent>(_taskLoadedToState);
    on<CheckTaskAddedEvent>(_taskAddedToState);
    on<CheckTaskUpdateEvent>(_taskUpdateToState);
    on<CheckTaskDeletedEvent>(_taskDeleteToState);
  }

  /*@override 
  Stream<CheckTaskState> mapEventToState(CheckTaskEvent event) async* {
    if(event is CheckTaskLoadSuccessEvent) {
      yield* _taskLoadedToState(event);
    } else if(event is CheckTaskAddedEvent) {
      yield* _taskAddedToState(event);
    } else if(event is CheckTaskUpdateEvent) {
      yield* _taskUpdateToState(event);
    } else if(event is CheckTaskDeletedEvent) {
      yield* _taskDeleteToState(event);
    }
  }*/

  //Stream<CheckTaskState> _taskLoadedToState(CheckTaskLoadSuccessEvent event) async* {
  _taskLoadedToState(CheckTaskLoadSuccessEvent event, Emitter<CheckTaskState> emit) async {
    try {
      print('event.rootID == ${event.rootID}');
      final newList = await _database.getGroupTasksCheck(event.rootID);
      //final newList = list;
      /*List<CheckTask> newList = [];
      for(int i = 0; i < list.length; i++) {
        if(list[i].rootID == event.rootID) { 
          newList.add(list[i]);
        }
      }
      for(var a in newList) {
        print('_taskLoadedToState(); a == ${a.toMap()}');
      }*/
      newList.sort((a,b) => a.position.compareTo(b.position));
      for(CheckTask element in newList) {
        print("element = ${element.toMap()}");
      }
      //yield CheckTaskLoadSuccessState(newList);
      emit(CheckTaskLoadSuccessState(newList));
      list = newList;
    } catch (_) {
      print('Fail _taskLoadedToState(); dbList');
      //yield CheckTaskLoadFailureState();
      emit(CheckTaskLoadFailureState());
    }
    //final db = list;
    //print('TaskLoadSuccessEvent to State; db == $db');
    //yield TaskLoadSuccessState(db);
  }

  //Stream<CheckTaskState> _taskAddedToState(CheckTaskAddedEvent event) async* {
  _taskAddedToState(CheckTaskAddedEvent event, Emitter<CheckTaskState> emit) async {
    if(state is CheckTaskLoadSuccessState) {
      CheckTask task;
      print('_taskAddedToState; list == $list');
      var newPosition = 1;
      for(var i in list) {
        if(i.rootID == event.rootId) {
          newPosition++;
        }
      }
      if(list.isEmpty) {
        print('list.isEmpty');
        task = new CheckTask(
          id: 1,
          position: 1,
          text: event.text,
          rootID: event.rootId,
          check: 0,
        );
      } else if(list.length > 0) {
          print('list.length > 0');
          task = new CheckTask(
          id: list[list.length -1].id +1,
          position: newPosition,
          text: event.text,
          rootID: event.rootId,
          check: 0,
        );
      }
      await _database.newTaskCheck(task);
      final newList = await _database.getGroupTasksCheck(event.rootId);
      //final newList = list;
      
      //newList.add(task);
      newList.sort((a,b) => a.position.compareTo(b.position));
      for(CheckTask element in newList) {
      print("element = ${element.toMap()}");
    }
      //yield CheckTaskLoadSuccessState(newList);
      emit(CheckTaskLoadSuccessState(newList));
      list = newList;
    }
  }

  //Stream<CheckTaskState> _taskUpdateToState(CheckTaskUpdateEvent event) async* {
  _taskUpdateToState(CheckTaskUpdateEvent event, Emitter<CheckTaskState> emit) async {
    //emit(CheckTaskLoadInProgressState());
    CheckTask updateTask;
    int updateTaskIndex;
    
    for(int i = 0; i < list.length; i++) {
      if(list[i].id == event.id) {
        print("if(list[i].id == event.id)");
        updateTask = list[i];
        updateTaskIndex = i;
      }
    }
    if(event.checkBox == true) {
      updateTask.check == 1 ? updateTask.check = 0 : updateTask.check = 1;
      _database.updateTaskCheck(updateTask);
    }
    if(event.newPosition == 0){
      print("if(event.newPosition == 0)");
      updateTask.text = event.newText;
    } else if(event.newPosition > 0) {
      print("if(event.newPosition > 0)");
      if((list[updateTaskIndex].position + event.newPosition) >= list.length) {
        print("if((list[updateTaskIndex].position + event.newPosition) >= list.length)");
        for(int i = 0; i < list.length; i++) {
          if(list[i].position > updateTask.position) {
            list[i].position -= 1;
            final task = list[i];
            _database.updateTaskCheck(task);
          }
        }
        updateTask.position = list.length;
      } else {
        print("else");
      for(int i = 0; i < list.length; i++) {
          if(list[i].position > updateTask.position && list[i].position <= 
          (updateTask.position + event.newPosition)) {
            print("if(list[i].position > updateTask.position && list[i].position < (updateTask.position + event.newPosition))");
            list[i].position -= 1;
            final task = list[i];
            _database.updateTaskCheck(task);
          }
        }
      updateTask.position += event.newPosition;
      }
    } else if(event.newPosition < 0) {
      print("if(event.newPosition < 0)");
      if((list[updateTaskIndex].position + event.newPosition) <= 1) {
        print("if((list[updateTaskIndex].position - event.newPosition) < 1)");
        for(int i = 0; i < list.length; i++) {
          if(list[i].position < updateTask.position) {
            list[i].position += 1;
            final task = list[i];
            _database.updateTaskCheck(task);
          }
        }
        updateTask.position = 1;
      } else {
      for(int i = 0; i < list.length; i++) {
        if(list[i].position < updateTask.position && list[i].position >= 
          (updateTask.position + event.newPosition)) {
            print("if(list[i].position < updateTask.position && list[i].position > (updateTask.position + event.newPosition))");
            list[i].position += 1;
            final task = list[i];
            _database.updateTaskCheck(task);
          }
      }
      updateTask.position += event.newPosition;
    }
    }
    //list[updateTaskIndex] = updateTask;

    await _database.updateTaskCheck(updateTask);
    final newList = await _database.getGroupTasksCheck(updateTask.rootID);
    //final newList = list;

    newList.sort((a,b) => a.position.compareTo(b.position));
    for(CheckTask element in newList) {
      print("element = ${element.toMap()}");
    }
    //yield CheckTaskLoadInProgressState();
    //yield CheckTaskLoadSuccessState(newList);
    emit(CheckTaskLoadSuccessState(newList));
    list = newList;
  }

  //Stream<CheckTaskState> _taskDeleteToState(CheckTaskDeletedEvent event) async* {
  _taskDeleteToState(CheckTaskDeletedEvent event, Emitter<CheckTaskState> emit) async {
    //emit(CheckTaskLoadInProgressState());
    if(state is CheckTaskLoadSuccessState) {
      print("_taskDeleteToState; state is TaskLoadSuccessState");
      /*  Debug version
      final listNew = (state as TaskLoadSuccessState).tasks;
      for (var i = 0; i < listNew.length; i++) {
      if(listNew[i].id == event.id) {
        listNew.removeAt(i);
        print("listNew[i].id == event.id");
      }
    }*/
    CheckTask deleteTask;
    //int updateTaskIndex;
    
    for(int i = 0; i < list.length; i++) {
      if(list[i].id == event.id) {
        print("if(list[i].id == event.id)");
        deleteTask = list[i];
        //updateTaskIndex = i;
      }
    }
    /*for(int i = 0; i < list.length; i++){
      if(list[i].position > updateTask.position) {
        final newTask = list[i];
        newTask.position -= 1;
        //print("${newTask.toMap()}");
        //await _database.updateTask(newTask);
      }
    }*/

    // Mobile version
    await _database.deleteTaskCheck(event.id);

    for(int i = 0; i < list.length; i++){
      if(list[i].position > deleteTask.position) {
        final newTask = list[i];
        newTask.position -= 1;
        print("${newTask.toMap()}");
        await _database.updateTaskCheck(newTask);
      }
    }

    final listNew = await _database.getGroupTasksCheck(deleteTask.rootID);
    //final listNew = list;

    // It Mobile and Debug version
    listNew.sort((a,b) => a.position.compareTo(b.position));
    for(CheckTask element in listNew) {
      print("new element == ${element.toMap()}");
    }

    //yield CheckTaskLoadInProgressState();
    //yield CheckTaskLoadSuccessState(listNew);
    emit(CheckTaskLoadInProgressState());
    emit(CheckTaskLoadSuccessState(listNew));
    list = listNew;
    }
  }
}
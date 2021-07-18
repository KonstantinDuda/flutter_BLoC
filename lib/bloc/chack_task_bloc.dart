import 'package:flutter_bloc/flutter_bloc.dart';

import '../database/dbprovider.dart';
import '../database/chack_task.dart';
import '../database/chack_task_event.dart';
import '../database/chack_task_state.dart';

class ChackTaskBloc extends Bloc<ChackTaskEvent, ChackTaskState> {
  
  List<ChackTask> list = [];
  //final _database = new RootDBProvider();

  ChackTaskBloc({this.list}) : super(ChackTaskLoadInProgressState());

  @override 
  Stream<ChackTaskState> mapEventToState(ChackTaskEvent event) async* {
    if(event is ChackTaskLoadSuccessEvent) {
      yield* _taskLoadedToState(event);
    } else if(event is ChackTaskAddedEvent) {
      yield* _taskAddedToState(event);
    } else if(event is ChackTaskUpdateEvent) {
      yield* _taskUpdateToState(event);
    } else if(event is ChackTaskDeletedEvent) {
      yield* _taskDeleteToState(event);
    }
  }

  Stream<ChackTaskState> _taskLoadedToState(ChackTaskLoadSuccessEvent event) async* {
    try {
      //final newList = await _database.getAllTasks();
      final newList = list;
      /*List<ChackTask> newList = [];
      for(int i = 0; i < list.length; i++) {
        if(list[i].rootID == event.rootID) { 
          newList.add(list[i]);
        }
      }*/
      print('_taskLoadedToState(); dbList == $newList');
      
      yield ChackTaskLoadSuccessState(newList);
      list = newList;
    } catch (_) {
      yield ChackTaskLoadFailureState();
    }
    //final db = list;
    //print('TaskLoadSuccessEvent to State; db == $db');
    //yield TaskLoadSuccessState(db);
  }

  Stream<ChackTaskState> _taskAddedToState(ChackTaskAddedEvent event) async* {
    if(state is ChackTaskLoadSuccessState) {
      ChackTask task;
      print('_taskAddedToState; list == $list');
      if(list.isEmpty) {
        print('list.isEmpty');
        task = new ChackTask(
          id: 1,
          position: 1,
          text: event.text,
          rootID: event.rootId,
          chack: false,
        );
      } else if(list.length > 0) {
          print('list.length > 0');
          task = new ChackTask(
          id: list[list.length -1].id +1,
          position: list.last.position +(1),
          text: event.text,
          rootID: event.rootId,
          chack: false,
        );
      }
      //await _database.newTask(task);
      //final newList = await _database.getAllTasks();
      final newList = list;
      
      newList.add(task);
      newList.sort((a,b) => a.position.compareTo(b.position));
      for(ChackTask element in newList) {
      print("element = ${element.toMap()}");
    }
      yield ChackTaskLoadSuccessState(newList);
      list = newList;
    }
  }

  Stream<ChackTaskState> _taskUpdateToState(ChackTaskUpdateEvent event) async* {

    ChackTask updateTask;
    int updateTaskIndex;
    
    for(int i = 0; i < list.length; i++) {
      if(list[i].id == event.id) {
        print("if(list[i].id == event.id)");
        updateTask = list[i];
        updateTaskIndex = i;
      }
    }
    if(event.chackBox == true) {
      updateTask.chack == true ? updateTask.chack = false : updateTask.chack = true;
    } else if(event.newPosition == 0){
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
            //_database.updateTask(task);
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
            //_database.updateTask(task);
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
            //_database.updateTask(task);
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
            //_database.updateTask(task);
          }
      }
      updateTask.position += event.newPosition;
    }
    }
    //list[updateTaskIndex] = updateTask;

    //await _database.updateTask(updateTask);
    //final newList = await _database.getAllTasks();
    final newList = list;

    newList.sort((a,b) => a.position.compareTo(b.position));
    for(ChackTask element in newList) {
      print("element = ${element.toMap()}");
    }
    yield ChackTaskLoadInProgressState();
    yield ChackTaskLoadSuccessState(newList);
    list = newList;
  }

  Stream<ChackTaskState> _taskDeleteToState(ChackTaskDeletedEvent event) async* {
    if(state is ChackTaskLoadSuccessState) {
      print("_taskDeleteToState; state is TaskLoadSuccessState");
      /*  Debug version
      final listNew = (state as TaskLoadSuccessState).tasks;
      for (var i = 0; i < listNew.length; i++) {
      if(listNew[i].id == event.id) {
        listNew.removeAt(i);
        print("listNew[i].id == event.id");
      }
    }*/
    ChackTask updateTask;
    //int updateTaskIndex;
    
    for(int i = 0; i < list.length; i++) {
      if(list[i].id == event.id) {
        print("if(list[i].id == event.id)");
        updateTask = list[i];
        //updateTaskIndex = i;
      }
    }
    for(int i = 0; i < list.length; i++){
      if(list[i].position > updateTask.position) {
        final newTask = list[i];
        newTask.position -= 1;
        //print("${newTask.toMap()}");
        //await _database.updateTask(newTask);
      }
    }

    // Mobile version
    //await _database.deleteTask(event.id);
    //final listNew = await _database.getAllTasks();
    final listNew = list;

    // It Mobile and Debug version
    listNew.sort((a,b) => a.position.compareTo(b.position));
    for(ChackTask element in listNew) {
      print("new element == ${element.toMap()}");
    }

    // TODO исправить все подобные случаи, возможно созданием конструктора копирования
    yield ChackTaskLoadInProgressState();
    yield ChackTaskLoadSuccessState(listNew);
    list = listNew;
    }
  }
}
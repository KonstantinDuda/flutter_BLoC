import 'package:flutter_bloc/flutter_bloc.dart';

import '../database/dbprovider.dart';
import '../database/task.dart';
import '../database/task_event.dart';
import '../database/task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  
  List<Task> list = [];
  //final _database = new RootDBProvider();

  TaskBloc({this.list}) : super(TaskLoadInProgressState());

  @override 
  Stream<TaskState> mapEventToState(TaskEvent event) async* {
    if(event is TaskLoadSuccessEvent) {
      yield* _taskLoadedToState();
    } else if(event is TaskAddedEvent) {
      yield* _taskAddedToState(event);
    } else if(event is TaskUpdateEvent) {
      yield* _taskUpdateToState(event);
    } else if(event is TaskDeletedEvent) {
      yield* _taskDeleteToState(event);
    }
  }

  Stream<TaskState> _taskLoadedToState() async* {
    try {
      //final newList = await _database.getAllTasks();
      final newList = list;
      print('_taskLoadedToState(); dbList == $newList');
      
      yield TaskLoadSuccessState(newList);
      list = newList;
    } catch (_) {
      yield TaskLoadFailureState();
    }
    //final db = list;
    //print('TaskLoadSuccessEvent to State; db == $db');
    //yield TaskLoadSuccessState(db);
  }

  Stream<TaskState> _taskAddedToState(TaskAddedEvent event) async* {
    if(state is TaskLoadSuccessState) {
      Task task;
      print('_taskAddedToState; list == $list');
      if(list.isEmpty) {
        print('list.isEmpty');
        task = new Task(
          id: 1,
          position: 1,
          text: event.text,
          allTaskCount: 0,
          completedTaskCount: 0,
          completedTaskProcent: 0.0,
        );
      } else if(list.length > 0) {
          print('list.length > 0');
          task = new Task(
          id: list[list.length -1].id +1,
          position: list.last.position +(1),
          text: event.text,
          allTaskCount: 0,
          completedTaskCount: 0,
          completedTaskProcent: 0.0,
        );
      }
      //await _database.newTask(task);
      //final newList = await _database.getAllTasks();
      final newList = list;
      
      //list.add(task);
      newList.sort((a,b) => a.position.compareTo(b.position));
      for(Task element in newList) {
      print("element = ${element.toMap()}");
    }
      yield TaskLoadSuccessState(newList);
      list = newList;
    }
  }

  Stream<TaskState> _taskUpdateToState(TaskUpdateEvent event) async* {

    Task updateTask;
    int updateTaskIndex;
    
    for(int i = 0; i < list.length; i++) {
      if(list[i].id == event.id) {
        print("if(list[i].id == event.id)");
        updateTask = list[i];
        updateTaskIndex = i;
      }
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
    for(Task element in newList) {
      print("element = ${element.toMap()}");
    }
    yield TaskLoadInProgressState();
    yield TaskLoadSuccessState(newList);
    list = newList;
  }

  Stream<TaskState> _taskDeleteToState(TaskDeletedEvent event) async* {
    if(state is TaskLoadSuccessState) {
      print("_taskDeleteToState; state is TaskLoadSuccessState");
      /*  Debug version
      final listNew = (state as TaskLoadSuccessState).tasks;
      for (var i = 0; i < listNew.length; i++) {
      if(listNew[i].id == event.id) {
        listNew.removeAt(i);
        print("listNew[i].id == event.id");
      }
    }*/
    Task updateTask;
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
    for(Task element in listNew) {
      print("new element == ${element.toMap()}");
    }

    yield TaskLoadInProgressState();
    yield TaskLoadSuccessState(listNew);
    list = listNew;
    }
  }
}
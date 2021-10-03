import 'package:flutter_bloc/flutter_bloc.dart';

import '../database/dbprovider.dart';
import '../database/root_task.dart';
import '../database/root_task_event.dart';
import '../database/root_task_state.dart';

class TaskBloc extends Bloc<RootTaskEvent, RootTaskState> {
  
  List<RootTask> list = [];
  final _database = new RootDBProvider();

  TaskBloc({this.list}) : super(RootTaskLoadInProgressState());

  @override 
  Stream<RootTaskState> mapEventToState(RootTaskEvent event) async* {
    if(event is RootTaskLoadSuccessEvent) {
      yield* _taskLoadedToState();
    } else if(event is RootTaskAddedEvent) {
      yield* _taskAddedToState(event);
    } else if(event is RootTaskUpdateEvent) {
      yield* _taskUpdateToState(event);
    } else if(event is RootTaskDeletedEvent) {
      yield* _taskDeleteToState(event);
    }
  }

  Stream<RootTaskState> _taskLoadedToState() async* {
    try {
      final newList = await _database.getAllTasks();
      //final newList = list;
      print('_taskLoadedToState(); dbList == $newList');
      
      newList.sort((a,b) => a.position.compareTo(b.position));
      for(RootTask element in newList) {
        print("element = ${element.toMap()}");
      }

      yield RootTaskLoadSuccessState(newList);
      list = newList;
    } catch (_) {
      print('Fail Root _taskLoadedToState(); dbList');
      yield RootTaskLoadFailureState();
    }
    //final db = list;
    //print('TaskLoadSuccessEvent to State; db == $db');
    //yield TaskLoadSuccessState(db);
  }

  Stream<RootTaskState> _taskAddedToState(RootTaskAddedEvent event) async* {
    if(state is RootTaskLoadSuccessState) {
      RootTask task;
      print('_taskAddedToState; list == $list');
      if(list.isEmpty) {
        print('list.isEmpty');
        task = new RootTask(
          id: 1,
          position: 1,
          text: event.text,
          allTaskCount: 0,
          completedTaskCount: 0,
          completedTaskProcent: 0.0,
        );
      } else if(list.length > 0) {
          print('list.length > 0');
          task = new RootTask(
          id: list[list.length -1].id +1,
          position: list.last.position +(1),
          text: event.text,
          allTaskCount: 0,
          completedTaskCount: 0,
          completedTaskProcent: 0.0,
        );
      }
      await _database.newTask(task);
      final newList = await _database.getAllTasks();
      //final newList = list;
      
      //newList.add(task);
      newList.sort((a,b) => a.position.compareTo(b.position));
      for(RootTask element in newList) {
      print("element = ${element.toMap()}");
    }
      yield RootTaskLoadSuccessState(newList);
      list = newList;
    }
  }

  Stream<RootTaskState> _taskUpdateToState(RootTaskUpdateEvent event) async* {

    RootTask updateTask;
    int updateTaskIndex;
    //int completedTaskCount;
    int allTaskCount;
    
    for(int i = 0; i < list.length; i++) {
      if(list[i].id == event.id) {
        print("if(list[i].id == event.id)");
        updateTask = list[i];
        updateTaskIndex = i;
        //completedTaskCount = list[i].completedTaskCount;
        allTaskCount = list[i].allTaskCount;
      }
    }
    print("allTaskCount == $allTaskCount");

    if(event.allTaskCount > 0) {
      updateTask.allTaskCount++;
      updateTask.completedTaskProcent = _newCompletedTaskProcent(updateTask.allTaskCount, updateTask.completedTaskCount);
      _database.updateTask(updateTask);
      //print("updateTask.completedTaskProcent event.allTaskCount > 0== ${updateTask.completedTaskProcent}");
    } else if(event.allTaskCount < 0) {
      updateTask.allTaskCount--;
      var list = await _database.getGroupTasksCheck(updateTask.id);
      var completedTaskCount = 0;
      for(var i in list) {
        if (i.check > 0) completedTaskCount++;
      }
      updateTask.completedTaskCount = completedTaskCount;
      updateTask.completedTaskProcent = _newCompletedTaskProcent(updateTask.allTaskCount, updateTask.completedTaskCount);
      _database.updateTask(updateTask);
      //print("updateTask.completedTaskProcent event.allTaskCount < 0== ${updateTask.completedTaskProcent}");
    }
    if(event.completedTaskCount > 0) {
      updateTask.completedTaskCount++;
      updateTask.completedTaskProcent = _newCompletedTaskProcent(updateTask.allTaskCount, updateTask.completedTaskCount);
      _database.updateTask(updateTask);
      //print("updateTask.completedTaskProcent event.completedTaskCount > 0== ${updateTask.completedTaskProcent}");
    } else if(event.completedTaskCount < 0) {
      updateTask.completedTaskCount--;
      updateTask.completedTaskProcent = _newCompletedTaskProcent(updateTask.allTaskCount, updateTask.completedTaskCount);
      _database.updateTask(updateTask);
      //print("updateTask.completedTaskProcent event.completedTaskCount < 0== ${updateTask.completedTaskProcent}");
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
            _database.updateTask(task);
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
            _database.updateTask(task);
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
            _database.updateTask(task);
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
            _database.updateTask(task);
          }
      }
      updateTask.position += event.newPosition;
    }
    }
    //list[updateTaskIndex] = updateTask;

    await _database.updateTask(updateTask);
    final newList = await _database.getAllTasks();
    //final newList = list;

    newList.sort((a,b) => a.position.compareTo(b.position));
    for(RootTask element in newList) {
      print("element = ${element.toMap()}");
    }
    yield RootTaskLoadInProgressState();
    yield RootTaskLoadSuccessState(newList);
    list = newList;
  }

  Stream<RootTaskState> _taskDeleteToState(RootTaskDeletedEvent event) async* {
    if(state is RootTaskLoadSuccessState) {
      print("_taskDeleteToState; state is TaskLoadSuccessState");
      /*  Debug version
      final listNew = (state as TaskLoadSuccessState).tasks;
      for (var i = 0; i < listNew.length; i++) {
      if(listNew[i].id == event.id) {
        listNew.removeAt(i);
        print("listNew[i].id == event.id");
      }
    }*/
    RootTask deleteTask;
    //int updateTaskIndex;
    
    for(int i = 0; i < list.length; i++) {
      if(list[i].id == event.id) {
        print("if(list[i].id == event.id)");
        deleteTask = list[i];
        //updateTaskIndex = i;
      }
    }

    // Mobile version
    if(deleteTask.allTaskCount > 0)
      await _database.deleteGroupTasksCheck(event.id);

    for(int i = 0; i < list.length; i++){
      if(list[i].position > deleteTask.position) {
        final newTask = list[i];
        newTask.position -= 1;
        print("${newTask.toMap()}");
        await _database.updateTask(newTask);
      }
    }

    await _database.deleteTask(event.id);
    final listNew = await _database.getAllTasks();
    
    //final listNew = list;

    // It Mobile and Debug version
    listNew.sort((a,b) => a.position.compareTo(b.position));
    for(RootTask element in listNew) {
      print("new element == ${element.toMap()}");
    }

    yield RootTaskLoadInProgressState();
    yield RootTaskLoadSuccessState(listNew);
    list = listNew;
    }
  }

  double _newCompletedTaskProcent(int all, int completed) {
    if(all == 0)
      return 0.0;

    return completed * 100 / all / 100;
  }
}
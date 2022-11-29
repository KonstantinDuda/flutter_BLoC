import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:task_sheduler/database/check_task.dart';

import '../database/dbprovider.dart';
import '../database/root_task.dart';
import '../database/root_task_event.dart';
import '../database/root_task_state.dart';

class TaskBloc extends Bloc<RootTaskEvent, RootTaskState> {
  List<RootTaskNew> list = [];
  var screenHeight = 0.0;
  var buttonHeight = 0.0;
  var buttonsHeight = 0.0;
  final _database = new RootDBProvider();

  TaskBloc({this.list}) : super(RootTaskLoadInProgressState()) {
    on<RootTaskFirstLoadEvent>(_firstLoadToState);
    on<RootTaskLoadSuccessEvent>(_taskLoadedToState);
    on<RootTaskAddedEvent>(_taskAddedToState);
    //on<RootTaskUpdateEvent>(_taskUpdateToState);
    on<RootTaskUpdateTextEvent>(_taskUpdateTextToState);
    on<RootTaskUpdateCountEvent>(_taskUpdateCountToState);
    on<RootTaskUpdatePositionEvent>(_taskUpdatePositionToState);
    on<RootTaskUpdateMarginsEvent>(_taskUpdateMarginsToState);
    on<RootTaskUpdateHeightsEvent>(_taskUpdateHeightsToState);
    on<RootTaskDeletedEvent>(_taskDeleteToState);
  }

  /*@override 
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
  }*/

  _firstLoadToState(
      RootTaskFirstLoadEvent event, Emitter<RootTaskState> emit) async {
    screenHeight = event.screenHeight;
    buttonHeight = event.buttonHeight;
    buttonsHeight = event.buttonsHeight;

    //List<RootTask> oldList = await _database.getAllTasks();
    

    /*if (oldList.length != 0 && oldList != null) {
      print("oldList.length != 0 && oldList != null");
      for (int i = 0; i < oldList.length; i++) {
        RootTaskNew task = new RootTaskNew(
          id: oldList[i].id,
          text: oldList[i].text,
          position: oldList[i].position,
          completedTaskCount: oldList[i].completedTaskCount,
          allTaskCount: oldList[i].allTaskCount,
          completedTaskProcent: oldList[i].completedTaskProcent,
          rightMargin: 0.0,
          height: 0.0,
          updateHeight: 0.0,
          updateRightMargin: 0.0,
        );
        _database.newRootTask(task);
        _getGroupCheckTasks(task.id);
        _database.deleteTask(oldList[i].id);
      }
    }*/

    emit(RootTaskLoadSuccessState(list));
  }

  /*_getGroupCheckTasks(int id) async {
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
        rightMargin: 0.0,
        updateHeight: 0.0,
        updateRightMargin: 0.0,
      );
      _database.newCheckTask(task);
    }
    _database.deleteGroupTasksCheck(id);
  }*/

  _taskLoadedToState(
      RootTaskLoadSuccessEvent event, Emitter<RootTaskState> emit) async {
    try {
      final newList = await _database.getAllNewRootTasks();

      print('_taskLoadedToState(); dbList == $newList');

      newList.sort((a, b) => a.position.compareTo(b.position));
      for (RootTaskNew element in newList) {
        print("element = ${element.toMap()}");
      }

      emit(RootTaskLoadSuccessState(newList));
      list = newList;
    } catch (_) {
      print('Fail Root _taskLoadedToState(); dbList');
      emit(RootTaskLoadFailureState());
    }
  }

  /*Stream<RootTaskState> _taskLoadedToState() async* {
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
  }*/

  //Stream<RootTaskState> _taskAddedToState(RootTaskAddedEvent event) async* {
  _taskAddedToState(
      RootTaskAddedEvent event, Emitter<RootTaskState> emit) async {
    if (state is RootTaskLoadSuccessState) {
      RootTaskNew task;
      print('_taskAddedToState; list == $list');
      if (list.isEmpty) {
        print('list.isEmpty');
        task = new RootTaskNew(
          id: 1,
          position: 1,
          text: event.text,
          allTaskCount: 0,
          completedTaskCount: 0,
          completedTaskProcent: 0.0,
          rightMargin: 0.0,
          height: 0.0,
          updateRightMargin: 0.0,
          updateHeight: 0.0,
        );
      } else if (list.length > 0) {
        print('list.length > 0');
        task = new RootTaskNew(
          id: list[list.length - 1].id + 1,
          position: list.last.position + (1),
          text: event.text,
          allTaskCount: 0,
          completedTaskCount: 0,
          completedTaskProcent: 0.0,
          rightMargin: 0.0,
          height: 0.0,
          updateRightMargin: 0.0,
          updateHeight: 0.0,
        );
      }
      await _database.newRootTask(task);
      final newList = await _database.getAllNewRootTasks();
      //final newList = list;

      //newList.add(task);
      newList.sort((a, b) => a.position.compareTo(b.position));
      for (RootTaskNew element in newList) {
        print("element = ${element.toMap()}");
      }
      //yield RootTaskLoadSuccessState(newList);
      emit(RootTaskLoadSuccessState(newList));
      list = newList;
    }
  }

  //Stream<RootTaskState> _taskUpdateToState(RootTaskUpdateEvent event) async* {
  /*_taskUpdateToState(
      RootTaskUpdateEvent event, Emitter<RootTaskState> emit) async {
    //emit(RootTaskLoadInProgressState());
    RootTaskNew updateTask;
    int updateTaskIndex;
    //int completedTaskCount;
    int allTaskCount;

    for (int i = 0; i < list.length; i++) {
      if (list[i].id == event.id) {
        print("if(list[i].id == event.id)");
        updateTask = list[i];
        updateTaskIndex = i;
        //completedTaskCount = list[i].completedTaskCount;
        allTaskCount = list[i].allTaskCount;
      }
    }
    print("allTaskCount == $allTaskCount");

    if (event.allTaskCount > 0) {
      updateTask.allTaskCount++;
      updateTask.completedTaskProcent = _newCompletedTaskProcent(
          updateTask.allTaskCount, updateTask.completedTaskCount);
      _database.updateNewRootTask(updateTask);
      //print("updateTask.completedTaskProcent event.allTaskCount > 0== ${updateTask.completedTaskProcent}");
    } else if (event.allTaskCount < 0) {
      updateTask.allTaskCount--;
      var list = await _database.getGroupNewTasksCheck(updateTask.id);
      var completedTaskCount = 0;
      for (var i in list) {
        if (i.check > 0) completedTaskCount++;
      }
      updateTask.completedTaskCount = completedTaskCount;
      updateTask.completedTaskProcent = _newCompletedTaskProcent(
          updateTask.allTaskCount, updateTask.completedTaskCount);
      _database.updateNewRootTask(updateTask);
      //print("updateTask.completedTaskProcent event.allTaskCount < 0== ${updateTask.completedTaskProcent}");
    }
    if (event.completedTaskCount > 0) {
      updateTask.completedTaskCount++;
      updateTask.completedTaskProcent = _newCompletedTaskProcent(
          updateTask.allTaskCount, updateTask.completedTaskCount);
      _database.updateNewRootTask(updateTask);
      //print("updateTask.completedTaskProcent event.completedTaskCount > 0== ${updateTask.completedTaskProcent}");
    } else if (event.completedTaskCount < 0) {
      updateTask.completedTaskCount--;
      updateTask.completedTaskProcent = _newCompletedTaskProcent(
          updateTask.allTaskCount, updateTask.completedTaskCount);
      _database.updateNewRootTask(updateTask);
      //print("updateTask.completedTaskProcent event.completedTaskCount < 0== ${updateTask.completedTaskProcent}");
    }

    if (event.newPosition == 0) {
      print("if(event.newPosition == 0)");
      updateTask.text = event.newText;
    } else if (event.newPosition > 0) {
      print("if(event.newPosition > 0)");
      if ((list[updateTaskIndex].position + event.newPosition) >= list.length) {
        print(
            "if((list[updateTaskIndex].position + event.newPosition) >= list.length)");
        for (int i = 0; i < list.length; i++) {
          if (list[i].position > updateTask.position) {
            list[i].position -= 1;
            final task = list[i];
            _database.updateNewRootTask(task);
          }
        }
        updateTask.position = list.length;
      } else {
        print("else");
        for (int i = 0; i < list.length; i++) {
          if (list[i].position > updateTask.position &&
              list[i].position <= (updateTask.position + event.newPosition)) {
            print(
                "if(list[i].position > updateTask.position && list[i].position < (updateTask.position + event.newPosition))");
            list[i].position -= 1;
            final task = list[i];
            _database.updateNewRootTask(task);
          }
        }
        updateTask.position += event.newPosition;
      }
    } else if (event.newPosition < 0) {
      print("if(event.newPosition < 0)");
      if ((list[updateTaskIndex].position + event.newPosition) <= 1) {
        print("if((list[updateTaskIndex].position - event.newPosition) < 1)");
        for (int i = 0; i < list.length; i++) {
          if (list[i].position < updateTask.position) {
            list[i].position += 1;
            final task = list[i];
            _database.updateNewRootTask(task);
          }
        }
        updateTask.position = 1;
      } else {
        for (int i = 0; i < list.length; i++) {
          if (list[i].position < updateTask.position &&
              list[i].position >= (updateTask.position + event.newPosition)) {
            print(
                "if(list[i].position < updateTask.position && list[i].position > (updateTask.position + event.newPosition))");
            list[i].position += 1;
            final task = list[i];
            _database.updateNewRootTask(task);
          }
        }
        updateTask.position += event.newPosition;
      }
    }
    //list[updateTaskIndex] = updateTask;

    await _database.updateNewRootTask(updateTask);
    final newList = await _database.getAllNewRootTasks();
    //final newList = list;

    newList.sort((a, b) => a.position.compareTo(b.position));
    for (RootTaskNew element in newList) {
      print("element = ${element.toMap()}");
    }
    //yield RootTaskLoadInProgressState();
    //yield RootTaskLoadSuccessState(newList);
    emit(RootTaskLoadSuccessState(newList));
    list = newList;
  }*/

  _taskUpdateTextToState(
      RootTaskUpdateTextEvent event, Emitter<RootTaskState> emit) async {
    RootTaskNew updateTask = _findUpdateTask(event.id);

    if (updateTask != null) {
      updateTask.text = event.newText;
    }

    await _database.updateNewRootTask(updateTask);
    final newList = await _database.getAllNewRootTasks();

    emit(RootTaskLoadSuccessState(newList));
    list = newList;
  }

  _taskUpdateCountToState(
      RootTaskUpdateCountEvent event, Emitter<RootTaskState> emit) async {
    RootTaskNew updateTask = _findUpdateTask(event.id);

    if (updateTask != null) {
      if (event.allTaskCount > 0) {
        updateTask.allTaskCount++;
        updateTask.completedTaskProcent = _newCompletedTaskProcent(
            updateTask.allTaskCount, updateTask.completedTaskCount);
        //_database.updateNewRootTask(updateTask);
        //print("updateTask.completedTaskProcent event.allTaskCount > 0== ${updateTask.completedTaskProcent}");
      } else if (event.allTaskCount < 0) {
        updateTask.allTaskCount--;
        var list = await _database.getGroupNewTasksCheck(updateTask.id);
        var completedTaskCount = 0;
        for (var i in list) {
          if (i.check > 0) completedTaskCount++;
        }
        updateTask.completedTaskCount = completedTaskCount;
        updateTask.completedTaskProcent = _newCompletedTaskProcent(
            updateTask.allTaskCount, updateTask.completedTaskCount);
        //_database.updateNewRootTask(updateTask);
        //print("updateTask.completedTaskProcent event.allTaskCount < 0== ${updateTask.completedTaskProcent}");
      }
      if (event.completedTaskCount > 0) {
        updateTask.completedTaskCount++;
        updateTask.completedTaskProcent = _newCompletedTaskProcent(
            updateTask.allTaskCount, updateTask.completedTaskCount);
        //_database.updateNewRootTask(updateTask);
        //print("updateTask.completedTaskProcent event.completedTaskCount > 0== ${updateTask.completedTaskProcent}");
      } else if (event.completedTaskCount < 0) {
        updateTask.completedTaskCount--;
        updateTask.completedTaskProcent = _newCompletedTaskProcent(
            updateTask.allTaskCount, updateTask.completedTaskCount);
        //_database.updateNewRootTask(updateTask);
        //print("updateTask.completedTaskProcent event.completedTaskCount < 0== ${updateTask.completedTaskProcent}");
      }
    }

    await _database.updateNewRootTask(updateTask);
    final newList = await _database.getAllNewRootTasks();

    emit(RootTaskLoadSuccessState(newList));
    list = newList;
  }

  _taskUpdatePositionToState(
      RootTaskUpdatePositionEvent event, Emitter<RootTaskState> emit) async {
    RootTaskNew updateTask = _findUpdateTask(event.id);
    int updateTaskIndex;
    for (var i = 0; i < list.length; i++) {
      if (list[i].id == updateTask.id) {
        updateTaskIndex = i;
      }
    }

    if (updateTask != null) {
      if (event.newPosition > 0) {
        //print("if(event.newPosition > 0)");
        if ((list[updateTaskIndex].position + event.newPosition) >=
            list.length) {
          //print(
          //  "if((list[updateTaskIndex].position + event.newPosition) >= list.length)");
          for (int i = 0; i < list.length; i++) {
            if (list[i].position > updateTask.position) {
              list[i].position -= 1;
              final task = list[i];
              _database.updateNewRootTask(task);
            }
          }
          updateTask.position = list.length;
        } else {
          //print("else");
          for (int i = 0; i < list.length; i++) {
            if (list[i].position > updateTask.position &&
                list[i].position <= (updateTask.position + event.newPosition)) {
              //print(
              //  "if(list[i].position > updateTask.position && list[i].position < (updateTask.position + event.newPosition))");
              list[i].position -= 1;
              final task = list[i];
              _database.updateNewRootTask(task);
            }
          }
          updateTask.position += event.newPosition;
        }
      } else if (event.newPosition < 0) {
        //print("if(event.newPosition < 0)");
        if ((list[updateTaskIndex].position + event.newPosition) <= 1) {
          //print("if((list[updateTaskIndex].position - event.newPosition) < 1)");
          for (int i = 0; i < list.length; i++) {
            if (list[i].position < updateTask.position) {
              list[i].position += 1;
              final task = list[i];
              _database.updateNewRootTask(task);
            }
          }
          updateTask.position = 1;
        } else {
          for (int i = 0; i < list.length; i++) {
            if (list[i].position < updateTask.position &&
                list[i].position >= (updateTask.position + event.newPosition)) {
              //print(
              //  "if(list[i].position < updateTask.position && list[i].position > (updateTask.position + event.newPosition))");
              list[i].position += 1;
              final task = list[i];
              _database.updateNewRootTask(task);
            }
          }
          updateTask.position += event.newPosition;
        }
      }
    }

    await _database.updateNewRootTask(updateTask);
    final newList = await _database.getAllNewRootTasks();

    emit(RootTaskLoadSuccessState(newList));
    list = newList;
  }

  _taskUpdateMarginsToState(
      RootTaskUpdateMarginsEvent event, Emitter<RootTaskState> emit) async {
    RootTaskNew updateTask; // = _findUpdateTask(event.id);
    var indexUpdateTask;

    print('_taskUpdateMarginsToState. screenHeight == $screenHeight');
    print('_taskUpdateMarginsToState. buttonHeight == $buttonHeight');
    print('_taskUpdateMarginsToState. buttonsHeight == $buttonsHeight');

    for (int i = 0; i < list.length; i++) {
      if (list[i].id == event.id) {
        updateTask = list[i];
        print('updateTask == $updateTask,  index == $i');
        indexUpdateTask = i;
      }
    }
    var standartMargin = 10.0;
    var bigMargin =
        buttonHeight + 20; // 56 standart height button + margin (20)
    var updateMargin = buttonsHeight + 30;
    var heightButton = 0.0;
    var heightUpdateButtons = 0.0;
    var heightScreenWithoutButton = screenHeight;
    var heightScreenWithoutUpdateButtons = screenHeight;
    //var calculatePositionTask = 0.0;
    //var calculateUpdatePositionTask = 0.0;

    if (buttonHeight > 1.0) {
      heightButton =
          buttonHeight + 71; // 56 standart height appBar:leading + margin (15)
      heightUpdateButtons =
          heightButton + buttonHeight; // TODO Нужно откорректировать
      heightScreenWithoutButton -= heightButton;
      heightScreenWithoutUpdateButtons -= heightUpdateButtons;
    }

    if (updateTask != null) {
      if (updateTask.rightMargin == 0.0) {
        /*var heightButton = 0.0;
        var heightUpdateButtons = 0.0;
      var heightScreenWithoutButton = screenHeight;
      var heightScreenWithoutUpdateButtons = screenHeight;
      var calculatePositionTask = 0.0;
      var calculateUpdatePositionTask = 0.0;

      if(buttonHeight > 1.0) {
        heightButton = buttonHeight + 71; // 56 standart height appBar:leading + margin (15)
        heightUpdateButtons = heightButton + buttonHeight; // TODO Нужно откорректировать
        heightScreenWithoutButton -= heightButton;
        heightScreenWithoutUpdateButtons -= heightUpdateButtons;
      }*/
        /*for(int i=0; i<list.length; i++){
        calculatePositionTask += list[i].height;
        calculateUpdatePositionTask += list[i].updateHeight;
        if(calculatePositionTask < heightScreenWithoutButton) {
          list[i].rightMargin = 10.0;
          //_database.updateNewRootTask(list[i]);
        } else {
          list[i].rightMargin = buttonHeight + 20; // 56 standart height button + margin (20)
          //_database.updateNewRootTask(list[i]);
        }
        if(calculateUpdatePositionTask < heightScreenWithoutUpdateButtons) {
          list[i].updateRightMargin = 10.0;
          //_database.updateNewRootTask(list[i]);
        } else {
          list[i].updateRightMargin = buttonsHeight + 20; // 56 standart height button + margin (20)
          //_database.updateNewRootTask(list[i]);
        }
        //_database.updateNewRootTask(list[i]);
      }*/

        if (indexUpdateTask > 0) {
          if (list[indexUpdateTask - 1].rightMargin != standartMargin) {
            updateTask.rightMargin = bigMargin;
          } else {
            var calculatePositionTask;
            for (var i = 0; i < indexUpdateTask; i++) {
              calculatePositionTask += list[i].height;
              if (calculatePositionTask < heightScreenWithoutButton) {
                updateTask.rightMargin = standartMargin;
              } else {
                updateTask.rightMargin = bigMargin;
              }
            }
          }
        } else {
          updateTask.height < heightScreenWithoutButton
              ? updateTask.rightMargin = standartMargin
              : updateTask.rightMargin = bigMargin;
        }
      } else if (updateTask.rightMargin == standartMargin) {
        updateTask.rightMargin = bigMargin;
      } else if (updateTask.rightMargin == bigMargin) {
        updateTask.rightMargin = standartMargin;
      }

      if (updateTask.updateRightMargin == 0.0) {
        if (indexUpdateTask > 0) {
          if (list[indexUpdateTask - 1].updateRightMargin != standartMargin) {
            updateTask.updateRightMargin = updateMargin;
          } else {
            var updateCalculatePositionTask;
            for (var i = 0; i < indexUpdateTask; i++) {
              updateCalculatePositionTask += list[i].updateHeight;
              if (updateCalculatePositionTask <
                  heightScreenWithoutUpdateButtons) {
                updateTask.updateRightMargin = standartMargin;
              } else {
                updateTask.updateRightMargin = updateMargin;
              }
            }
          }
        } else {
          updateTask.updateHeight < heightScreenWithoutUpdateButtons
              ? updateTask.updateRightMargin = standartMargin
              : updateTask.updateRightMargin = updateMargin;
        }
      } else if (updateTask.updateRightMargin == standartMargin) {
        updateTask.updateRightMargin = updateMargin;
      } else if (updateTask.updateRightMargin == updateMargin) {
        updateTask.updateRightMargin = standartMargin;
      }
      //updateTask.rightMargin = event.margin;
      //updateTask.updateRightMargin = event.updateMargin;
      //RootTaskNew updateTask = _findUpdateTask(event.id);
      /*var heightButton = 0.0;
      var heightUpdateButtons = 0.0;
      var heightScreenWithoutButton = screenHeight;
      var heightScreenWithoutUpdateButtons = screenHeight;
      var calculatePositionTask = 0.0;
      var calculateUpdatePositionTask = 0.0;

      if(buttonHeight > 1.0) {
        heightButton = buttonHeight + 71; // 56 standart height appBar:leading + margin (15)
        heightUpdateButtons = heightButton + buttonHeight; // TODO Нужно откорректировать
        heightScreenWithoutButton -= heightButton;
        heightScreenWithoutUpdateButtons -= heightUpdateButtons;
      } 
      for(int i=0; i<list.length; i++){
        calculatePositionTask += list[i].height;
        calculateUpdatePositionTask += list[i].updateHeight;
        if(calculatePositionTask < heightScreenWithoutButton) {
          list[i].rightMargin = 10.0;
        } else {
          list[i].rightMargin = buttonHeight + 20; // 56 standart height button + margin (20)
        }
        if(calculateUpdatePositionTask < heightScreenWithoutUpdateButtons) {
          list[i].updateRightMargin = 10.0;
        } else {
          list[i].updateRightMargin = buttonsHeight + 20; // 56 standart height button + margin (20)
        }
      }*/

    }

    await _database.updateNewRootTask(updateTask);
    final newList = await _database.getAllNewRootTasks();

    emit(RootTaskLoadSuccessState(newList));
    list = newList;
  }

  _taskUpdateHeightsToState(
      RootTaskUpdateHeightsEvent event, Emitter<RootTaskState> emit) async {
    RootTaskNew updateTask = _findUpdateTask(event.id);

    if (updateTask != null) {
      updateTask.height = event.height;
      updateTask.updateHeight = event.updateHeight;
    }

    await _database.updateNewRootTask(updateTask);
    final newList = await _database.getAllNewRootTasks();

    emit(RootTaskLoadSuccessState(newList));
    list = newList;
  }

  _findUpdateTask(int id) {
    RootTaskNew updateTask;

    for (int i = 0; i < list.length; i++) {
      if (list[i].id == id) {
        updateTask = list[i];
        return updateTask;
      }
    }
    return null;
  }

  //Stream<RootTaskState> _taskDeleteToState(RootTaskDeletedEvent event) async* {
  _taskDeleteToState(
      RootTaskDeletedEvent event, Emitter<RootTaskState> emit) async {
    //emit(RootTaskLoadInProgressState());
    if (state is RootTaskLoadSuccessState) {
      print("_taskDeleteToState; state is TaskLoadSuccessState");
      /*  Debug version
      final listNew = (state as TaskLoadSuccessState).tasks;
      for (var i = 0; i < listNew.length; i++) {
      if(listNew[i].id == event.id) {
        listNew.removeAt(i);
        print("listNew[i].id == event.id");
      }
    }*/
      RootTaskNew deleteTask;
      //int updateTaskIndex;

      for (int i = 0; i < list.length; i++) {
        if (list[i].id == event.id) {
          print("if(list[i].id == event.id)");
          deleteTask = list[i];
          //updateTaskIndex = i;
        }
      }

      // Mobile version
      if (deleteTask.allTaskCount > 0)
        await _database.deleteGroupNewCheckTasks(event.id);

      for (int i = 0; i < list.length; i++) {
        if (list[i].position > deleteTask.position) {
          final newTask = list[i];
          newTask.position -= 1;
          print("${newTask.toMap()}");
          await _database.updateNewRootTask(newTask);
        }
      }

      await _database.deleteNewRootTask(event.id);
      final listNew = await _database.getAllNewRootTasks();

      //final listNew = list;

      // It Mobile and Debug version
      listNew.sort((a, b) => a.position.compareTo(b.position));
      for (RootTaskNew element in listNew) {
        print("new element == ${element.toMap()}");
      }

      //yield RootTaskLoadInProgressState();
      //yield RootTaskLoadSuccessState(listNew);
      emit(RootTaskLoadSuccessState(listNew));
      list = listNew;
    }
  }

  //_calculateMargin(int id) {}

  double _newCompletedTaskProcent(int all, int completed) {
    if (all == 0) return 0.0;

    return completed * 100 / all / 100;
  }
}

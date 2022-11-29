import 'package:flutter_bloc/flutter_bloc.dart';

import '../database/dbprovider.dart';
import '../database/check_task.dart';
import '../database/check_task_event.dart';
import '../database/check_task_state.dart';

class CheckTaskBloc extends Bloc<CheckTaskEvent, CheckTaskState> {
  List<CheckTaskNew> list = [];
  var screenHeight = 0.0;
  var buttonHeight = 0.0;
  var buttonsHeight = 0.0;
  final _database = new RootDBProvider();

  CheckTaskBloc({this.list}) : super(CheckTaskLoadInProgressState()) {
    on<CheckTaskFirstLoadEvent>(_checkTaskFirstLoadEvent);
    on<CheckTaskLoadSuccessEvent>(_taskLoadedToState);
    on<CheckTaskAddedEvent>(_taskAddedToState);
    //on<CheckTaskUpdateEvent>(_taskUpdateToState);
    on<CheckTaskUpdateTextEvent>(_checkTaskUpdateTextEvent);
    on<CheckTaskUpdatePositionEvent>(_checkTaskUpdatePositionEvent);
    on<CheckTaskUpdateCheckBoxEvent>(_checkTaskUpdateCheckBoxEvent);
    on<CheckTaskUpdateMarginsEvent>(_checkTaskUpdateMarginsEvent);
    on<CheckTaskUpdateHeightsEvent>(_checkTaskUpdateHeightsEvent);
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

  _checkTaskFirstLoadEvent(
      CheckTaskFirstLoadEvent event, Emitter<CheckTaskState> emit) async {
    screenHeight = event.screenHeight;
    buttonHeight = event.buttonHeight;
    buttonsHeight = event.buttonsHeight;
    emit(CheckTaskLoadSuccessState(list));
  }

  //Stream<CheckTaskState> _taskLoadedToState(CheckTaskLoadSuccessEvent event) async* {
  _taskLoadedToState(
      CheckTaskLoadSuccessEvent event, Emitter<CheckTaskState> emit) async {
    try {
      print('event.rootID == ${event.rootID}');
      final newList = await _database.getGroupNewTasksCheck(event.rootID);
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
      newList.sort((a, b) => a.position.compareTo(b.position));
      for (CheckTaskNew element in newList) {
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
  _taskAddedToState(
      CheckTaskAddedEvent event, Emitter<CheckTaskState> emit) async {
    if (state is CheckTaskLoadSuccessState) {
      CheckTaskNew task;
      print('_taskAddedToState; list == $list');
      var newPosition = 1;
      for (var i in list) {
        if (i.rootID == event.rootId) {
          newPosition++;
        }
      }
      if (list.isEmpty) {
        print('list.isEmpty');
        task = new CheckTaskNew(
          id: 1,
          position: 1,
          text: event.text,
          rootID: event.rootId,
          check: 0,
          height: 0.0,
          rightMargin: 10.0,
          updateHeight: 0.0,
          updateRightMargin: 10.0,
        );
      } else if (list.length > 0) {
        print('list.length > 0');
        task = new CheckTaskNew(
          id: list[list.length - 1].id + 1,
          position: newPosition,
          text: event.text,
          rootID: event.rootId,
          check: 0,
          height: 0.0,
          rightMargin: 10.0,
          updateHeight: 0.0,
          updateRightMargin: 10.0,
        );
      }
      await _database.newCheckTask(task);
      final newList = await _database.getGroupNewTasksCheck(event.rootId);
      //final newList = list;

      //newList.add(task);
      newList.sort((a, b) => a.position.compareTo(b.position));
      for (CheckTaskNew element in newList) {
        print("element = ${element.toMap()}");
      }
      //yield CheckTaskLoadSuccessState(newList);
      emit(CheckTaskLoadSuccessState(newList));
      list = newList;
    }
  }

  //Stream<CheckTaskState> _taskUpdateToState(CheckTaskUpdateEvent event) async* {
  /*_taskUpdateToState(CheckTaskUpdateEvent event, Emitter<CheckTaskState> emit) async {
    //emit(CheckTaskLoadInProgressState());
    CheckTaskNew updateTask;
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
      _database.updateNewCheckTask(updateTask);
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
            _database.updateNewCheckTask(task);
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
            _database.updateNewCheckTask(task);
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
            _database.updateNewCheckTask(task);
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
            _database.updateNewCheckTask(task);
          }
      }
      updateTask.position += event.newPosition;
    }
    }
    //list[updateTaskIndex] = updateTask;

    await _database.updateNewCheckTask(updateTask);
    final newList = await _database.getGroupNewTasksCheck(updateTask.rootID);
    //final newList = list;

    newList.sort((a,b) => a.position.compareTo(b.position));
    for(CheckTaskNew element in newList) {
      print("element = ${element.toMap()}");
    }
    //yield CheckTaskLoadInProgressState();
    //yield CheckTaskLoadSuccessState(newList);
    emit(CheckTaskLoadSuccessState(newList));
    list = newList;
  }*/

  _checkTaskUpdateTextEvent(
      CheckTaskUpdateTextEvent event, Emitter<CheckTaskState> emit) async {
    CheckTaskNew updateTask = _findUpdateTask(event.id);

    if (updateTask != null) {
      updateTask.text = event.newText;
    }

    await _finalUpdateTask(updateTask, emit);
  }

  _checkTaskUpdatePositionEvent(
      CheckTaskUpdatePositionEvent event, Emitter<CheckTaskState> emit) async {
    CheckTaskNew updateTask = _findUpdateTask(event.id);

    if (updateTask != null) {
      if (event.newPosition > 0) {
        //print("if(event.newPosition > 0)");
        if ((updateTask.position + event.newPosition) >= list.length) {
          //print("if((list[updateTaskIndex].position + event.newPosition) >= list.length)");
          for (int i = 0; i < list.length; i++) {
            if (list[i].position > updateTask.position) {
              list[i].position -= 1;
              final task = list[i];
              _database.updateNewCheckTask(task);
            }
          }
          updateTask.position = list.length;
        } else {
          //print("else");
          for (int i = 0; i < list.length; i++) {
            if (list[i].position > updateTask.position &&
                list[i].position <= (updateTask.position + event.newPosition)) {
              //print("if(list[i].position > updateTask.position && list[i].position < (updateTask.position + event.newPosition))");
              list[i].position -= 1;
              final task = list[i];
              _database.updateNewCheckTask(task);
            }
          }
          updateTask.position += event.newPosition;
        }
      } else if (event.newPosition < 0) {
        //print("if(event.newPosition < 0)");
        if ((updateTask.position + event.newPosition) <= 1) {
          //print("if((list[updateTaskIndex].position - event.newPosition) < 1)");
          for (int i = 0; i < list.length; i++) {
            if (list[i].position < updateTask.position) {
              list[i].position += 1;
              final task = list[i];
              _database.updateNewCheckTask(task);
            }
          }
          updateTask.position = 1;
        } else {
          for (int i = 0; i < list.length; i++) {
            if (list[i].position < updateTask.position &&
                list[i].position >= (updateTask.position + event.newPosition)) {
              //print("if(list[i].position < updateTask.position && list[i].position > (updateTask.position + event.newPosition))");
              list[i].position += 1;
              final task = list[i];
              _database.updateNewCheckTask(task);
            }
          }
          updateTask.position += event.newPosition;
        }
      }
    }

    await _finalUpdateTask(updateTask, emit);
  }

  _checkTaskUpdateCheckBoxEvent(
      CheckTaskUpdateCheckBoxEvent event, Emitter<CheckTaskState> emit) async {
    CheckTaskNew updateTask = _findUpdateTask(event.id);

    updateTask.check == 1 ? updateTask.check = 0 : updateTask.check = 1;

    await _finalUpdateTask(updateTask, emit);
    /*await _database.updateNewCheckTask(updateTask);
    final newList = await _database.getGroupNewTasksCheck(updateTask.rootID);

    newList.sort((a,b) => a.position.compareTo(b.position));
    for(CheckTaskNew element in newList) {
      print("element = ${element.toMap()}");
    }

    emit(CheckTaskLoadSuccessState(newList));
    list = newList;*/
  }

  _checkTaskUpdateMarginsEvent(
      CheckTaskUpdateMarginsEvent event, Emitter<CheckTaskState> emit) async {
    CheckTaskNew updateTask; // = _findUpdateTask(event.id);
    var indexUpdateTask;
    for (int i = 0; i < list.length; i++) {
      if (list[i].id == event.id) {
        updateTask = list[i];
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
      await _finalUpdateTask(updateTask, emit);
    }
  }

  _checkTaskUpdateHeightsEvent(
      CheckTaskUpdateHeightsEvent event, Emitter<CheckTaskState> emit) async {
    CheckTaskNew updateTask = _findUpdateTask(event.id);

    if (updateTask != null) {
      updateTask.height = event.height;
      updateTask.updateHeight = event.updateHeight;
    }

    await _finalUpdateTask(updateTask, emit);
  }

  _findUpdateTask(int id) {
    CheckTaskNew updateTask;

    for (int i = 0; i < list.length; i++) {
      if (list[i].id == id) {
        updateTask = list[i];
        return updateTask;
      }
    }
    return null;
  }

  _finalUpdateTask(
      CheckTaskNew updateTask, Emitter<CheckTaskState> emit) async {
    await _database.updateNewCheckTask(updateTask);
    final newList = await _database.getGroupNewTasksCheck(updateTask.rootID);

    newList.sort((a, b) => a.position.compareTo(b.position));
    for (CheckTaskNew element in newList) {
      print("element = ${element.toMap()}");
    }

    emit(CheckTaskLoadSuccessState(newList));
    list = newList;
  }

  //Stream<CheckTaskState> _taskDeleteToState(CheckTaskDeletedEvent event) async* {
  _taskDeleteToState(
      CheckTaskDeletedEvent event, Emitter<CheckTaskState> emit) async {
    //emit(CheckTaskLoadInProgressState());
    if (state is CheckTaskLoadSuccessState) {
      print("_taskDeleteToState; state is TaskLoadSuccessState");
      /*  Debug version
      final listNew = (state as TaskLoadSuccessState).tasks;
      for (var i = 0; i < listNew.length; i++) {
      if(listNew[i].id == event.id) {
        listNew.removeAt(i);
        print("listNew[i].id == event.id");
      }
    }*/
      CheckTaskNew deleteTask;
      //int updateTaskIndex;

      for (int i = 0; i < list.length; i++) {
        if (list[i].id == event.id) {
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
      await _database.deleteNewCheckTask(event.id);

      for (int i = 0; i < list.length; i++) {
        if (list[i].position > deleteTask.position) {
          final newTask = list[i];
          newTask.position -= 1;
          print("${newTask.toMap()}");
          await _database.updateNewCheckTask(newTask);
        }
      }

      final listNew = await _database.getGroupNewTasksCheck(deleteTask.rootID);
      //final listNew = list;

      // It Mobile and Debug version
      listNew.sort((a, b) => a.position.compareTo(b.position));
      for (CheckTaskNew element in listNew) {
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

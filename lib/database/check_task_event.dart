import 'package:equatable/equatable.dart';
//import 'package:task_sheduler/database/check_task_state.dart';
//import 'task.dart';

// События
class CheckTaskEvent extends Equatable {
  CheckTaskEvent(); 

  @override 
  List<Object> get props => [];
}

// Событие удачной загрузки 
class CheckTaskLoadSuccessEvent extends CheckTaskEvent {
  final int rootID;
  

  CheckTaskLoadSuccessEvent(this.rootID);

  @override
  List<Object> get props => [rootID];
}

class CheckTaskFirstLoadEvent extends CheckTaskEvent {
  final double screenHeight;
  final double buttonHeight;
  final double buttonsHeight;

  CheckTaskFirstLoadEvent(this.screenHeight, this.buttonHeight, this.buttonsHeight);

  @override 
  List<Object> get props => [screenHeight, buttonHeight, buttonsHeight];
}
// Ошибка загрузки
//class TaskLoadFailureEvent extends TaskEvent {}

// Событие добавления обьекта
class CheckTaskAddedEvent extends CheckTaskEvent {
  final String text;
  final int rootId;

  CheckTaskAddedEvent(this.text, this.rootId);

  @override 
  List<Object> get props => [text, rootId];
}

// Событие обновления обьекта
/*class CheckTaskUpdateEvent extends CheckTaskEvent {
  final int id;
  final int newPosition;
  final String newText;
  final bool checkBox;

  CheckTaskUpdateEvent(this.id, this.newPosition, this.newText, this.checkBox);

  @override 
  List<Object> get props => [id, newPosition, newText, checkBox];
}*/

class CheckTaskUpdateTextEvent extends CheckTaskEvent {
  final int id;
  final String newText;

  CheckTaskUpdateTextEvent(this.id, this.newText);

  @override 
  List<Object> get props => [id, newText];
}

class CheckTaskUpdatePositionEvent extends CheckTaskEvent {
  final int id;
  final int newPosition;

  CheckTaskUpdatePositionEvent(this.id, this.newPosition);

  @override 
  List<Object> get props => [id, newPosition];
}

class CheckTaskUpdateCheckBoxEvent extends CheckTaskEvent {
  final int id;
  //final bool checkBox;

  CheckTaskUpdateCheckBoxEvent(this.id);

  @override 
  List<Object> get props => [id];
}

class CheckTaskUpdateMarginsEvent extends CheckTaskEvent {
  final int id;

  CheckTaskUpdateMarginsEvent(this.id);

  @override 
  List<Object> get props => [id];
}

class CheckTaskUpdateHeightsEvent extends CheckTaskEvent {
  final int id;
  final double height;
  final double updateHeight;

  CheckTaskUpdateHeightsEvent(this.id, this.height, this.updateHeight);

  @override 
  List<Object> get props => [id, height, updateHeight];
}

// События удаления обьекта
class CheckTaskDeletedEvent extends CheckTaskEvent {
  final int id;

  CheckTaskDeletedEvent(this.id);

  @override 
  List<Object> get props => [id];
}
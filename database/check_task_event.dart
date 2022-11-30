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
class CheckTaskUpdateEvent extends CheckTaskEvent {
  final int id;
  final int newPosition;
  final String newText;
  final bool checkBox;

  CheckTaskUpdateEvent(this.id, this.newPosition, this.newText, this.checkBox);

  @override 
  List<Object> get props => [id, newPosition, newText, checkBox];
}

// События удаления обьекта
class CheckTaskDeletedEvent extends CheckTaskEvent {
  final int id;

  CheckTaskDeletedEvent(this.id);

  @override 
  List<Object> get props => [id];
}
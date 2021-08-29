import 'package:equatable/equatable.dart';
//import 'package:task_sheduler/database/chack_task_state.dart';
//import 'task.dart';

// События
class ChackTaskEvent extends Equatable {
  ChackTaskEvent(); 

  @override 
  List<Object> get props => [];
}

// Событие удачной загрузки 
class ChackTaskLoadSuccessEvent extends ChackTaskEvent {
  final int rootID;
  

  ChackTaskLoadSuccessEvent(this.rootID);

  @override
  List<Object> get props => [rootID];
}
// Ошибка загрузки
//class TaskLoadFailureEvent extends TaskEvent {}

// Событие добавления обьекта
class ChackTaskAddedEvent extends ChackTaskEvent {
  final String text;
  final int rootId;

  ChackTaskAddedEvent(this.text, this.rootId);

  @override 
  List<Object> get props => [text, rootId];
}

// Событие обновления обьекта
class ChackTaskUpdateEvent extends ChackTaskEvent {
  final int id;
  final int newPosition;
  final String newText;
  final bool chackBox;

  ChackTaskUpdateEvent(this.id, this.newPosition, this.newText, this.chackBox);

  @override 
  List<Object> get props => [id, newPosition, newText, chackBox];
}

// События удаления обьекта
class ChackTaskDeletedEvent extends ChackTaskEvent {
  final int id;

  ChackTaskDeletedEvent(this.id);

  @override 
  List<Object> get props => [id];
}
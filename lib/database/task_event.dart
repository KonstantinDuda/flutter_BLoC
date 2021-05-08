import 'package:equatable/equatable.dart';
//import 'task.dart';

// События
class TaskEvent extends Equatable {
  TaskEvent(); 

  @override 
  List<Object> get props => [];
}

// Событие удачной загрузки 
class TaskLoadSuccessEvent extends TaskEvent {}
// Ошибка загрузки
//class TaskLoadFailureEvent extends TaskEvent {}

// Событие добавления обьекта
class TaskAddedEvent extends TaskEvent {
  final String text;

  TaskAddedEvent(this.text);

  @override 
  List<Object> get props => [text];
}

// Событие обновления обьекта
class TaskUpdateEvent extends TaskEvent {
  final int id;
  final int newPosition;
  final String newText;

  TaskUpdateEvent(this.id, this.newPosition, this.newText);

  @override 
  List<Object> get props => [id, newPosition, newText];
}

// События удаления обьекта
class TaskDeletedEvent extends TaskEvent {
  final int id;

  TaskDeletedEvent(this.id);

  @override 
  List<Object> get props => [id];
}
import 'package:equatable/equatable.dart';
//import 'task.dart';

// События
class RootTaskEvent extends Equatable {
  RootTaskEvent(); 

  @override 
  List<Object> get props => [];
}

// Событие удачной загрузки 
class RootTaskLoadSuccessEvent extends RootTaskEvent {}
// Ошибка загрузки
//class TaskLoadFailureEvent extends TaskEvent {}

// Событие добавления обьекта
class RootTaskAddedEvent extends RootTaskEvent {
  final String text;

  RootTaskAddedEvent(this.text);

  @override 
  List<Object> get props => [text];
}

// Событие обновления обьекта
class RootTaskUpdateEvent extends RootTaskEvent {
  final int id;
  final int newPosition;
  final String newText;
  final int completedTaskCount;
  final int allTaskCount;

  RootTaskUpdateEvent(this.id, this.newPosition, this.newText, this.completedTaskCount, this.allTaskCount);

  @override 
  List<Object> get props => [id, newPosition, newText, completedTaskCount, allTaskCount];
}

// События удаления обьекта
class RootTaskDeletedEvent extends RootTaskEvent {
  final int id;

  RootTaskDeletedEvent(this.id);

  @override 
  List<Object> get props => [id];
}
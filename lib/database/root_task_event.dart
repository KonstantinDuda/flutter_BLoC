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

class RootTaskFirstLoadEvent extends RootTaskEvent {
  final double screenHeight;
  final double buttonHeight;
  final double buttonsHeight;

  RootTaskFirstLoadEvent(this.screenHeight, this.buttonHeight, this.buttonsHeight);

  @override 
  List<Object> get props => [screenHeight, buttonHeight, buttonsHeight];
}

// Событие добавления обьекта
class RootTaskAddedEvent extends RootTaskEvent {
  final String text;

  RootTaskAddedEvent(this.text);

  @override 
  List<Object> get props => [text];
}

// Событие обновления обьекта
/*class RootTaskUpdateEvent extends RootTaskEvent {
  final int id;
  final int newPosition;
  final String newText;
  final int completedTaskCount;
  final int allTaskCount;

  RootTaskUpdateEvent(this.id, this.newPosition, this.newText, this.completedTaskCount, this.allTaskCount);

  @override 
  List<Object> get props => [id, newPosition, newText, completedTaskCount, allTaskCount];
}*/

class RootTaskUpdateTextEvent extends RootTaskEvent {
  final int id;
  final String newText;

  RootTaskUpdateTextEvent(this.id, this.newText);

  @override 
  List<Object> get props => [id, newText];
}

class RootTaskUpdateCountEvent extends RootTaskEvent {
  final int id;
  final int allTaskCount;
  final int completedTaskCount;

  RootTaskUpdateCountEvent(this.id, this.allTaskCount, this.completedTaskCount);

  @override 
  List<Object> get props => [id, allTaskCount, completedTaskCount];
}

class RootTaskUpdatePositionEvent extends RootTaskEvent {
  final int id;
  final int newPosition;

  RootTaskUpdatePositionEvent(this.id, this.newPosition);

  @override 
  List<Object> get props => [id, newPosition];
}

class RootTaskUpdateMarginsEvent extends RootTaskEvent {
  final int id;
  //final double margin;
  //final double updateMargin;

  RootTaskUpdateMarginsEvent(this.id,/* this.margin, this.updateMargin*/);

  @override 
  List<Object> get props => [id/*, margin, updateMargin*/];
}

class RootTaskUpdateHeightsEvent extends RootTaskEvent {
  final int id;
  final double height;
  final double updateHeight;

  RootTaskUpdateHeightsEvent(this.id, this.height, this.updateHeight);

  @override 
  List<Object> get props => [id, height, updateHeight];
}

// События удаления обьекта
class RootTaskDeletedEvent extends RootTaskEvent {
  final int id;

  RootTaskDeletedEvent(this.id);

  @override 
  List<Object> get props => [id];
}
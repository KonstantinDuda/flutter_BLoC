import 'package:equatable/equatable.dart';
import 'task.dart';

class TaskState extends Equatable {
  TaskState();

  @override 
  List<Object> get props => [];
}
// Состояние загрузки 
class TaskLoadInProgressState extends TaskState {}

// Состояние успешно загруженных данных
class TaskLoadSuccessState extends TaskState {
  final List<Task> tasks;

  TaskLoadSuccessState([this.tasks]);

  @override 
  List<Object> get props => [tasks];
}

// Состояние ошибки при загрузке
class TaskLoadFailureState extends TaskState {}
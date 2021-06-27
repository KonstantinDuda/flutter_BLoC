import 'package:equatable/equatable.dart';
import 'root_task.dart';

class RootTaskState extends Equatable {
  RootTaskState();

  @override 
  List<Object> get props => [];
}
// Состояние загрузки 
class TaskLoadInProgressState extends RootTaskState {}

// Состояние успешно загруженных данных
class TaskLoadSuccessState extends RootTaskState {
  final List<RootTask> tasks;

  TaskLoadSuccessState([this.tasks]);

  @override 
  List<Object> get props => [tasks];
}

// Состояние ошибки при загрузке
class TaskLoadFailureState extends RootTaskState {}
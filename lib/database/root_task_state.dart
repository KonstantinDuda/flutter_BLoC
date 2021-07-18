import 'package:equatable/equatable.dart';
import 'root_task.dart';

class RootTaskState extends Equatable {
  RootTaskState();

  @override 
  List<Object> get props => [];
}
// Состояние загрузки 
class RootTaskLoadInProgressState extends RootTaskState {}

// Состояние успешно загруженных данных
class RootTaskLoadSuccessState extends RootTaskState {
  final List<RootTask> tasks;

  RootTaskLoadSuccessState([this.tasks]);

  @override 
  List<Object> get props => [tasks];
}

// Состояние ошибки при загрузке
class RootTaskLoadFailureState extends RootTaskState {}
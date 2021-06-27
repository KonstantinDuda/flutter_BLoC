import 'package:equatable/equatable.dart';
import 'chack_task.dart';

class ChackTaskState extends Equatable {
  ChackTaskState();

  @override 
  List<Object> get props => [];
}
// Состояние загрузки 
class TaskLoadInProgressState extends ChackTaskState {}

// Состояние успешно загруженных данных
class TaskLoadSuccessState extends ChackTaskState {
  final List<ChackTask> tasks;

  TaskLoadSuccessState([this.tasks]);

  @override 
  List<Object> get props => [tasks];
}

// Состояние ошибки при загрузке
class TaskLoadFailureState extends ChackTaskState {}
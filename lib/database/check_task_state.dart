import 'package:equatable/equatable.dart';
import 'check_task.dart';

class CheckTaskState extends Equatable {
  CheckTaskState();

  @override 
  List<Object> get props => [];
}
// Состояние загрузки 
class CheckTaskLoadInProgressState extends CheckTaskState {}

// Состояние успешно загруженных данных
class CheckTaskLoadSuccessState extends CheckTaskState {
  final List<CheckTask> tasks;

  CheckTaskLoadSuccessState([this.tasks]);

  @override 
  List<Object> get props => [tasks];
}

// Состояние ошибки при загрузке
class CheckTaskLoadFailureState extends CheckTaskState {}
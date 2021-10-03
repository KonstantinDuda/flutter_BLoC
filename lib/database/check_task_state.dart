import 'package:equatable/equatable.dart';
import 'chack_task.dart';

class ChackTaskState extends Equatable {
  ChackTaskState();

  @override 
  List<Object> get props => [];
}
// Состояние загрузки 
class ChackTaskLoadInProgressState extends ChackTaskState {}

// Состояние успешно загруженных данных
class ChackTaskLoadSuccessState extends ChackTaskState {
  final List<ChackTask> tasks;

  ChackTaskLoadSuccessState([this.tasks]);

  @override 
  List<Object> get props => [tasks];
}

// Состояние ошибки при загрузке
class ChackTaskLoadFailureState extends ChackTaskState {}

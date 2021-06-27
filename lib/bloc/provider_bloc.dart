//import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../database/root_task.dart';
import '../database/chack_task.dart';

class ProviderEvent extends Equatable {
  ProviderEvent();

  @override 
  List<Object> get props => [];
}

class RootEvent extends ProviderEvent {}
class ChackEvent extends ProviderEvent {
  final RootTask task;

  ChackEvent(this.task);

  @override 
  List<Object> get props => [task];
}

class DialogEvent extends ProviderEvent {
  final RootTask rootTask;
  final ChackTask chackTask;
  final bool changeObj;
  DialogEvent(this.changeObj , this.rootTask, this.chackTask);

  @override 
  List<Object> get props => [changeObj , rootTask, chackTask];
}

class UpdateEvent extends ProviderEvent {
  final RootTask task;

  UpdateEvent(this.task);

  @override 
  List<Object> get props => [task];
}

//@immutable 
class ProviderState  extends Equatable{
  ProviderState();

  @override 
  List<Object> get props => [];
}

class RootState extends ProviderState {}
class ChackState extends ProviderState {
  final RootTask task;

  ChackState(this.task);

  @override 
  List<Object> get props => [task];
}

class DialogState extends ProviderState {
  final RootTask rootTask;
  final ChackTask chackTask;
  final bool changeObj;
  DialogState(this.changeObj, this.rootTask, this.chackTask);

  @override 
  List<Object> get props => [changeObj, rootTask, chackTask];
}

class UpdateState extends ProviderState {
  final RootTask task;

  UpdateState(this.task);

  @override 
  List<Object> get props => [task];
}

class ProviderBloc extends Bloc<ProviderEvent, ProviderState> {
  ProviderBloc() : super(RootState());

  @override 
  Stream<ProviderState> mapEventToState(ProviderEvent event) async* {
    if(event is RootEvent) {
      yield RootState();
    } else if(event is DialogEvent) {
      yield DialogState(event.changeObj, event.rootTask, event.chackTask);
    } else if(event is UpdateEvent) {
      yield UpdateState(event.task);
    } else if(event is ChackEvent) {
      yield ChackState(event.task);
    }
  }
}
/*import 'package:flutter_bloc/flutter_bloc.dart';

enum ProviderEvent {rootPage, chackPage, dialog}

//@immutable 
abstract class ProviderState {}

class RootState extends ProviderState {}

class ChackState extends ProviderState {}

class DialogState extends ProviderState {}

class ProviderBloc extends Bloc<ProviderEvent, ProviderState> {
  ProviderBloc() : super(RootState());

  @override 
  Stream<ProviderState> mapEventToState(ProviderEvent event) async* {
    switch (event) {
      case ProviderEvent.rootPage:
        yield RootState();
        break;
      case ProviderEvent.chackPage:
        yield ChackState();
        break;
      case ProviderEvent.dialog:
        yield DialogState();
        break;
    }
  }
}*/
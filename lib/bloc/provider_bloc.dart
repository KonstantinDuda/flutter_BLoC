//import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../database/task.dart';

class ProviderEvent extends Equatable {
  ProviderEvent();

  @override 
  List<Object> get props => [];
}

class RootEvent extends ProviderEvent {}

class DialogEvent extends ProviderEvent {
  final Task task;

  DialogEvent(this.task);

  @override 
  List<Object> get props => [task];
}

class UpdateEvent extends ProviderEvent {
  final Task task;

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

class DialogState extends ProviderState {
  final Task task;

  DialogState(this.task);

  @override 
  List<Object> get props => [task];
}

class UpdateState extends ProviderState {
  final Task task;

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
      yield DialogState(event.task);
    } else if(event is UpdateEvent) {
      yield UpdateState(event.task);
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
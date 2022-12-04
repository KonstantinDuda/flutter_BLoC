//import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../database/root_task.dart';
import '../database/check_task.dart';

class ProviderEvent extends Equatable {
  ProviderEvent();

  @override
  List<Object> get props => [];
}

class RootEvent extends ProviderEvent {}

class CheckEvent extends ProviderEvent {
  final RootTask task;

  CheckEvent(this.task);

  @override
  List<Object> get props => [task];
}

class DialogEvent extends ProviderEvent {
  final RootTask rootTask;
  final CheckTask checkTask;
  final bool changeObj;
  DialogEvent(this.changeObj, this.rootTask, this.checkTask);

  @override
  List<Object> get props => [changeObj, rootTask, checkTask];
}

class UpdateEvent extends ProviderEvent {
  final RootTask rootTask;
  final CheckTask checkTask;

  UpdateEvent(this.rootTask, this.checkTask);

  @override
  List<Object> get props => [rootTask, checkTask];
}

class HorizontalEvent extends ProviderEvent {
  final RootTask rootTask;

  HorizontalEvent(this.rootTask);

  @override
  List<Object> get props => [rootTask];
}

//@immutable
class ProviderState extends Equatable {
  ProviderState();

  @override
  List<Object> get props => [];
}

class RootState extends ProviderState {}

class CheckState extends ProviderState {
  final RootTask task;

  CheckState(this.task);

  @override
  List<Object> get props => [task];
}

class DialogState extends ProviderState {
  final RootTask rootTask;
  final CheckTask checkTask;
  final bool changeObj;
  DialogState(this.changeObj, this.rootTask, this.checkTask);

  @override
  List<Object> get props => [changeObj, rootTask, checkTask];
}

class UpdateState extends ProviderState {
  final RootTask rootTask;
  final CheckTask checkTask;

  UpdateState(this.rootTask, this.checkTask);

  @override
  List<Object> get props => [rootTask, checkTask];
}

class HorizontalState extends ProviderState {
  final RootTask rootTask;

  HorizontalState(this.rootTask);

  @override
  List<Object> get props => [rootTask];
}

class ProviderBloc extends Bloc<ProviderEvent, ProviderState> {
  ProviderBloc() : super(RootState()) {
    on<RootEvent>((event, emit) => emit(RootState()));
    on<DialogEvent>((event, emit) =>
        emit(DialogState(event.changeObj, event.rootTask, event.checkTask)));
    on<UpdateEvent>(
        (event, emit) => emit(UpdateState(event.rootTask, event.checkTask)));
    on<CheckEvent>((event, emit) => emit(CheckState(event.task)));
    on<HorizontalEvent>((event, emit) => emit(HorizontalState(event.rootTask)));
  }

  /*@override 
  Stream<ProviderState> mapEventToState(ProviderEvent event) async* {
    if(event is RootEvent) {
      yield RootState();
    } else if(event is DialogEvent) {
      yield DialogState(event.changeObj, event.rootTask, event.checkTask);
    } else if(event is UpdateEvent) {
      yield UpdateState(event.rootTask, event.checkTask);
    } else if(event is CheckEvent) {
      yield CheckState(event.task);
    }*/
}

/*class ProviderBloc extends Bloc<ProviderEvent, ProviderState> {
  ProviderBloc() : super(RootState());

  @override 
  Stream<ProviderState> mapEventToState(ProviderEvent event) async* {
    if(event is RootEvent) {
      yield RootState();
    } else if(event is DialogEvent) {
      yield DialogState(event.changeObj, event.rootTask, event.checkTask);
    } else if(event is UpdateEvent) {
      yield UpdateState(event.rootTask, event.checkTask);
    } else if(event is CheckEvent) {
      yield CheckState(event.task);
    }
  }
}*/

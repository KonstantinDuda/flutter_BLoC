import 'package:flutter_bloc/flutter_bloc.dart';

enum CounterEvent {increment, decrement}

class CounterBloc extends Bloc<CounterEvent, int> {
  // Передаем родительскому классу стартовое значение
  CounterBloc() : super(0);

  // Обязательно перегружать метод в наследнике класса Блока
  @override 
  Stream<int> mapEventToState(CounterEvent event) async* {
    switch (event) {
      case CounterEvent.decrement:
        yield state - 1;
        break;
      case CounterEvent.increment:
        yield state + 1;
        break;
      default:
        addError(Exception('unsupported event'));
    }
  }
}
import 'package:flutter_bloc/flutter_bloc.dart';

// Можно иметь доступ ко всем переходам (Transition)
//  создав свой класс BlocObserver (его наследника)
class SimpleBlocObserver extends BlocObserver {
  // Если нужно иметь возможность делать что-то 
  //  в ответ на все предопределенные события (Event)
  //  нужно переопределить метод
  //  onEvent(Bloc bloc, Object event)
  @override
  void onEvent(Bloc bloc, Object event) {
    print('OnEvent myObserver. event == $event');
    super.onEvent(bloc, event);
  }

  // onChange(Cubit cubit, Change change)
  /*@override
  void onChange(Cubit cubit, Change change) {
    print(change);
    super.onChange(cubit, change);
  }*/

  // Обязательно переопределять метод 
  //  onTransition(Bloc bloc, Transition transition) {}
  // В функции main() нужно указать, что нужно
  //  использовать этот BlocObserver
  @override
  void onTransition(Bloc bloc, Transition transition) {
    print('onTransition myObserver. event == $transition');
    super.onTransition(bloc, transition);
  }
  // Для возможности делать что-то в ответ на все
  //  исключения (Exception) мы должны перегрузить
  //  метод onError(Cubit cubit, Object error, StackTrace stackTrace)
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('onError myObserver. error == $error');
    super.onError(bloc, error, stackTrace);
  }
}
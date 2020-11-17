import 'package:bloc/bloc.dart';

// Создаем наследника класса Блок делегата
// Обязательно перегружаем метод изменения
// Передаем управление родительскому методу и 
//    изменения принимаемые нашим классом
// Для счетчик-приложения 
//    которое наблюдает за всеми изменениями состояния
//    кубита (который является внутренним инструментом класса BLoC)
class CounterObserver extends BlocObserver {
  @override
  void onChange(Cubit cubit, Change change) {
    super.onChange(cubit, change);
  }
}
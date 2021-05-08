import 'package:flutter_bloc/flutter_bloc.dart';

enum ShedulerEvent {addSheduller, deleteSheduler, changeSheduler}

//@immutable 
abstract class ShedulerState {
  List<String> myList = [];
}

//List<String> myList = [];

class ListSheduler extends ShedulerState {
  addSheduler(String text) {myList.add(text);}

  deleteSheduler(String text) {myList.remove(text);}

  changeSheduler(String old, String now) {myList.remove(old); myList.add(now);}
}

/*class AddSheduler extends ShedulerState {
  //addSheduller(String text) {
    //mylist.add(text);
  //}
}

class DeleteSheduler extends ShedulerState {}

class ChangeSheduler extends ShedulerState {}*/

class ShedulerBloc extends Bloc<ShedulerEvent, ShedulerState> {
  ShedulerBloc() : super(ListSheduler());

  @override 
  Stream<ShedulerState> mapEventToState(ShedulerEvent event) async* {
    switch (event) {
      case ShedulerEvent.addSheduller:
        yield ListSheduler().addSheduler('text');//AddSheduler();//.addSheduller(text) ;//.add('a');
        break;
      case ShedulerEvent.deleteSheduler:
        yield ListSheduler().deleteSheduler('text');  //DeleteSheduler();
        break;
      case ShedulerEvent.changeSheduler:
        yield ListSheduler().changeSheduler('text','new text');  //ChangeSheduler();
        break;
    }
  }
}
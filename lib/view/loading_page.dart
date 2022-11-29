import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_sheduler/bloc/provider_bloc.dart';
import 'package:task_sheduler/bloc/root_task_bloc.dart';
import 'package:task_sheduler/database/root_task_event.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key key}) : super(key: key);

  @override
  createState() => _LoadingPage();
}

class _LoadingPage extends State<LoadingPage> with TickerProviderStateMixin {
  //var animate = false;
  /*late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 2), vsync: this)
        ..repeat();
  late final Animation<double> _animation =
      CurvedAnimation(parent: _controller, curve: Curves.linear);*/

  var myGlobalKey = GlobalKey();
  var height = 0.0;
  var buttonHeight = 0.0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getButtonHeight();
    });
  }

  /*@override
  void dispose() {
    //_controller.dispose();
    //super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
      return Scaffold(
        appBar: AppBar(
          title: const Text('Загрузка данных'),
        ),
        body: Center(
          child: RotationTransition(
            turns: CurvedAnimation(parent: AnimationController(duration: const Duration(seconds: 1), vsync: this)
        ..repeat(), curve: Curves.linear) ,//_animation,
            child: const Icon(
              Icons.rotate_right_outlined,
              size: 50.0,
              color: Colors.blue,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          key: _createGlobalKey(),
          onPressed: () {
            //if (kDebugMode) {
            print('Button was pressed');
            //}
          },
          //tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      );
    
  }

  _getButtonHeight() {
    var curentContext = myGlobalKey.currentContext;
    buttonHeight = curentContext?.size?.height ?? 1.0;
    context.read<TaskBloc>().add(RootTaskFirstLoadEvent(height, buttonHeight, buttonHeight*2));
    context.read<ProviderBloc>().add(RootEvent());  
  }

  _createGlobalKey() {
    GlobalKey myKey = GlobalKey();
    myGlobalKey = myKey;
    //print('_createGlobalKey/ myGlobalKey == $myGlobalKey');
    return myKey;
  }
}

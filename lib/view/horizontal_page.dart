import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';

//import 'package:theme_switch/bloc/provider_bloc.dart';

//import '../bloc/counter_bloc.dart';
import 'root_page.dart';
import 'chack_page.dart';
//import '../bloc/theme_cubit.dart';
import 'my_drawer.dart';
//import 'my_dialog.dart';

class HorisontalPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Horisontal orientation')),
      drawer: MyDrawer(),
      body: Row(
        //mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            child: RootPage(),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: ChackPage(),
          ),
        ],
      ),
    );
  }
}
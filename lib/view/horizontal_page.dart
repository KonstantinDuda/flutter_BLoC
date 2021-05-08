import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';

//import 'package:theme_switch/bloc/provider_bloc.dart';

//import '../bloc/counter_bloc.dart';
import 'root_page.dart';
//import 'chack_page.dart';
import 'body.dart';
//import '../bloc/theme_cubit.dart';
import 'my_drawer.dart';
//import 'my_dialog.dart';

class HorizontalPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.portrait
            ? _buildVerticalLayout()
            : _buildHorizontalLayout(context); //_buildHorizontalLayout();
      },
    );
    
    /*Scaffold(
      appBar: AppBar(title: const Text('Horisontal orientation')),
      drawer: MyDrawer(),
      body: */
      
      /*Row(
        //mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Body(Icons.add),//RootPage(),
          ),
          VerticalDivider(),  // Новый обьект
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Body(Icons.remove), //ChackPage(),
          ),
        ],
      ),*/
    //);
  }

  _buildVerticalLayout() {
    return RootPage();
  }

  _buildHorizontalLayout(BuildContext context) {
    return RootPage();
    /*return Scaffold(
      appBar: AppBar(title: Text('Horisontal orientation',
        /*style: Theme.of(context).textTheme.headline6,*/),),
      drawer: MyDrawer(),
      body: Row(
        //mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Body(Icons.add),//RootPage(),
          ),
          VerticalDivider(),  // Новый обьект
          Container(
            width: MediaQuery.of(context).size.width * 0.68,
            child: Body(Icons.remove), //ChackPage(),
          ),
        ],
      ),);*/
  }
}
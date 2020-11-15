import 'package:flutter/material.dart';
import 'preference_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget> [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => PreferencePage(),
              ));
              //Navigator.of(context).push(MaterialPageRout(
              //  builder: (context) => PreferencePage(),
              //));
            },
          )
        ],
      ),
      body: Center(
        child: Container(
          child: Text(
            'Home',
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
      ),
    );
  }
}
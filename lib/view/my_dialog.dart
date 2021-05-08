import 'package:flutter/material.dart';
//import '../bloc/theme_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/provider_bloc.dart';

class MyDialog extends StatelessWidget {
  final textDialog = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: <Widget>[
          Container(
            //color: Theme.of(context).primaryColor,
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              color: Theme.of(context).primaryColor,),
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 10, 20, 10), //EdgeInsets.all(10),
              color: Theme.of(context).primaryColor,
              child:  
              TextField(
                cursorColor: Colors.black,
                expands: true,
                style: Theme.of(context).textTheme.headline6,
                controller: textDialog,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                autofocus: true,
              ),
            ),
          ),
          VerticalDivider(width: 5.0,),
          Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  //margin: EdgeInsets.fromLTRB(0, 2.5, 2.5, 2.5),
                  height: MediaQuery.of(context).size.height * 0.49,
                  width: MediaQuery.of(context).size.width * 0.29,
                  decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              color: Theme.of(context).primaryColor,),
                  //color: Theme.of(context).primaryColor,
                  child: Center(
                    child: Text(
                      'Save',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
                onTap: () {
                  /*BlocProvider.of<ProviderBloc>(context)
                      .add(ProviderEvent.rootPage);*/
                  BlocProvider.of<ProviderBloc>(context).add(RootEvent());
                },
              ),
              Divider(height: 5.0,),
              GestureDetector(
                child: Container(
                  //margin: EdgeInsets.fromLTRB(0, 2.5, 2.5, 2.5),
                  height: MediaQuery.of(context).size.height * 0.49,
                  width: MediaQuery.of(context).size.width * 0.29,
                  decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              color: Theme.of(context).primaryColor,),
                  //color: Theme.of(context).primaryColor,
                  child: Center(
                    child: Text(
                      'Cancel',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
                onTap: () {
                  BlocProvider.of<ProviderBloc>(context).add(RootEvent());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/provider_bloc.dart';
import '../bloc/root_task_bloc.dart';

import '../database/root_task.dart';
import '../database/task_event.dart';

class MyDialog extends StatelessWidget {
  
  final RootTask task;
  MyDialog(this.task);

  @override
  Widget build(BuildContext context) {
    String newText = '';
    if(task != null) {
      newText = task.text;
      print('Text in myDialog ${task.text.length}');
    }
    
    return Card(
      child: Row(
        children: <Widget>[
          Expanded ( child:
          Container(
            //color: Theme.of(context).primaryColor,
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              color: Theme.of(context).primaryColor,),
            child: Container(
              margin: EdgeInsets.fromLTRB(5, 5, 5, 5), //EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                color: Theme.of(context).textTheme.headline6.color,
              ),
              child:  
              TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 10 ,10, 10),
                ),
                onChanged: (value) => newText = value,
                controller: TextEditingController(text: newText),
                cursorColor: Colors.black,
                expands: true,
                style: Theme.of(context).textTheme.headline5,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                autofocus: true,
              ),
            ),
          ),),
          VerticalDivider(width: 5.0,),
          Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  //margin: EdgeInsets.fromLTRB(0, 2.5, 2.5, 2.5),
                  height: MediaQuery.of(context).size.height * 0.29,
                  width: MediaQuery.of(context).size.width * 0.25,
                  decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              color: Theme.of(context).primaryColor),
                  //color: Theme.of(context).primaryColor,
                  child: Center(
                    child: Text(
                      'Save',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
                onTap: () {
                  print("Go to the Root Page");
                  if(task == null) {
                    print("TaskAddedEvent($newText) in Dialog");
                    BlocProvider.of<TaskBloc>(context).add(TaskAddedEvent(newText));
                    BlocProvider.of<ProviderBloc>(context).add(RootEvent());
                  } else {
                    BlocProvider.of<TaskBloc>(context).add(TaskUpdateEvent(task.id, 0, newText));
                    BlocProvider.of<ProviderBloc>(context).add(UpdateEvent(task));
                  }
                },
              ),
              Divider(height: 5.0,),
              GestureDetector(
                child: Container(
                  //margin: EdgeInsets.fromLTRB(0, 2.5, 2.5, 2.5),
                  height: MediaQuery.of(context).size.height * 0.29,
                  width: MediaQuery.of(context).size.width * 0.25,
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

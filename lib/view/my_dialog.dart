import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:task_sheduler/database/check_task_event.dart';

import '../bloc/provider_bloc.dart';
import '../bloc/root_task_bloc.dart';
import '../bloc/check_task_bloc.dart';

import '../database/root_task.dart';
import '../database/root_task_event.dart';
import '../database/check_task.dart';
import '../database/check_task_event.dart';

class MyDialog extends StatelessWidget {
  
  final bool changeObj;
  final RootTask rootTask;
  final CheckTask checkTask;
  MyDialog(this.changeObj, this.rootTask,this.checkTask);

  String newText = '';

  @override
  Widget build(BuildContext context) {
    
    if(changeObj == true) {
      if(checkTask != null) {
        newText = checkTask.text;
        print('Text in myDialog ${checkTask.text.length}');
      } else if(rootTask != null) {
        newText = rootTask.text;
        print('Text in myDialog ${rootTask.text.length}');
      } else {
        print('All these object null in Dialog');
      }
    }
    
    return  WillPopScope(
      onWillPop: () async { BlocProvider.of<ProviderBloc>(context).add(RootEvent());
      return false; },
      child: Scaffold(
      body: Container(
            //color: Theme.of(context).primaryColor,
            width: MediaQuery.of(context).size.width, // * 0.7,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              color: Theme.of(context).primaryColor,),
            child: Container(
              margin: EdgeInsets.fromLTRB(5, 25, 5, 5), //EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                color: Theme.of(context).textTheme.headline6.color,
              ),
              child:  
              TextField(
                
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 10 ,10, 10),
                  border: InputBorder.none,
                ),
                onChanged: (value) { newText = value; print('$newText'); return newText;},
                controller: TextEditingController(text: newText),
                cursorColor: Theme.of(context).textTheme.headline5.color,
                expands: true,
                style: Theme.of(context).textTheme.headline5,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                autofocus: true,
              ),
            ),
          ),
            floatingActionButton: myFloatingActionButton(context),
    )
    );
  }

  myFloatingActionButton(BuildContext context) {
    print('newText == $newText');
    return Container(
          // При перемещении на телефоне активный обьект перерисовывается в синий цвет...
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
                child: FloatingActionButton.extended(
                  label: Text('Закрыть'),
                  onPressed: () {
                    if(checkTask != null) {
                      BlocProvider.of<ProviderBloc>(context).add(CheckEvent(rootTask));
                    } else {
                      BlocProvider.of<ProviderBloc>(context).add(RootEvent());
                    }
                  },
                  backgroundColor: Theme.of(context).accentColor,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
                child: FloatingActionButton.extended(
                  label: Text('Сохранить'),
                  onPressed: () {
                    if(changeObj == true) {
                      if(checkTask != null && rootTask != null) {
                        print('if(checkTask != null && rootTask != null)');
                        BlocProvider.of<CheckTaskBloc>(context).add(CheckTaskUpdateEvent(checkTask.id, 0, newText, false));
                        BlocProvider.of<ProviderBloc>(context).add(CheckEvent(rootTask));
                      } else if(rootTask != null && checkTask == null) {
                        print('if(rootTask != null && checkTask == null)');
                        BlocProvider.of<TaskBloc>(context).add(RootTaskUpdateEvent(rootTask.id, 0, newText, 0, 0));
                        BlocProvider.of<ProviderBloc>(context).add(RootEvent());
                      }
                    } else {
                      if(rootTask != null) {
                        print('if(rootTask != null)');
                        BlocProvider.of<CheckTaskBloc>(context).add(CheckTaskAddedEvent(newText, rootTask.id));
                        BlocProvider.of<TaskBloc>(context).add(RootTaskUpdateEvent(rootTask.id, 0, rootTask.text, 0, 1));
                        BlocProvider.of<ProviderBloc>(context).add(CheckEvent(rootTask));
                      } else {
                        print('else');
                        BlocProvider.of<TaskBloc>(context).add(RootTaskAddedEvent(newText));
                        BlocProvider.of<ProviderBloc>(context).add(RootEvent());
                      }
                    }
                  },
                  backgroundColor: Theme.of(context).accentColor,
                ),
              ),
            ],
          ),
        );
  }
}

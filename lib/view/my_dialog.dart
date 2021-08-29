import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_sheduler/database/chack_task_event.dart';

import '../bloc/provider_bloc.dart';
import '../bloc/root_task_bloc.dart';
import '../bloc/chack_task_bloc.dart';

import '../database/root_task.dart';
import '../database/root_task_event.dart';
import '../database/chack_task.dart';
import '../database/chack_task_event.dart';

class MyDialog extends StatelessWidget {
  
  final bool changeObj;
  final RootTask rootTask;
  final ChackTask chackTask;
  MyDialog(this.changeObj, this.rootTask,this.chackTask);

  String newText = '';

  @override
  Widget build(BuildContext context) {
    
    if(changeObj == true) {
      if(chackTask != null) {
        newText = chackTask.text;
        print('Text in myDialog ${chackTask.text.length}');
      } else if(rootTask != null) {
        newText = rootTask.text;
        print('Text in myDialog ${rootTask.text.length}');
      } else {
        print('All these object null in Dialog');
      }
    }
    
    return Scaffold(
      body: // Column(
        //children: <Widget>[
          //Expanded ( child:
          Container(
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
                ),
                onChanged: (value) { newText = value; print('$newText'); return newText;},
                controller: TextEditingController(text: newText),
                cursorColor: Colors.black,
                expands: true,
                style: Theme.of(context).textTheme.headline5,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                autofocus: true,
              ),
            ),
          ),
          //),
          //VerticalDivider(width: 5.0,),
          //Column(
            //Divider(height: 5.0,),
            floatingActionButton: myFloatingActionButton(context),
            /*Row(
              mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              GestureDetector(
                child: Container(
                  //margin: EdgeInsets.fromLTRB(0, 2.5, 2.5, 2.5),
                  height: MediaQuery.of(context).size.height * 0.2, //0.29,
                  width: MediaQuery.of(context).size.width *0.35, //0.25,
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
                    if(chackTask != null) {
                      BlocProvider.of<ProviderBloc>(context).add(ChackEvent(rootTask));
                    } else {
                      BlocProvider.of<ProviderBloc>(context).add(RootEvent());
                    }
                  /*} else {
                    if(rootTask != null) {
                      BlocProvider.of<ProviderBloc>(context).add(ChackEvent(rootTask));
                    } else {
                      BlocProvider.of<ProviderBloc>(context).add(RootEvent());
                    }
                  }*/
                  
                },
              ),
              VerticalDivider(width: 5.0,),
              GestureDetector(
                child: Container(
                  //margin: EdgeInsets.fromLTRB(0, 2.5, 2.5, 2.5),
                  height: MediaQuery.of(context).size.height * 0.2, // 0.29,
                  width: MediaQuery.of(context).size.width * 0.35,// 0.25,
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
                  if(changeObj == true) {
                      if(chackTask != null && rootTask != null) {
                        print('if(chackTask != null && rootTask != null)');
                        BlocProvider.of<ChackTaskBloc>(context).add(ChackTaskUpdateEvent(chackTask.id, 0, newText, false));
                        BlocProvider.of<ProviderBloc>(context).add(ChackEvent(rootTask));
                      } else if(rootTask != null && chackTask == null) {
                        print('if(rootTask != null && chackTask == null)');
                        BlocProvider.of<TaskBloc>(context).add(RootTaskUpdateEvent(rootTask.id, 0, newText, 0, 0));
                        BlocProvider.of<ProviderBloc>(context).add(RootEvent());
                      }
                    } else {
                      if(rootTask != null) {
                        print('if(rootTask != null)');
                        BlocProvider.of<ChackTaskBloc>(context).add(ChackTaskAddedEvent(newText, rootTask.id));
                        BlocProvider.of<TaskBloc>(context).add(RootTaskUpdateEvent(rootTask.id, 0, rootTask.text, 0, 1));
                        BlocProvider.of<ProviderBloc>(context).add(ChackEvent(rootTask));
                      } else {
                        print('else');
                        BlocProvider.of<TaskBloc>(context).add(RootTaskAddedEvent(newText));
                        BlocProvider.of<ProviderBloc>(context).add(RootEvent());
                      }
                    } 
                  }
                  /*if(rootTask == null) {
                    print("TaskAddedEvent($newText) in Dialog");
                    BlocProvider.of<TaskBloc>(context).add(RootTaskAddedEvent(newText));
                    BlocProvider.of<ProviderBloc>(context).add(RootEvent());
                  } else {
                    BlocProvider.of<TaskBloc>(context).add(RootTaskUpdateEvent(rootTask.id, 0, newText));
                    BlocProvider.of<ProviderBloc>(context).add(UpdateEvent(rootTask));
                  }*/
                //},
              ),
              //Divider(height: 5.0,),
            ],
          ),*/
        //],
      //),
    );
    /*return Scaffold(
      body: /*Row(*/ Column(
        children: <Widget>[
          Expanded ( child:
          Container(
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
          //VerticalDivider(width: 5.0,),
          //Column(
            //Divider(height: 5.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              GestureDetector(
                child: Container(
                  //margin: EdgeInsets.fromLTRB(0, 2.5, 2.5, 2.5),
                  height: MediaQuery.of(context).size.height * 0.2, //0.29,
                  width: MediaQuery.of(context).size.width *0.35, //0.25,
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
                    if(chackTask != null) {
                      BlocProvider.of<ProviderBloc>(context).add(ChackEvent(rootTask));
                    } else {
                      BlocProvider.of<ProviderBloc>(context).add(RootEvent());
                    }
                  /*} else {
                    if(rootTask != null) {
                      BlocProvider.of<ProviderBloc>(context).add(ChackEvent(rootTask));
                    } else {
                      BlocProvider.of<ProviderBloc>(context).add(RootEvent());
                    }
                  }*/
                  
                },
              ),
              VerticalDivider(width: 5.0,),
              GestureDetector(
                child: Container(
                  //margin: EdgeInsets.fromLTRB(0, 2.5, 2.5, 2.5),
                  height: MediaQuery.of(context).size.height * 0.2, // 0.29,
                  width: MediaQuery.of(context).size.width * 0.35,// 0.25,
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
                  if(changeObj == true) {
                      if(chackTask != null && rootTask != null) {
                        print('if(chackTask != null && rootTask != null)');
                        BlocProvider.of<ChackTaskBloc>(context).add(ChackTaskUpdateEvent(chackTask.id, 0, newText, false));
                        BlocProvider.of<ProviderBloc>(context).add(ChackEvent(rootTask));
                      } else if(rootTask != null && chackTask == null) {
                        print('if(rootTask != null && chackTask == null)');
                        BlocProvider.of<TaskBloc>(context).add(RootTaskUpdateEvent(rootTask.id, 0, newText, 0, 0));
                        BlocProvider.of<ProviderBloc>(context).add(RootEvent());
                      }
                    } else {
                      if(rootTask != null) {
                        print('if(rootTask != null)');
                        BlocProvider.of<ChackTaskBloc>(context).add(ChackTaskAddedEvent(newText, rootTask.id));
                        BlocProvider.of<TaskBloc>(context).add(RootTaskUpdateEvent(rootTask.id, 0, rootTask.text, 0, 1));
                        BlocProvider.of<ProviderBloc>(context).add(ChackEvent(rootTask));
                      } else {
                        print('else');
                        BlocProvider.of<TaskBloc>(context).add(RootTaskAddedEvent(newText));
                        BlocProvider.of<ProviderBloc>(context).add(RootEvent());
                      }
                    } 
                  }
                  /*if(rootTask == null) {
                    print("TaskAddedEvent($newText) in Dialog");
                    BlocProvider.of<TaskBloc>(context).add(RootTaskAddedEvent(newText));
                    BlocProvider.of<ProviderBloc>(context).add(RootEvent());
                  } else {
                    BlocProvider.of<TaskBloc>(context).add(RootTaskUpdateEvent(rootTask.id, 0, newText));
                    BlocProvider.of<ProviderBloc>(context).add(UpdateEvent(rootTask));
                  }*/
                //},
              ),
              //Divider(height: 5.0,),
            ],
          ),
        ],
      ),
    ); */
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
                  label: Text('Cancel'),
                  onPressed: () {
                    if(chackTask != null) {
                      BlocProvider.of<ProviderBloc>(context).add(ChackEvent(rootTask));
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
                  label: Text('Save'),
                  onPressed: () {
                    if(changeObj == true) {
                      if(chackTask != null && rootTask != null) {
                        print('if(chackTask != null && rootTask != null)');
                        BlocProvider.of<ChackTaskBloc>(context).add(ChackTaskUpdateEvent(chackTask.id, 0, newText, false));
                        BlocProvider.of<ProviderBloc>(context).add(ChackEvent(rootTask));
                      } else if(rootTask != null && chackTask == null) {
                        print('if(rootTask != null && chackTask == null)');
                        BlocProvider.of<TaskBloc>(context).add(RootTaskUpdateEvent(rootTask.id, 0, newText, 0, 0));
                        BlocProvider.of<ProviderBloc>(context).add(RootEvent());
                      }
                    } else {
                      if(rootTask != null) {
                        print('if(rootTask != null)');
                        BlocProvider.of<ChackTaskBloc>(context).add(ChackTaskAddedEvent(newText, rootTask.id));
                        BlocProvider.of<TaskBloc>(context).add(RootTaskUpdateEvent(rootTask.id, 0, rootTask.text, 0, 1));
                        BlocProvider.of<ProviderBloc>(context).add(ChackEvent(rootTask));
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

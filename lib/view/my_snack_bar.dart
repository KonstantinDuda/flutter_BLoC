import 'package:flutter/material.dart';

class MySnackBar extends StatelessWidget {
  final text;
  final setVoid;
  MySnackBar(this.text, this.setVoid);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CircularProgressIndicator(
          //value: 0.4,
          valueColor:
              AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
            child: Text("Удалить $text?"),
          ),
        ),
        TextButton(
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all<Size>(Size(80.0, 50.0)),
            backgroundColor: MaterialStateProperty.all<Color>(
                Theme.of(context).primaryColor),
          ),
          child: Text("Да"),
          onPressed: () {
            print("MySnackBar onPressed");
            setVoid;
            /*context.read<CheckTaskBloc>().add(CheckTaskDeletedEvent(check.id));
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            context
                .read<TaskBloc>()
                .add(RootTaskUpdateEvent(root.id, 0, root.text, 0, -1));*/
          },
        ),
      ],
    );
  }
}

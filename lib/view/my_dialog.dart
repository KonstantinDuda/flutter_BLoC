import 'package:flutter/material.dart';

class MyDialog extends StatelessWidget {
  final textDialog = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //title: Text('Событие'),
      content: TextField(
        controller: textDialog,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        autofocus: true,
        decoration: InputDecoration(
          labelText: 'Новое задание',
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context, /*true*/ '');
          },
          child: Text('Отмена'),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context, /*false*/ textDialog.text);
          },
          child: Text('Сохранить'),
        ),
      ],
    );
  }
}

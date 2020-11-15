import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:theme_switching_prep/ui/global/theme/app_themes.dart';
//import 'package:theme_switching_prep/ui/global/theme/bloc/bloc.dart';

import '../theme/app_theme.dart';
import '../theme/theme_event.dart';
import '../bloc/theme_bloc.dart';

class PreferencePage extends StatelessWidget{
  const PreferencePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preferences'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: AppTheme.values.length,
        itemBuilder: (context, index) {
          final itemAppTheme = AppTheme.values[index];
          return Card(
            color: appThemeData[itemAppTheme].primaryColor,
            child: ListTile(
              title: Text(
                itemAppTheme.toString(),
                style: appThemeData[itemAppTheme].textTheme.bodyText2,
              ),
              onTap: () {
                BlocProvider.of<ThemeBloc>(context).
                  dispatch(ThemeChanged(theme: itemAppTheme));
              },
            ),
          );
        },
      )
    );
  }
}
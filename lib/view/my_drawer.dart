import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/theme_cubit.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeData>(
      // При необходимости можно указать  кубит, ограниченный
      // одним виджетом и недоступный через провайдер и текущий контекст
      builder: (_, theme) {
        return Drawer(
          child: Center(
            child: Container(
              width: 50.0,
              height: 50.0,
              child: FloatingActionButton(
                mini: true,
                child: Icon(Icons.brightness_6),
                onPressed: () => context.read<ThemeCubit>().toggleTheme(),
              ),
            ),
          ),
        );
      },
    );
  }
}

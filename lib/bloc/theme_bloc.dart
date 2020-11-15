import 'dart:async';
import 'package:bloc/bloc.dart';

import '../theme/theme_event.dart';
import '../theme/app_theme.dart';
import '../theme/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  @override
  ThemeState get initialState =>
    ThemeState(themeData: appThemeData[AppTheme.Light]);

    @override
    Stream<ThemeState> mapEventToState(
      ThemeEvent event,
    ) async* {
      if (event is ThemeChanged) {
        yield ThemeState(themeData: appThemeData[event.theme]);
      }
    }
}
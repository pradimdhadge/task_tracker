import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/core/constants/constants.dart';
import 'package:task_tracker/core/resources/local_storage.dart';
import 'package:task_tracker/modules/themes/bloc/theme_event.dart';
import 'package:task_tracker/modules/themes/bloc/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState()) {
    on<ThemeInitialEvent>(_themeInitialEvent);
    on<ChangeThemeEvent>(_changeThemeEvent);
  }

  Color? color;
  Brightness? brightness;

  ColorScheme get scheme => ColorScheme.fromSeed(
      seedColor: color ?? Colors.deepPurple,
      brightness: brightness ?? Brightness.light);

  void _themeInitialEvent(
      ThemeInitialEvent event, Emitter<ThemeState> emit) async {
    final window = WidgetsBinding.instance.window;
    window.onPlatformBrightnessChanged = () {
      brightness = window.platformBrightness;
    };
    await getTheme();
    brightness ??=
        SchedulerBinding.instance.platformDispatcher.platformBrightness;

    add(ChangeThemeEvent());
  }

  void _changeThemeEvent(ChangeThemeEvent event, Emitter<ThemeState> emit) {
    color = event.color ?? color;
    brightness = event.brightness ?? brightness;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: scheme.surfaceContainerLowest,
    ));

    emit(ThemeChangedState());
    saveTheme();
  }

  Future<void> saveTheme() async {
    if (color != null) {
      await LocalStorage().putValue(
          key: AppConstants.dbDocuments.themeColor, value: color!.value);
    }

    if (brightness != null) {
      await LocalStorage().putValue(
          key: AppConstants.dbDocuments.themeBrightness,
          value: brightness!.index);
    }
  }

  Future<void> getTheme() async {
    int? colorValue =
        await LocalStorage().getValue(key: AppConstants.dbDocuments.themeColor);
    int? bi = await LocalStorage()
        .getValue(key: AppConstants.dbDocuments.themeBrightness);

    if (colorValue != null) {
      color = Color(colorValue);
    }
    if (bi != null) {
      brightness = Brightness.values[bi];
    }
  }
}

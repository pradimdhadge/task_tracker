import 'package:flutter/material.dart';

class ThemeEvent {}

class ThemeInitialEvent extends ThemeEvent {}

class ChangeThemeEvent extends ThemeEvent {
  final Color? color;
  final Brightness? brightness;
  ChangeThemeEvent({this.color, this.brightness});
}

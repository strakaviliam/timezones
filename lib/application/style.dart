
import 'package:flutter/material.dart';

import 'app_cache.dart';

class Style {

  static Color _textColor = Colors.black;

  static ThemeData get themeData {
    //application theme
    return ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
        fontFamily: AppCache.instance.appFont[AppCache.instance.language],

        textTheme: TextTheme(
          headline3: TextStyle(fontSize: 28.0, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold, color: _textColor),
          headline5: TextStyle(fontSize: 20.0, fontStyle: FontStyle.normal, fontWeight: FontWeight.normal, color: _textColor),
          subtitle1: TextStyle(fontSize: 17.0, fontStyle: FontStyle.normal, fontWeight: FontWeight.normal, color: _textColor),
          bodyText1: TextStyle(fontSize: 14.0, fontStyle: FontStyle.normal, fontWeight: FontWeight.normal, color: _textColor),
        )
    );
  }

  static TextStyle textHeader(BuildContext context, {Color color}) => Theme.of(context).textTheme.headline3.copyWith(color: color ?? _textColor);
  static TextStyle textTitle(BuildContext context, {Color color}) => Theme.of(context).textTheme.headline5.copyWith(color: color ?? _textColor);
  static TextStyle textSubtitle(BuildContext context, {Color color}) => Theme.of(context).textTheme.subtitle1.copyWith(color: color ?? _textColor);
  static TextStyle textNormal(BuildContext context, {Color color}) => Theme.of(context).textTheme.bodyText1.copyWith(color: color ?? _textColor);
  static TextStyle textNote(BuildContext context, {Color color}) => Theme.of(context).textTheme.caption.copyWith(color: color ?? _textColor);
}

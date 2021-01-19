
import 'package:flutter/material.dart';
import 'package:timezones/application/app_routes.dart';

class AppRouter {

  static void push(BuildContext context, String path, {bool root = false, Map<String, dynamic> params}) {
    if(path == null) {
      return;
    }
    if (!AppRoutes.canAccess(path)) {
      push(context, AppRoutes.loginPath, root: true, params: params);
      return;
    }

    if (root) {
      Navigator.of(context).pushNamedAndRemoveUntil(path, (_) => false, arguments: params); return;
    } else {
      Navigator.of(context).pushNamed(path, arguments: params);
    }
  }

  static void pushScreen(BuildContext context, Widget screen, {bool root = false, bool animate = true}) {

    if(screen == null) {
      return;
    }

    if (root) {
      if (animate) {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => screen), (route) => false); return;
      } else {
        Navigator.of(context).pushAndRemoveUntil(PageRouteBuilder(pageBuilder: (_, __, ___) => screen), (route) => false); return;
      }
    }
    if (!root) {
      if (animate) {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen)); return;
      } else {
        Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_, __, ___) => screen)); return;
      }
    }
  }

  static void pushRoute(BuildContext context, PageRoute route, {bool root = false}) {
    if(route == null) {
      return;
    }
    if (root) {
      Navigator.of(context).pushAndRemoveUntil(route, (_) => false); return;
    } else {
      Navigator.of(context).push(route); return;
    }
  }

  static void pop(BuildContext context, {int popCount}) {

    if (Navigator.of(context).canPop()) {
      if (popCount != null) {
        int actualPop = 0;
        Navigator.of(context).popUntil((route) => actualPop++ >= popCount);
      } else {
        Navigator.of(context).pop();
      }
      return;
    }
  }
}

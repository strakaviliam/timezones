
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezones/screens/home/bloc/home_bloc.dart';
import 'package:timezones/screens/home/repository/timezone_repository_api.dart';
import 'package:timezones/screens/home/ui/home_screen.dart';
import 'package:timezones/screens/init/bloc/init_bloc.dart';
import 'package:timezones/screens/init/ui/init_screen.dart';
import 'package:timezones/screens/login/bloc/login_bloc.dart';
import 'package:timezones/common/repository/user_repository_api.dart';
import 'package:timezones/screens/login/ui/login_screen.dart';
import 'package:timezones/screens/text_content/ui/text_content_screen.dart';
import 'app_cache.dart';

class AppRoutes {

  static String initPath = InitScreen.path;
  static String loginPath = LoginScreen.path;

  //by default all screens are protected -> need token
  static List<String> notProtectedScreens = [
    InitScreen.path,
    LoginScreen.path,
    TextContentScreen.path
  ];

  static Map<String, WidgetBuilder> get routes {
    Map<String, WidgetBuilder> routes = {};

    //init screen
    routes[InitScreen.path] = (context) => BlocProvider<InitBloc>(
        create: (_) => InitBloc(),
        child: InitScreen()
    );

    //login screen
    routes[LoginScreen.path] = (context) => BlocProvider<LoginBloc>(
        create: (_) => LoginBloc(UserRepositoryApi()),
        child: LoginScreen()
    );

    //text content screen
    routes[TextContentScreen.path] = (context) => TextContentScreen(ModalRoute.of(context).settings.arguments);

    //home screen
    routes[HomeScreen.path] = (context) => BlocProvider<HomeBloc>(
        create: (_) => HomeBloc(TimezoneRepositoryApi(), UserRepositoryApi()),
        child: HomeScreen()
    );

    return routes;
  }

  static bool canAccess(String path) {
    if (notProtectedScreens.contains(path)) {
      return true;
    }
    if (AppCache.instance.token != null && AppCache.instance.tokenExpire != null && AppCache.instance.tokenExpire.isAfter(DateTime.now())) {
      return true;
    }
    return false;
  }
}

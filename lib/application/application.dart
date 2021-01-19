
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezones/application/style.dart';
import 'app_routes.dart';
import 'simple_bloc_observer.dart';

class Application extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _ApplicationState();
}

class _ApplicationState extends State {

  @override
  void initState() {
    super.initState();

    Bloc.observer = SimpleBlocObserver();

    //supported orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
  }

  @override
  Widget build(BuildContext context) {

    return EasyLocalization(
        path: 'assets/translations',
        supportedLocales: [Locale('en')],
        child: ApplicationWidget(),
    );
  }
}

class ApplicationWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      debugShowCheckedModeBanner: false,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: Style.themeData,
      routes: AppRoutes.routes,
      initialRoute: AppRoutes.initPath,
    );
  }
}

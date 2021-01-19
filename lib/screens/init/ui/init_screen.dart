import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezones/screens/home/ui/home_screen.dart';
import 'package:timezones/screens/init/bloc/init_bloc.dart';
import 'package:timezones/tools/app_router.dart';
import 'package:timezones/tools/widget/progress_indicator.dart';
import 'package:timezones/tools/widget/screen_state.dart';

class InitScreen extends StatefulWidget {

  static String path = "/init";

  @override
  State<StatefulWidget> createState() => _InitScreenState();
}

class _InitScreenState extends ScreenState<InitScreen> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<InitBloc>(context).add(InitApplication(context));
    BlocProvider.of<InitBloc>(context).listen((state) { 
      if (state is InitLoaded) {
        AppRouter.push(context, HomeScreen.path, root: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pageStack = [];

    pageStack.add(Container(
        child: Center(
            child: Progress.view(context, size: Size(100, 100))
        )
    ));

    return buildPage(pageStack: pageStack);
  }

}

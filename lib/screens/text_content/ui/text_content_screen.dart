import 'package:flutter/material.dart';
import 'package:timezones/application/constant.dart';
import 'package:timezones/application/style.dart';
import 'package:timezones/tools/widget/screen_state.dart';
import 'package:timezones/tools/widget/txt.dart';

class TextContentScreen extends StatefulWidget {

  static String path = "/text";

  final Map<String, dynamic> routeParams;

  TextContentScreen(this.routeParams);

  @override
  State<StatefulWidget> createState() => _TextContentScreenState();
}

class _TextContentScreenState extends ScreenState<TextContentScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> pageContent = [];

    pageContent.add(_text());

    return buildPage(pageStack: pageContent, avoidResizeWithKeyboard: true, appBar: _appBar());
  }

  Widget _text() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 8, right: 8),
              child: SingleChildScrollView(
                  child: Txt(widget.routeParams[Constant.PARAM_CONTENT] ?? "", markdown: true)
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      title: Text(widget.routeParams[Constant.PARAM_TITLE] ?? "", style: Style.textHeader(context, color: Colors.white))
    );
  }
}

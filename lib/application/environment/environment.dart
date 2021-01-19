
import 'package:flutter/material.dart';

import '../application.dart';

abstract class Environment {

  static Environment value;
  String environmentName;
  String path;
  bool showBanner = true;

  Environment() {
    value = this;
    _init();
  }

  void _init() {
    Application application = Application();
    runApp(application);
  }

  static Widget banner() {
    if (Environment.value.showBanner) {
      return Banner(
        message: Environment.value.environmentName,
        location: BannerLocation.topStart,
      );
    }
    return null;
  }

  Environment.mock() {
    path = "";
    environmentName = "mock";
  }
}

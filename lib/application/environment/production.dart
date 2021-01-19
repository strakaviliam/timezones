
import 'package:flutter/material.dart';

import 'environment.dart';

class Production extends Environment {
  final String environmentName = "PROD";
  final String path = "https://api.mono.stoocq.com/test";

  Production(): super() {
    //disable logs to console
    debugPrint = (String message, {int wrapWidth}) {};
    //disable banner
    showBanner = false;
  }
}

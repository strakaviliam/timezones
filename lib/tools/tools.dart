import 'dart:convert';

import 'package:uuid/uuid.dart';
import 'generator.dart';

class Tools {

  static String uuid() {
    return Uuid().v4();
  }

  static String randomString({int length = 10}) {
    return Generator.randomString(length);
  }

  static String formatGmtDiff(int diff) {
    Duration duration = Duration(seconds: diff.abs());

    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitHours = twoDigits(duration.inHours);
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return "${diff >= 0 ? "+" : "-"} $twoDigitHours:$twoDigitMinutes";
  }

  static Map<String, dynamic> parseJwtPayLoad(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  static String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }
}

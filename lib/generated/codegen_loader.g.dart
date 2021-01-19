// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale ) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> en = {
  "error": {
    "token": "Token expired",
    "general": "We have some problem",
    "no_connection": "No internet connection",
    "validate_email": "Wrong email",
    "validate_phone": "Wrong phone",
    "validate_min_length": "To short",
    "validate_min_length_password": "The password is too short",
    "validate_min_length_code": "The code is too short",
    "validate_lowercase_alpha_num": "Wrong format, use only alphanumeric lowercase",
    "validate_empty": "Cannot be empty",
    "validate_hex_color": "Wrong hex format (#ffffff)",
    "validate_number": "Wrong number format!",
    "validate_positive_number": "Must be positive (+)!",
    "username_not_available": "Username used",
    "email_not_available": "Email used",
    "phone_not_available": "Phone used",
    "wrong_user_info": "Informations are not correct.",
    "user_not_found": "User not found",
    "wrong_email": "Email is wrong",
    "wrong_password": "Wrong Password!",
    "authentication": "Problem with login",
    "verify_need_wait": "Need wait befor request again.",
    "verify_wrong_type": "Worng code",
    "verify_not_found": "Worng code",
    "verify_not_valid": "Worng code",
    "verify_expired": "Expired code"
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": en};
}

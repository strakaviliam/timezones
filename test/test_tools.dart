
import 'dart:convert';
import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:timezones/application/app_cache.dart';
import 'package:timezones/application/environment/environment.dart';
import 'package:timezones/common/model/utc_model.dart';
import 'package:timezones/common/repository/user_repository.dart';
import 'package:timezones/screens/home/repository/timezone_repository.dart';
import 'package:timezones/tools/api/api.dart';

class MockApi extends Mock implements Api {}
class MockAppCache extends Mock implements AppCache {
  Map<String, UtcModel> utcModels = {
  "test": UtcModel.fromMap({"value": "test", "offset": 0, "utc": []})
  };
}
class MockUserRepository extends Mock implements UserRepository {}
class MockTimezoneRepository extends Mock implements TimezoneRepository {}

Future<Map<String, dynamic>> mockedJson(String name) async {
  String data = await mockedJsonString(name);
  return json.decode(data);
}

Future<String> mockedJsonString(String name) async {
  String jsonString;
  try {
    jsonString = await File('../test_resources/$name.json').readAsString();
  } catch (e) {
    jsonString = await File('test_resources/$name.json').readAsString();
  }
  return jsonString;
}


void commonSetup() {
  Environment.value = MockEnvironment();
  MockAppCache appCache = MockAppCache();
  AppCache.value = appCache;
}

class MockEnvironment extends Environment {
  MockEnvironment() : super.mock();
}

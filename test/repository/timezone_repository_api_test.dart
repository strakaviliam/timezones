
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:timezones/screens/home/model/timezone_model.dart';
import 'package:timezones/screens/home/repository/timezone_repository_api.dart';
import 'package:timezones/tools/api/result.dart';

import '../test_tools.dart';

void main() {
  group('TimezoneRepositoryApi', () {
    MockApi saveTimezoneApi;
    MockApi updateTimezoneApi;
    MockApi deleteTimezoneApi;
    MockApi getTimezoneApi;
    TimezoneRepositoryApi timezoneRepositoryApi;

    setUp(() {
      commonSetup();
      saveTimezoneApi = MockApi();
      updateTimezoneApi = MockApi();
      deleteTimezoneApi = MockApi();
      getTimezoneApi = MockApi();
      timezoneRepositoryApi = TimezoneRepositoryApi(saveTimezoneApi: saveTimezoneApi, updateTimezoneApi: updateTimezoneApi, deleteTimezoneApi: deleteTimezoneApi, getTimezoneApi: getTimezoneApi);
    });

    test('after call saveTimezone, expect response is error and throw ErrorResult', () async {
      when(saveTimezoneApi.call(parameters: anyNamed("parameters"))).thenAnswer((_) => Future.value(Result.fail("error", "")));

      try {
        await timezoneRepositoryApi.saveTimezone(TimezoneModel());
      } catch (ex) {
        expect(ex, isInstanceOf<ErrorResult>());
      }
    });

    test('after call updateTimezone, expect response is error and throw ErrorResult', () async {
      when(updateTimezoneApi.call(parameters: anyNamed("parameters"))).thenAnswer((_) => Future.value(Result.fail("error", "")));

      try {
        await timezoneRepositoryApi.updateTimezone(TimezoneModel());
      } catch (ex) {
        expect(ex, isInstanceOf<ErrorResult>());
      }
    });

    test('after call deleteTimezone, expect response is error and throw ErrorResult', () async {
      when(deleteTimezoneApi.call(parameters: anyNamed("parameters"))).thenAnswer((_) => Future.value(Result.fail("error", "")));

      try {
        await timezoneRepositoryApi.deleteTimezone(TimezoneModel());
      } catch (ex) {
        expect(ex, isInstanceOf<ErrorResult>());
      }
    });

    test('after call getTimezone, expect response is error and throw ErrorResult', () async {
      when(getTimezoneApi.call(parameters: anyNamed("parameters"))).thenAnswer((_) => Future.value(Result.fail("error", "")));

      try {
        await timezoneRepositoryApi.getTimezones();
      } catch (ex) {
        expect(ex, isInstanceOf<ErrorResult>());
      }
    });

    test('after call saveTimezone, expect response is success and return List<TimezoneModel>', () async {
      List<dynamic> json = (await mockedJson("timezones_response"))["body"];
      Result result = Result.success(json, "");

      when(saveTimezoneApi.call(parameters: anyNamed("parameters"))).thenAnswer((_) => Future.value(result));

      expect(await timezoneRepositoryApi.saveTimezone(TimezoneModel()), json.map((it) => TimezoneModel.fromMap(Map<String, dynamic>.of(it))).toList());
    });

    test('after call updateTimezone, expect response is success and return List<TimezoneModel>', () async {
      List<dynamic> json = (await mockedJson("timezones_response"))["body"];
      Result result = Result.success(json, "");

      when(updateTimezoneApi.call(parameters: anyNamed("parameters"))).thenAnswer((_) => Future.value(result));

      expect(await timezoneRepositoryApi.updateTimezone(TimezoneModel()), json.map((it) => TimezoneModel.fromMap(Map<String, dynamic>.of(it))).toList());
    });

    test('after call deleteTimezone, expect response is success and return List<TimezoneModel>', () async {
      List<dynamic> json = (await mockedJson("timezones_response"))["body"];
      Result result = Result.success(json, "");

      when(deleteTimezoneApi.call(parameters: anyNamed("parameters"))).thenAnswer((_) => Future.value(result));

      expect(await timezoneRepositoryApi.deleteTimezone(TimezoneModel()), json.map((it) => TimezoneModel.fromMap(Map<String, dynamic>.of(it))).toList());
    });

    test('after call getTimezone, expect response is success and return List<TimezoneModel>', () async {
      List<dynamic> json = (await mockedJson("timezones_response"))["body"];
      Result result = Result.success(json, "");

      when(getTimezoneApi.call(parameters: anyNamed("parameters"))).thenAnswer((_) => Future.value(result));

      expect(await timezoneRepositoryApi.getTimezones(), json.map((it) => TimezoneModel.fromMap(Map<String, dynamic>.of(it))).toList());
    });
  });
}

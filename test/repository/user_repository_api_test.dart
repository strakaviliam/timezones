
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:timezones/common/model/token_model.dart';
import 'package:timezones/common/model/user_model.dart';
import 'package:timezones/screens/login/model/user_email_model.dart';
import 'package:timezones/common/repository/user_repository_api.dart';
import 'package:timezones/tools/api/result.dart';

import '../test_tools.dart';

void main() {
  group('UserRepositoryApi', () {
    MockApi checkEmailApi;
    MockApi loginApi;
    MockApi registerApi;
    MockApi logoutApi;
    MockApi searchApi;
    UserRepositoryApi loginRepositoryApi;

    setUp(() {
      commonSetup();
      checkEmailApi = MockApi();
      loginApi = MockApi();
      registerApi = MockApi();
      logoutApi = MockApi();
      searchApi = MockApi();
      loginRepositoryApi = UserRepositoryApi(checkEmailApi: checkEmailApi, loginApi: loginApi, registerApi: registerApi, logoutApi: logoutApi, searchApi: searchApi);
    });

    test('after call verifyEmail, expect response is error and throw ErrorResult', () async {
      when(checkEmailApi.call(parameters: anyNamed("parameters"))).thenAnswer((_) => Future.value(Result.fail("error", "")));

      try {
        await loginRepositoryApi.verifyEmail("");
      } catch (ex) {
        expect(ex, isInstanceOf<ErrorResult>());
      }
    });

    test('after call login error, expect response is error and throw ErrorResult', () async {
      when(loginApi.call(parameters: anyNamed("parameters"))).thenAnswer((_) => Future.value(Result.fail("error", "")));

      try {
        await loginRepositoryApi.login("", "");
      } catch (ex) {
        expect(ex, isInstanceOf<ErrorResult>());
      }
    });

    test('after call register, expect response is error and throw ErrorResult', () async {
      when(registerApi.call(parameters: anyNamed("parameters"))).thenAnswer((_) => Future.value(Result.fail("error", "")));

      try {
        await loginRepositoryApi.register("", "");
      } catch (ex) {
        expect(ex, isInstanceOf<ErrorResult>());
      }
    });

    test('after call logout, expect response is error and throw ErrorResult', () async {
      when(logoutApi.call(parameters: anyNamed("parameters"))).thenAnswer((_) => Future.value(Result.fail("error", "")));

      try {
        await loginRepositoryApi.logout();
      } catch (ex) {
        expect(ex, isInstanceOf<ErrorResult>());
      }
    });

    test('after call search, expect response is error and throw ErrorResult', () async {
      when(searchApi.call(parameters: anyNamed("parameters"))).thenAnswer((_) => Future.value(Result.fail("error", "")));

      try {
        await loginRepositoryApi.searchUsers("");
      } catch (ex) {
        expect(ex, isInstanceOf<ErrorResult>());
      }
    });

    test('after call verifyEmail, expect response is success and return UserEmailModel', () async {
      Map<String, dynamic> json = (await mockedJson("user_email_model"))["body"];
      Result result = Result.success(json, "");

      when(checkEmailApi.call(parameters: anyNamed("parameters"))).thenAnswer((_) => Future.value(result));

      expect(await loginRepositoryApi.verifyEmail(""), UserEmailModel.fromMap(json));
    });

    test('after call login, expect response is success', () async {
      Map<String, dynamic> json = (await mockedJson("token_model"))["body"];
      Result result = Result.success(json, "");

      when(loginApi.call(parameters: anyNamed("parameters"))).thenAnswer((_) => Future.value(result));

      expect((await loginRepositoryApi.login("", "")).token, TokenModel.fromMap(json).token);
    });

    test('after call register, expect response is success', () async {
      Map<String, dynamic> json = (await mockedJson("token_model"))["body"];
      Result result = Result.success(json, "");

      when(registerApi.call(parameters: anyNamed("parameters"))).thenAnswer((_) => Future.value(result));

      expect((await loginRepositoryApi.register("", "")).token, TokenModel.fromMap(json).token);
    });

    test('after call logout, expect response is success', () async {
      Map<String, dynamic> json = (await mockedJson("success_response"))["body"];
      Result result = Result.success(json, "");

      when(registerApi.call(parameters: anyNamed("parameters"))).thenAnswer((_) => Future.value(result));

      await loginRepositoryApi.logout();
    });

    test('after call search, expect response is success', () async {
      List<dynamic> json = (await mockedJson("user_search_response"))["body"];
      Result result = Result.success(json, "");

      when(searchApi.call(parameters: anyNamed("parameters"))).thenAnswer((_) => Future.value(result));

      expect(await loginRepositoryApi.searchUsers(""), json.map((it) => UserModel.fromMap(Map<String, dynamic>.of(it))).toList());
    });
  });
}

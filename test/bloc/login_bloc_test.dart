import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:timezones/application/app_cache.dart';
import 'package:timezones/common/model/token_model.dart';
import 'package:timezones/screens/login/bloc/login_bloc.dart';
import 'package:timezones/screens/login/model/user_email_model.dart';
import 'package:timezones/tools/api/result.dart';

import '../test_tools.dart';

void main() {
  group('LoginBloc', () {

    LoginBloc loginBloc;
    MockUserRepository userRepository;

    setUp(() {
      commonSetup();
      userRepository = MockUserRepository();
      loginBloc = LoginBloc(userRepository);
    });

    tearDown(() {
      loginBloc?.close();
    });

    test('after initialization bloc state is correct', () {
      expect(VerifyEmailReady(), loginBloc.state);
    });

    test('after closing bloc does not emit any states', () {
      expectLater(loginBloc, emitsInOrder([VerifyEmailReady(), emitsDone]));

      loginBloc.close();
    });

    test('after prepare verify, VerifyEmailReady state should be emitted', () {

      final expectedResponse = [
        VerifyEmailReady()
      ];

      expectLater(loginBloc, emitsInOrder(expectedResponse));

      loginBloc.add(PrepareVerifyEmail());
    });

    test('after verifyEmail error, LoginError state should be emitted', () {

      String testEmail = "test@test.com";
      final expectedResponse = [
        VerifyEmailReady(),
        VerifyEmailInProgress(testEmail),
        LoginError("error")
      ];

      when(userRepository.verifyEmail(testEmail)).thenThrow(ErrorResult(Result.fail("error", "")));

      expectLater(loginBloc, emitsInOrder(expectedResponse));

      loginBloc.add(VerifyEmail(testEmail));
    });

    test('after verifyEmail exist, VerifyEmailDone state should be emited with existingEmail true', () {

      String testEmail = "test@test.com";
      UserEmailModel userEmailModel = UserEmailModel()
        ..email = testEmail
        ..exist = true;
      final expectedResponse = [
        VerifyEmailReady(),
        VerifyEmailInProgress(testEmail),
        VerifyEmailDone(testEmail, true)
      ];

      when(userRepository.verifyEmail(testEmail)).thenAnswer((_) => Future.value(userEmailModel));

      expectLater(loginBloc, emitsInOrder(expectedResponse));

      loginBloc.add(VerifyEmail(testEmail));
    });

    test('after verifyEmail not exist, VerifyEmailDone state should be emitted with existingEmail false', () {

      String testEmail = "test@test.com";
      UserEmailModel userEmailModel = UserEmailModel()
        ..email = testEmail
        ..exist = false;
      final expectedResponse = [
        VerifyEmailReady(),
        VerifyEmailInProgress(testEmail),
        VerifyEmailDone(testEmail, false)
      ];

      when(userRepository.verifyEmail(testEmail)).thenAnswer((_) => Future.value(userEmailModel));

      expectLater(loginBloc, emitsInOrder(expectedResponse));

      loginBloc.add(VerifyEmail(testEmail));
    });

    test('after loginUser fail, LoginError state should be emitted', () {

      String testEmail = "test@test.com";
      final expectedResponse = [
        VerifyEmailReady(),
        LoginError("error", message: {})
      ];

      when(userRepository.login(testEmail, "")).thenThrow(ErrorResult(Result.fail("error", "")));

      expectLater(loginBloc, emitsInOrder(expectedResponse));

      loginBloc.add(LoginUser(testEmail, ""));
    });

    test('after loginUser success, LoginDone state should be emitted and token setup', () async {

      String testEmail = "test@test.com";
      TokenModel tokenModel = TokenModel();
      final expectedResponse = [
        VerifyEmailReady(),
        LoginDone()
      ];

      when(userRepository.login(testEmail, "")).thenAnswer((realInvocation) => Future.value(tokenModel));

      loginBloc.add(LoginUser(testEmail, ""));

      await expectLater(loginBloc, emitsInOrder(expectedResponse));
      verify(AppCache.instance.setupToken(any)).called(1);
    });


    test('after registerUser fail, LoginError state should be emitted', () {

      String testEmail = "test@test.com";
      final expectedResponse = [
        VerifyEmailReady(),
        LoginError("error")
      ];

      when(userRepository.register(testEmail, "")).thenThrow(ErrorResult(Result.fail("error", "")));

      expectLater(loginBloc, emitsInOrder(expectedResponse));

      loginBloc.add(RegisterUser(testEmail, ""));
    });

    test('after registerUser success, LoginDone state should be emitted and token setup', () async {

      String testEmail = "test@test.com";
      TokenModel tokenModel = TokenModel();
      final expectedResponse = [
        VerifyEmailReady(),
        LoginDone()
      ];

      when(userRepository.register(testEmail, "")).thenAnswer((realInvocation) => Future.value(tokenModel));

      loginBloc.add(RegisterUser(testEmail, ""));

      await expectLater(loginBloc, emitsInOrder(expectedResponse));
      verify(AppCache.instance.setupToken(any)).called(1);
    });
  });
}

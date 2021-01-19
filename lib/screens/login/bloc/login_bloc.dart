import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:timezones/application/app_cache.dart';
import 'package:timezones/common/model/token_model.dart';
import 'package:timezones/common/repository/user_repository.dart';
import 'package:timezones/screens/login/model/user_email_model.dart';
import 'package:timezones/tools/api/result.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {

  final UserRepository repository;

  LoginBloc(this.repository) : super(VerifyEmailReady());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is PrepareVerifyEmail) {
      yield* _prepareVerifyEmail();
    } else if (event is VerifyEmail) {
      yield* _verifyEmail(event);
    } else if (event is LoginUser) {
      yield* _loginUser(event);
    } else if (event is RegisterUser) {
      yield* _registerUser(event);
    }
  }

  Stream<LoginState> _prepareVerifyEmail() async* {
    yield VerifyEmailReady();
  }

  Stream<LoginState> _verifyEmail(VerifyEmail event) async* {
    if (event.email.isEmpty) {
      return;
    }
    yield VerifyEmailInProgress(event.email);
    try {
      UserEmailModel userEmailModel = await repository.verifyEmail(event.email);
      if (state is VerifyEmailInProgress && (state as VerifyEmailInProgress).email == event.email) {
        yield VerifyEmailDone(userEmailModel.email, userEmailModel.exist);
      }
    } on ErrorResult catch (ex) {
      yield LoginError(ex.result.error, key: ex.result.key);
    }
  }

  Stream<LoginState> _loginUser(LoginUser event) async* {
    try {
      TokenModel tokenModel = await repository.login(event.email, event.password);
      AppCache.instance.setupToken(tokenModel);
      yield LoginDone();
    } on ErrorResult catch (ex) {
      yield LoginError(ex.result.error, message: ex.result.message, key: ex.result.key);
    }
  }

  Stream<LoginState> _registerUser(RegisterUser event) async* {
    try {
      TokenModel tokenModel = await repository.register(event.email, event.password);
      AppCache.instance.setupToken(tokenModel);
      yield LoginDone();
    } on ErrorResult catch (ex) {
      yield LoginError(ex.result.error, key: ex.result.key);
    }
  }
}

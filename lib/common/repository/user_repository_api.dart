
import 'package:timezones/common/model/token_model.dart';
import 'package:timezones/common/model/user_model.dart';
import 'package:timezones/common/repository/user_repository.dart';
import 'package:timezones/screens/login/model/user_email_model.dart';
import 'package:timezones/tools/api/api.dart';
import 'package:timezones/tools/api/result.dart';

class UserRepositoryApi implements UserRepository {

  Api _checkEmailApi;
  Api _loginApi;
  Api _registerApi;
  Api _logoutApi;
  Api _searchApi;

  UserRepositoryApi({Api checkEmailApi, Api loginApi, Api registerApi, Api logoutApi, Api searchApi}) {
    _checkEmailApi = checkEmailApi ?? Api("/user/check_email", method: HTTPMethod.post, publicAPI: true);
    _loginApi = loginApi ?? Api("/user/login", method: HTTPMethod.post, publicAPI: true);
    _registerApi = registerApi ?? Api("/user/register", method: HTTPMethod.post, publicAPI: true);
    _logoutApi = logoutApi ?? Api("/user/logout", method: HTTPMethod.post, publicAPI: false);
    _searchApi = searchApi ?? Api("/user/search", method: HTTPMethod.get, publicAPI: false);
  }

  @override
  Future<UserEmailModel> verifyEmail(String email) async {
    Result result = await _checkEmailApi.call(parameters: {
      "email": email
    });

    if (result.status == Status.fail) {
      throw ErrorResult(result);
    }

    return UserEmailModel.fromMap(Map<String, dynamic>.of(result.data));
  }

  @override
  Future<TokenModel> login(String email, String password) async {
    Result result = await _loginApi.call(parameters: {
      "email": email,
      "password": password
    });

    if (result.status == Status.fail) {
      throw ErrorResult(result);
    }

    TokenModel tokenModel = TokenModel.fromMap(Map<String, dynamic>.of(result.data));
    return tokenModel;
  }

  @override
  Future<TokenModel> register(String email, String password) async {
    Result result = await _registerApi.call(parameters: {
      "email": email,
      "password": password
    });

    if (result.status == Status.fail) {
      throw ErrorResult(result);
    }

    TokenModel tokenModel = TokenModel.fromMap(Map<String, dynamic>.of(result.data));
    return tokenModel;
  }

  @override
  Future<void> logout() async {
    _logoutApi.call();
  }

  @override
  Future<List<UserModel>> searchUsers(String query) async {
    Result result = await _searchApi.call(parameters: {
      "q": query
    });

    if (result.status == Status.fail) {
      throw ErrorResult(result);
    }

    return List<dynamic>.of(result.data).map((it) => UserModel.fromMap(Map<String, dynamic>.of(it))).toList();
  }
}

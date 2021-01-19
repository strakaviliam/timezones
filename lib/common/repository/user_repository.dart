import 'package:timezones/common/model/token_model.dart';
import 'package:timezones/common/model/user_model.dart';
import 'package:timezones/screens/login/model/user_email_model.dart';

abstract class UserRepository {
  Future<UserEmailModel> verifyEmail(String email);
  Future<TokenModel> login(String email, String password);
  Future<TokenModel> register(String email, String password);
  Future<void> logout();
  Future<List<UserModel>> searchUsers(String query);
}

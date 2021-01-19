import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  int id;
  String email;

  UserModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    email = map["email"];
  }

  @override
  String toString() => 'UserModel { '
      'id: $id, '
      'email: $email }';

  @override
  List<Object> get props => [id];
}

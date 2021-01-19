
import 'package:equatable/equatable.dart';

class TimezoneModel extends Equatable {
  int id;
  String name;
  String city;
  int gmtDiff;
  int uid;

  TimezoneModel();

  TimezoneModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    name = map["name"];
    city = map["city"];
    gmtDiff = map["gmtDiff"];
    uid = map["uid"];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "city": city,
      "gmtDiff": gmtDiff,
      "uid": uid
    };
  }

  @override
  String toString() => 'TimezoneModel { '
      'id: $id, '
      'name: $name, '
      'city: $city, '
      'gmtDiff: $gmtDiff }';

  @override
  List<Object> get props => [id, name, city, gmtDiff];
}

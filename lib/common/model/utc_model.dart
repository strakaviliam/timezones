
class UtcModel {
  String value;
  int offset;
  List<String> utc;

  UtcModel.fromMap(Map<String, dynamic> map) {
    value = map["value"];
    double gmtOffset = double.parse(map["offset"].toString());
    offset = (gmtOffset * Duration.secondsPerHour).toInt();
    utc = List<dynamic>.of(map["utc"]).map((it) => it.toString()).toList();
  }
}

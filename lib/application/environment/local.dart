
import 'environment.dart';

class Local extends Environment {
  final String environmentName = "LOC";
  final String path = "http://192.168.0.100:9000/test";

  Local(): super();
}


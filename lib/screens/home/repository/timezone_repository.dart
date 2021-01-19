import 'package:timezones/screens/home/model/timezone_model.dart';

abstract class TimezoneRepository {
  Future<List<TimezoneModel>> saveTimezone(TimezoneModel timezone);
  Future<List<TimezoneModel>> updateTimezone(TimezoneModel timezone);
  Future<List<TimezoneModel>> deleteTimezone(TimezoneModel timezone);
  Future<List<TimezoneModel>> getTimezones({int userId});
}
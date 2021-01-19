import 'package:timezones/screens/home/model/timezone_model.dart';
import 'package:timezones/screens/home/repository/timezone_repository.dart';
import 'package:timezones/tools/api/api.dart';
import 'package:timezones/tools/api/result.dart';

class TimezoneRepositoryApi implements TimezoneRepository {

  Api _saveTimezoneApi;
  Api _updateTimezoneApi;
  Api _deleteTimezoneApi;
  Api _getTimezoneApi;

  TimezoneRepositoryApi({Api saveTimezoneApi, Api updateTimezoneApi, Api deleteTimezoneApi, Api getTimezoneApi}) {
    _saveTimezoneApi = saveTimezoneApi ?? Api("/toptal/timezone", method: HTTPMethod.post);
    _updateTimezoneApi = updateTimezoneApi ?? Api("/toptal/timezone", method: HTTPMethod.put);
    _deleteTimezoneApi = deleteTimezoneApi ?? Api("/toptal/timezone", method: HTTPMethod.delete);
    _getTimezoneApi = getTimezoneApi ?? Api("/toptal/timezone", method: HTTPMethod.get);
  }

  @override
  Future<List<TimezoneModel>> deleteTimezone(TimezoneModel timezone) async {
    Result result = await _deleteTimezoneApi.call(parameters: {
      "id": timezone.id
    });

    if (result.status == Status.fail) {
      throw ErrorResult(result);
    }

    return List<dynamic>.of(result.data).map((it) => TimezoneModel.fromMap(Map<String, dynamic>.of(it))).toList();
  }

  @override
  Future<List<TimezoneModel>> getTimezones({int userId}) async {
    Result result = await _getTimezoneApi.call(parameters: {
      "uid": userId ?? 0
    });

    if (result.status == Status.fail) {
      throw ErrorResult(result);
    }

    return List<dynamic>.of(result.data).map((it) => TimezoneModel.fromMap(Map<String, dynamic>.of(it))).toList();
  }

  @override
  Future<List<TimezoneModel>> saveTimezone(TimezoneModel timezone) async {
    Result result = await _saveTimezoneApi.call(parameters: timezone.toJson());

    if (result.status == Status.fail) {
      throw ErrorResult(result);
    }

    return List<dynamic>.of(result.data).map((it) => TimezoneModel.fromMap(Map<String, dynamic>.of(it))).toList();
  }

  @override
  Future<List<TimezoneModel>> updateTimezone(TimezoneModel timezone) async {
    Result result = await _updateTimezoneApi.call(parameters: timezone.toJson());

    if (result.status == Status.fail) {
      throw ErrorResult(result);
    }

    return List<dynamic>.of(result.data).map((it) => TimezoneModel.fromMap(Map<String, dynamic>.of(it))).toList();
  }

}

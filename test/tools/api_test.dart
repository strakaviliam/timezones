
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:timezones/generated/locale_keys.g.dart';
import 'package:timezones/tools/api/api.dart';
import 'package:timezones/tools/api/result.dart';

import '../test_tools.dart';

class MockClient extends Mock implements Client {}

void main() {
  group('InitRepositoryApi', () {
    MockClient client;

    setUp(() {
      commonSetup();
      client = MockClient();
    });

    test('after call api (get), with private access without token, expect Result with error_token', () async {
      when(client.get(any, headers: anyNamed("headers"))).thenAnswer((_) => Future.value());
      Api api = Api("", client: client, publicAPI: false, method: HTTPMethod.get);

      expect(await api.call(key: ""), Result.fail(LocaleKeys.error_token, ""));
      verifyNever(client.get(any));
    });

    test('after call api (get), with public access, expect error response', () async {
      dynamic json = (await mockedJsonString("fail_response"));

      when(client.get(any, headers: anyNamed("headers"))).thenAnswer((_) => Future.value(Response(json, 500)));
      Api api = Api("", client: client, publicAPI: true, method: HTTPMethod.get);

      expect(await api.call(key: ""), Result.fail("error_message", ""));
      verify(client.get(any, headers: anyNamed("headers"))).called(1);
    });

    test('after call api (get), with public access, expect success response', () async {
      dynamic json = (await mockedJsonString("success_response"));
      dynamic jsonBody = (await mockedJson("success_response"))["body"];

      when(client.get(any, headers: anyNamed("headers"))).thenAnswer((_) => Future.value(Response(json, 200)));
      Api api = Api("", client: client, publicAPI: true, method: HTTPMethod.get);


      expect(await api.call(key: ""), Result.success(jsonBody, ""));
      verify(client.get(any, headers: anyNamed("headers"))).called(1);
    });
  });
}

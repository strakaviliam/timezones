import 'package:flutter_test/flutter_test.dart';
import 'package:timezones/application/app_cache.dart';
import 'package:timezones/screens/timezone_edit/bloc/timezone_edit_bloc.dart';
import '../test_tools.dart';

void main() {
  group('TimezoneEditBloc', () {
    TimezoneEditBloc timezoneEditBloc;

    setUp(() {
      commonSetup();
      timezoneEditBloc = TimezoneEditBloc();
    });

    tearDown(() {
      timezoneEditBloc?.close();
    });

    test('after initialization bloc state is correct', () {
      expect(TimezoneEditInitial(), timezoneEditBloc.state);
    });

    test('after closing bloc does not emit any states', () {
      expectLater(timezoneEditBloc, emitsInOrder([TimezoneEditInitial(), emitsDone]));

      timezoneEditBloc.close();
    });

    test('after SelectCity, SelectedCity state should be emitted', () {

      final expectedResponse = [
        TimezoneEditInitial(),
        SelectedCity("test", AppCache.instance.utcModels["test"])
      ];

      expectLater(timezoneEditBloc, emitsInOrder(expectedResponse));

      timezoneEditBloc.add(SelectCity("test"));
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:timezones/screens/init/bloc/init_bloc.dart';
import '../test_tools.dart';

void main() {
  group('InitBloc', () {
    InitBloc initBloc;

    setUp(() {
      commonSetup();
      initBloc = InitBloc();
    });

    tearDown(() {
      initBloc?.close();
    });

    test('after initialization bloc state is correct', () {
      expect(InitLoading(), initBloc.state);
    });

    test('after closing bloc does not emit any states', () {
      expectLater(initBloc, emitsInOrder([InitLoading(), emitsDone]));

      initBloc.close();
    });

    test('after InitApplication, InitLoaded state should be emitted', () {

      final expectedResponse = [
        InitLoading(),
        InitLoaded()
      ];

      expectLater(initBloc, emitsInOrder(expectedResponse));

      initBloc.add(InitApplication(null));
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:timezones/screens/user_search/bloc/user_search_bloc.dart';
import '../test_tools.dart';

void main() {
  group('UserSearchBloc', () {
    UserSearchBloc userSearchBloc;
    MockUserRepository userRepository;

    setUp(() {
      commonSetup();
      userRepository = MockUserRepository();
      userSearchBloc = UserSearchBloc(userRepository);
    });

    tearDown(() {
      userSearchBloc?.close();
    });

    test('after initialization bloc state is correct', () {
      expect(UserSearchInitial(), userSearchBloc.state);
    });

    test('after closing bloc does not emit any states', () {
      expectLater(userSearchBloc, emitsInOrder([UserSearchInitial(), emitsDone]));

      userSearchBloc.close();
    });
  });
}

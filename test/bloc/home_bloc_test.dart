import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:timezones/common/model/user_model.dart';
import 'package:timezones/screens/home/bloc/home_bloc.dart';
import 'package:timezones/screens/home/model/timezone_model.dart';
import '../test_tools.dart';

void main() {
  group('HomeBloc', () {
    HomeBloc homeBloc;
    MockUserRepository userRepository;
    MockTimezoneRepository timezoneRepository;

    setUp(() {
      commonSetup();
      userRepository = MockUserRepository();
      timezoneRepository = MockTimezoneRepository();
      homeBloc = HomeBloc(timezoneRepository, userRepository);
    });

    tearDown(() {
      homeBloc?.close();
    });

    test('after initialization bloc state is correct', () {
      expect(HomeInitial(), homeBloc.state);
    });

    test('after closing bloc does not emit any states', () {
      expectLater(homeBloc, emitsInOrder([HomeInitial(), emitsDone]));

      homeBloc.close();
    });

    test('after LoadTimezones success, TimezonesLoaded state should be emitted', () async {

      List<TimezoneModel> timezones = [
        TimezoneModel()
      ];
      final expectedResponse = [
        HomeInitial(),
        TimezonesLoading(),
        TimezonesLoaded(timezones, null)
      ];

      when(timezoneRepository.getTimezones()).thenAnswer((realInvocation) => Future.value(timezones));

      homeBloc.add(LoadTimezones());

      await expectLater(homeBloc, emitsInOrder(expectedResponse));
    });

    test('after ReloadTimezones success, TimezonesLoaded state should be emitted', () async {

      List<TimezoneModel> timezones = [
        TimezoneModel()
      ];
      final expectedResponse = [
        HomeInitial(),
        TimezonesLoaded(timezones, null)
      ];

      when(timezoneRepository.getTimezones()).thenAnswer((realInvocation) => Future.value(timezones));

      homeBloc.add(ReloadTimezones());

      await expectLater(homeBloc, emitsInOrder(expectedResponse));
    });

    test('after SaveTimezone success, TimezonesLoaded state should be emitted', () async {

      List<TimezoneModel> timezones = [
        TimezoneModel()
      ];
      final expectedResponse = [
        HomeInitial(),
        TimezonesLoading(),
        TimezonesLoaded(timezones, null)
      ];

      when(timezoneRepository.saveTimezone(any)).thenAnswer((realInvocation) => Future.value(timezones));

      homeBloc.add(SaveTimezone(TimezoneModel()));

      await expectLater(homeBloc, emitsInOrder(expectedResponse));
    });

    test('after RemoveTimezone success, TimezonesLoaded state should be emitted', () async {

      List<TimezoneModel> timezones = [
        TimezoneModel()
      ];
      final expectedResponse = [
        HomeInitial(),
        TimezonesLoading(),
        TimezonesLoaded(timezones, null)
      ];

      when(timezoneRepository.deleteTimezone(any)).thenAnswer((realInvocation) => Future.value(timezones));

      homeBloc.add(RemoveTimezone(TimezoneModel()));

      await expectLater(homeBloc, emitsInOrder(expectedResponse));
    });

    test('after LogoutUser success, UserLoggedOut state should be emitted', () async {

      final expectedResponse = [
        HomeInitial(),
        UserLoggedOut()
      ];

      when(userRepository.logout()).thenAnswer((realInvocation) => Future.value());

      homeBloc.add(LogoutUser());

      await expectLater(homeBloc, emitsInOrder(expectedResponse));
    });

    test('after FilterUser success, TimezonesLoaded state should be emitted', () async {

      List<TimezoneModel> timezones = [
        TimezoneModel()
      ];
      final expectedResponse = [
        HomeInitial(),
        TimezonesLoading(),
        TimezonesLoaded(timezones, null)
      ];

      when(timezoneRepository.getTimezones()).thenAnswer((realInvocation) => Future.value(timezones));

      homeBloc.add(FilterUser(UserModel.fromMap({})));

      await expectLater(homeBloc, emitsInOrder(expectedResponse));
    });
  });
}

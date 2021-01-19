import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:timezones/application/app_cache.dart';
import 'package:timezones/common/model/user_model.dart';
import 'package:timezones/common/repository/user_repository.dart';
import 'package:timezones/screens/home/model/timezone_model.dart';
import 'package:timezones/screens/home/repository/timezone_repository.dart';
import 'package:timezones/tools/api/result.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  TimezoneRepository timezoneRepository;
  UserRepository userRepository;

  UserModel _user;

  HomeBloc(this.timezoneRepository, this.userRepository) : super(HomeInitial());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is LoadTimezones) {
      yield* _loadTimezones();
    } else if (event is ReloadTimezones) {
      yield* _reloadTimezones();
    } else if (event is SaveTimezone) {
      yield* _saveTimezone(event);
    } else if (event is RemoveTimezone) {
      yield* _removeTimezone(event);
    } else if (event is LogoutUser) {
      yield* _logoutUser();
    } else if (event is FilterUser) {
      yield* _filterUser(event);
    }
  }

  Stream<HomeState> _loadTimezones() async* {
    yield TimezonesLoading();
    try {
      List<TimezoneModel> model = await timezoneRepository.getTimezones(userId: _user?.id);
      yield TimezonesLoaded(model, _user?.email);
    } on ErrorResult catch (ex) {
      yield HomeError(ex.result.error, key: ex.result.key);
    }
  }

  Stream<HomeState> _reloadTimezones() async* {
    yield HomeInitial();
    try {
      List<TimezoneModel> model = await timezoneRepository.getTimezones(userId: _user?.id);
      yield TimezonesLoaded(model, _user?.email);
    } on ErrorResult catch (ex) {
      yield HomeError(ex.result.error, key: ex.result.key);
    }
  }

  Stream<HomeState> _saveTimezone(SaveTimezone event) async* {
    yield TimezonesLoading();

    event.timezone.uid = _user?.id ?? 0;
    if (event.timezone.id == null) {
      try {
        List<TimezoneModel> model = await timezoneRepository.saveTimezone(event.timezone);
        yield TimezonesLoaded(model, _user?.email);
      } on ErrorResult catch (ex) {
        yield HomeError(ex.result.error, key: ex.result.key);
      }
    } else {
      try {
        List<TimezoneModel> model = await timezoneRepository.updateTimezone(event.timezone);
        yield TimezonesLoaded(model, _user?.email);
      } on ErrorResult catch (ex) {
        yield HomeError(ex.result.error, key: ex.result.key);
      }
    }
  }

  Stream<HomeState> _removeTimezone(RemoveTimezone event) async* {
    yield TimezonesLoading();
    try {
      List<TimezoneModel> model = await timezoneRepository.deleteTimezone(event.timezone);
      yield TimezonesLoaded(model, _user?.email);
    } on ErrorResult catch (ex) {
      yield HomeError(ex.result.error, key: ex.result.key);
    }
  }

  Stream<HomeState> _logoutUser() async* {
    userRepository.logout();
    AppCache.instance.clear();
    yield UserLoggedOut();
  }

  Stream<HomeState> _filterUser(FilterUser event) async* {
    _user = event.user;
    yield* _loadTimezones();
  }
}

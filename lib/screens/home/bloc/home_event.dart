part of 'home_bloc.dart';

@immutable
abstract class HomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadTimezones extends HomeEvent {
  LoadTimezones();

  @override
  String toString() => 'LoadTimezones { }';
}

class ReloadTimezones extends HomeEvent {
  ReloadTimezones();

  @override
  String toString() => 'ReloadTimezones { }';
}

class SaveTimezone extends HomeEvent {
  final TimezoneModel timezone;
  SaveTimezone(this.timezone);

  @override
  List<Object> get props => [timezone];

  @override
  String toString() => 'SaveTimezone { timezone: $timezone }';
}

class RemoveTimezone extends HomeEvent {
  final TimezoneModel timezone;
  RemoveTimezone(this.timezone);

  @override
  List<Object> get props => [timezone];

  @override
  String toString() => 'RemoveTimezone { timezone: $timezone }';
}

class LogoutUser extends HomeEvent {
  LogoutUser();

  @override
  String toString() => 'LogoutUser { }';
}

class FilterUser extends HomeEvent {
  final UserModel user;
  FilterUser(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'FilterUser { user: $user }';
}
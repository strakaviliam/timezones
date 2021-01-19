part of 'home_bloc.dart';

@immutable
abstract class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class TimezonesLoading extends HomeState {
  @override
  String toString() => 'TimezonesLoading { }';
}

class TimezonesLoaded extends HomeState {

  final String userEmail;
  final List<TimezoneModel> timezones;

  TimezonesLoaded(this.timezones, this.userEmail);

  @override
  String toString() => 'TimezonesLoaded { timezones: $timezones, userEmail: $userEmail }';

  @override
  List<Object> get props => [timezones, userEmail];
}

class HomeError extends HomeState {
  final String error;
  final String key;

  HomeError(this.error, {this.key = ""});

  @override
  String toString() => 'HomeError { error: $error }';

  @override
  List<Object> get props => [error, key];
}

class UserLoggedOut extends HomeState {
  @override
  String toString() => 'UserLoggedOut { }';
}
part of 'init_bloc.dart';

@immutable
abstract class InitState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitLoading extends InitState {
  @override
  String toString() => 'InitLoading { }';
}

class InitLoaded extends InitState {
  @override
  String toString() => 'InitLoaded { }';
}
part of 'init_bloc.dart';

@immutable
abstract class InitEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InitApplication extends InitEvent {

  final BuildContext context;
  InitApplication(this.context);

  @override
  String toString() => 'InitApplication { }';
}

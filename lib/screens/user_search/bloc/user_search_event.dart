part of 'user_search_bloc.dart';

@immutable
abstract class UserSearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchUsers extends UserSearchEvent {
  final String text;
  final BuildContext context;
  SearchUsers(this.context, this.text);

  @override
  List<Object> get props => [text];

  @override
  String toString() => 'SearchUsers { text: $text }';
}

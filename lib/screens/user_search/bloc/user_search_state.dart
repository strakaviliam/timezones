part of 'user_search_bloc.dart';

@immutable
abstract class UserSearchState extends Equatable {
  @override
  List<Object> get props => [];
}

class UserSearchInitial extends UserSearchState {}

class SuggestionsForEmail extends UserSearchState {
  final List<TextEntrySuggestion> suggestions;
  SuggestionsForEmail(this.suggestions);

  @override
  List<Object> get props => [suggestions];

  @override
  String toString() => 'SuggestionsForEmail { suggestions: $suggestions }';
}
part of 'timezone_edit_bloc.dart';

@immutable
abstract class TimezoneEditState extends Equatable {
  @override
  List<Object> get props => [];
}

class TimezoneEditInitial extends TimezoneEditState {}


class SuggestionsForCity extends TimezoneEditState {
  final List<TextEntrySuggestion> suggestions;
  SuggestionsForCity(this.suggestions);

  @override
  List<Object> get props => [suggestions];

  @override
  String toString() => 'SuggestionsForCity { suggestions: $suggestions }';
}

class SelectedCity extends TimezoneEditState {
  final String city;
  final UtcModel utcModel;

  SelectedCity(this.city, this.utcModel);

  @override
  List<Object> get props => [city, utcModel];

  @override
  String toString() => 'SelectedCity { city: $city, utcModel: $utcModel }';
}

part of 'timezone_edit_bloc.dart';

@immutable
abstract class TimezoneEditEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FindSuggestionsForCity extends TimezoneEditEvent {
  final String text;
  final BuildContext context;
  FindSuggestionsForCity(this.context, this.text);

  @override
  List<Object> get props => [text];

  @override
  String toString() => 'FindSuggestionsForCity { text: $text }';
}

class SelectCity extends TimezoneEditEvent {
  final String city;
  SelectCity(this.city);

  @override
  List<Object> get props => [city];

  @override
  String toString() => 'SelectCity { city: $city }';
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:timezones/application/app_cache.dart';
import 'package:timezones/application/style.dart';
import 'package:timezones/common/model/utc_model.dart';
import 'package:timezones/tools/widget/text_entry/text_entry.dart';

part 'timezone_edit_event.dart';
part 'timezone_edit_state.dart';

class TimezoneEditBloc extends Bloc<TimezoneEditEvent, TimezoneEditState> {

  TimezoneEditBloc() : super(TimezoneEditInitial());

  @override
  Stream<TimezoneEditState> mapEventToState(TimezoneEditEvent event) async* {
    if (event is FindSuggestionsForCity) {
      yield* _findSuggestionsForCity(event);
    } else if (event is SelectCity) {
      yield* _findCityUtcModel(event);
    }
  }

  Stream<TimezoneEditState> _findSuggestionsForCity(FindSuggestionsForCity event) async* {
    List<TextEntrySuggestion> suggestions = AppCache.instance.utcModels.keys.where((it) => it.toLowerCase().contains(event.text.toLowerCase())).take(10).map((it) => TextEntrySuggestion(it,
        display: (text) => Container(
          padding: EdgeInsets.only(left: 8),
          color: Colors.transparent,
          height: 40,
          alignment: Alignment(-1,0),
          child: Text(text, style: Style.textNormal(event.context))
        )
    )).toList();
    if (suggestions.isEmpty) {
      suggestions = null;
    }
    yield SuggestionsForCity(suggestions);
  }

  Stream<TimezoneEditState> _findCityUtcModel(SelectCity event) async* {
    if (event.city.isEmpty) {
      yield TimezoneEditInitial();
      return;
    }
    UtcModel utcModel = AppCache.instance.utcModels[event.city];
    yield SelectedCity(event.city, utcModel);
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:timezones/application/style.dart';
import 'package:timezones/common/model/user_model.dart';
import 'package:timezones/common/repository/user_repository.dart';
import 'package:timezones/tools/api/result.dart';
import 'package:timezones/tools/widget/text_entry/text_entry.dart';

part 'user_search_event.dart';
part 'user_search_state.dart';

class UserSearchBloc extends Bloc<UserSearchEvent, UserSearchState> {
  UserRepository userRepository;
  UserSearchBloc(this.userRepository) : super(UserSearchInitial());

  @override
  Stream<UserSearchState> mapEventToState(UserSearchEvent event) async* {
    if(event is SearchUsers) {
      yield* _searchUser(event);
    }
  }

  Stream<UserSearchState> _searchUser(SearchUsers event) async* {
    try {
      List<UserModel> users = await userRepository.searchUsers(event.text);
      List<TextEntrySuggestion> suggestions = users.map((it) => TextEntrySuggestion(it,
          display: (model) => Container(
            padding: EdgeInsets.only(left: 8),
            color: Colors.transparent,
            height: 40,
            alignment: Alignment(-1,0),
            child: Text(model.email, style: Style.textNormal(event.context))
          )
      )).toList();
      if (suggestions.isEmpty) {
        suggestions = null;
      }
      yield SuggestionsForEmail(suggestions);
    } on ErrorResult catch (_) {
      yield SuggestionsForEmail(null);
    }
  }
}

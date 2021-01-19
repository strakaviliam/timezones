import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezones/application/style.dart';
import 'package:timezones/generated/locale_keys.g.dart';
import 'package:timezones/screens/home/bloc/home_bloc.dart';
import 'package:timezones/screens/user_search/bloc/user_search_bloc.dart';
import 'package:timezones/tools/widget/btn.dart';
import 'package:timezones/tools/widget/font_awesome.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:timezones/tools/widget/screen_state.dart';
import 'package:timezones/tools/widget/text_entry/text_entry.dart';

class UserSearchView extends StatefulWidget {

  final HomeBloc homeBloc;
  UserSearchView(this.homeBloc);

  @override
  State<StatefulWidget> createState() => _UserSearchViewState();
}

class _UserSearchViewState extends ScreenState<UserSearchView> {

  UserSearchBloc _userSearchBloc;

  @override
  void initState() {
    super.initState();
    _userSearchBloc = BlocProvider.of<UserSearchBloc>(context);

    _userSearchBloc.listen((state) {
      if (state is SuggestionsForEmail) {
        textEntryModel("email").suggestions = (state).suggestions;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16)
        )
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _header(),
          _emailField()
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Colors.blueGrey.withAlpha(40),
          border: Border(bottom: BorderSide(color: Colors.blueGrey.withAlpha(140), width: 1))
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            child: Btn(imageColor: Colors.redAccent, image: FontAwesomeIcons.times, padding: EdgeInsets.all(8), onClick: () => Navigator.pop(context)),
          ),
          Expanded(child: Container(
            child: Text(LocaleKeys.home_search.tr(), textAlign: TextAlign.center, style: Style.textTitle(context),),
          )),
          Container(
            width: 50,
          )
        ],
      ),
    );
  }

  Widget _emailField() {
    return Container(
        margin: EdgeInsets.only(top: 16, right: 16, left: 16),
        child: TextEntry(textEntryModel("email"),
            autofocus: true,
            hint: LocaleKeys.home_search_type,
            iconColor: Theme.of(context).primaryColor,
            icon: FontAwesomeIcons.envelope,
            onChanged: (text) {
              Future.delayed(Duration(milliseconds: 250), () {
                if (text == textEntryModel("email").text) {
                  _userSearchBloc.add(SearchUsers(context, text));
                }
              });
            },
            onSuggestionSelect: (suggestion) {
              textEntryModel("email").suggestions = null;
              textEntryModel("email").text = suggestion.model.email;
              hideKeyboard();
              widget.homeBloc.add(FilterUser(suggestion.model));
              Navigator.pop(context);
            }
        )
    );
  }
}

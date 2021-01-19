import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezones/application/style.dart';
import 'package:timezones/generated/locale_keys.g.dart';
import 'package:timezones/screens/home/bloc/home_bloc.dart';
import 'package:timezones/screens/home/model/timezone_model.dart';
import 'package:timezones/screens/timezone_edit/bloc/timezone_edit_bloc.dart';
import 'package:timezones/tools/tools.dart';
import 'package:timezones/tools/widget/btn.dart';
import 'package:timezones/tools/widget/font_awesome.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:timezones/tools/widget/screen_state.dart';
import 'package:timezones/tools/widget/text_entry/text_entry.dart';
import 'package:timezones/tools/widget/text_entry/validator_empty.dart';

class TimezoneEditView extends StatefulWidget {

  final TimezoneModel timezone;
  final HomeBloc homeBloc;

  TimezoneEditView(this.timezone, this.homeBloc);

  @override
  State<StatefulWidget> createState() => _TimezoneEditViewState();
}

class _TimezoneEditViewState extends ScreenState<TimezoneEditView> {

  TimezoneEditBloc _timezoneEditBloc;
  int _selectedGmtDiff;

  @override
  void initState() {
    super.initState();
    _timezoneEditBloc = BlocProvider.of<TimezoneEditBloc>(context);
    _timezoneEditBloc.add(SelectCity(widget.timezone.city ?? ""));

    _selectedGmtDiff = widget.timezone.gmtDiff ?? 0;
    _timezoneEditBloc.listen((state) {
      if (state is SuggestionsForCity) {
        textEntryModel("city").suggestions = (state).suggestions;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
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
            _cityField(),
            BlocBuilder<TimezoneEditBloc, TimezoneEditState>(
              bloc: _timezoneEditBloc,
              builder: (context, state) {
                if (state is SelectedCity) {
                  if (state.utcModel != null) {
                    textEntryModel("name").text = state.utcModel.value;
                    _selectedGmtDiff = state.utcModel.offset;
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _nameField(editable: state.utcModel == null),
                      _gmtField(editable: state.utcModel == null)
                    ],
                  );
                }
                return Container();
              }
            )
          ],
        ),
      ),
      onTap: () => hideKeyboard(),
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
            child: Text(widget.timezone.id == null ? LocaleKeys.home_add_timezone.tr() : LocaleKeys.home_edit_timezone.tr(), textAlign: TextAlign.center, style: Style.textTitle(context),),
          )),
          Container(
            width: 50,
            height: 50,
            child: Btn(imageColor: Theme.of(context).primaryColor, image: FontAwesomeIcons.save, padding: EdgeInsets.all(8), onClick: () => _doSave()),
          )
        ],
      ),
    );
  }

  Widget _cityField() {
    return Container(
        margin: EdgeInsets.only(top: 16, right: 16, left: 16),
        child: Row(
          children: [
            Container(
                width: 60,
                child: Text(LocaleKeys.home_timezone_city.tr() + ":", style: Style.textNormal(context))
            ),
            Expanded(
              child: TextEntry(textEntryModel("city"),
                  autofocus: true,
                  text: widget.timezone.city ?? "",
                  hint: LocaleKeys.home_timezone_city_hint,
                  iconColor: Theme.of(context).primaryColor,
                  icon: FontAwesomeIcons.mapMarkerAlt,
                  onChanged: (text) {
                    _timezoneEditBloc.add(FindSuggestionsForCity(context, text));
                  },
                  onSuggestionSelect: (suggestion) {
                    textEntryModel("city").suggestions = null;
                    textEntryModel("city").text = suggestion.model;
                    setState(() {});
                    hideKeyboard();
                  },
                  endEdit: (te) {
                    handleTextEntryEnd(te);
                    _timezoneEditBloc.add(SelectCity(textEntryModel("city").text));
                  },
                  validators: [
                    ValidatorEmpty()
                  ]

              ),
            ),
          ],
        )
    );
  }

  Widget _nameField({bool editable = false}) {
    return Container(
      margin: EdgeInsets.only(top: 16, right: 16, left: 16),
      child: Row(
        children: [
          Container(
            width: 60,
            child: Text(LocaleKeys.home_timezone_name.tr() + ":", style: Style.textNormal(context))
          ),
          Expanded(
            child: !editable ? Text(textEntryModel("name").text, style: Style.textNormal(context), textAlign: TextAlign.end,) : TextEntry(textEntryModel("name"),
              text: widget.timezone.name ?? "",
              hint: LocaleKeys.home_timezone_name_hint,
              iconColor: Theme.of(context).primaryColor,
              icon: FontAwesomeIcons.edit,
              validators: [
                ValidatorEmpty()
              ],
            ),
          ),
        ],
      )
    );
  }

  Widget _gmtField({bool editable = false}) {
    return Container(
      margin: EdgeInsets.only(top: 16, right: 16, left: 16),
      child: Row(
        children: [
          Container(
            width: 60,
            child: Text(LocaleKeys.home_timezone_gmt.tr() + ":", style: Style.textNormal(context))
          ),
          Spacer(),
          !editable ? Text(Tools.formatGmtDiff(_selectedGmtDiff), style: Style.textNormal(context),) : Container(
            height: 40,
            child: Btn(
              text: Tools.formatGmtDiff(_selectedGmtDiff),
              enabled: editable,
              popupMenu: List.generate(53, (index) {
                  return ((Duration.secondsPerHour / 2) * (-26 + int.parse(index.toString()))).toInt();
                }).map((it) => PopupOption(
                  title: Tools.formatGmtDiff(it),
                  value: it,
                  action: () => {}
                )).toList(),
              image: FontAwesomeIcons.angleDown,
              imageColor: Theme.of(context).primaryColor,
              textStyle: Style.textNormal(context),
              imageTextSwitch: true,
              onSelectPopup: (popup) {
                _selectedGmtDiff = popup.value;
                setState(() {});
              },
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.withAlpha(220),
                  width: 1
                )
              )
            )
          )
        ],
      )
    );
  }

  void _doSave() async {

    hideKeyboard();
    await Future.delayed(Duration(milliseconds: 100));
    bool valid = await TextEntryModel.validateFields([textEntryModel("city"), textEntryModel("name")]);
    if (valid) {
      TimezoneModel model = TimezoneModel();
      model.id = widget.timezone.id;
      model.city = textEntryModel("city").text;
      model.name = textEntryModel("name").text;
      model.uid = widget.timezone.uid;
      model.gmtDiff = _selectedGmtDiff;
      widget.homeBloc.add(SaveTimezone(model));
      Navigator.pop(context);
    } else {
      setState(() {});
    }
  }
}

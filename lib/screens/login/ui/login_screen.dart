import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezones/application/constant.dart';
import 'package:timezones/application/style.dart';
import 'package:timezones/generated/locale_keys.g.dart';
import 'package:timezones/screens/home/ui/home_screen.dart';
import 'package:timezones/screens/login/bloc/login_bloc.dart';
import 'package:timezones/screens/text_content/ui/text_content_screen.dart';
import 'package:timezones/tools/app_router.dart';
import 'package:timezones/tools/widget/any_image.dart';
import 'package:timezones/tools/widget/btn.dart';
import 'package:timezones/tools/widget/font_awesome.dart';
import 'package:timezones/tools/widget/popup.dart';
import 'package:timezones/tools/widget/progress_indicator.dart';
import 'package:timezones/tools/widget/screen_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:timezones/tools/widget/text_entry/text_entry.dart';
import 'package:timezones/tools/widget/text_entry/validator_email.dart';
import 'package:timezones/tools/widget/text_entry/validator_empty.dart';
import 'package:timezones/tools/widget/txt.dart';

class LoginScreen extends StatefulWidget {

  static String path = "/login";

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ScreenState<LoginScreen> {

  LoginBloc _loginBloc;
  String _email = "";
  bool _agreeTerms = false;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _loginBloc.add(PrepareVerifyEmail());

    _loginBloc.listen((state) {
      if (state is LoginError) {
        Progress.hideProgress(context);

        if (state.message.isEmpty) {
          Popup.showAlertError(context, state.error);
        } else {
          state.message.forEach((key, value) {
            textEntryModel(key).error = value.tr();
          });
          setState(() {});
        }
      } else if (state is LoginDone) {
        Progress.hideProgress(context);
        AppRouter.push(context, HomeScreen.path, root: true);
      } else if (state is VerifyEmailDone) {
        textEntryModel("password").text = "";
        textEntryModel("password").error = null;
        _agreeTerms = false;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> pageContent = [];

    pageContent.add(_logo());

    pageContent.add(BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (prevState, newState) => !(newState is LoginError),
        builder: (context, state) {

          List<Widget> columns = [];

          if (state is VerifyEmailReady || state is VerifyEmailInProgress) {
            columns.add(_title(LocaleKeys.login_welcome.tr(args: [""])));
            columns.add(_subtitle(LocaleKeys.login_enter_email.tr()));
            columns.add(_emailField(showProgress: state is VerifyEmailInProgress));
          } else if (state is VerifyEmailDone) {
            columns.add(_title(LocaleKeys.login_welcome.tr(args: [state.email.split("@").first])));
            columns.add(_subtitle((state.existingEmail ? LocaleKeys.login_please_login : LocaleKeys.login_set_password).tr()));
            columns.add(_emailField());
            columns.add(_passwordField());
            if (!state.existingEmail) {
              columns.add(_terms());
            }
            columns.add(_actionButton(state.existingEmail));
            columns.add(Spacer());
          }

          return Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: columns,
            ),
          );
        }
    ));

    return buildPage(pageStack: formStack(pageContent), avoidResizeWithKeyboard: true);
  }

  Widget _logo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 32),
          width: 140,
          height: 140,
          child: AnyImage("images/logo.png"),
        ),
      ],
    );
  }

  Widget _title(String text) {
    return Container(
      margin: EdgeInsets.only(top: 32),
      child: Text(text, style: Style.textHeader(context)),
    );
  }

  Widget _subtitle(String text) {
    return Container(
      margin: EdgeInsets.only(top: 4),
      child: Text(text, style: Style.textTitle(context)),
    );
  }

  Widget _emailField({bool showProgress = false}) {
    return Container(
        margin: EdgeInsets.only(top: 16),
        child: TextEntry(textEntryModel("email"),
            keyboardType: TextInputType.emailAddress,
            hint: LocaleKeys.common_email,
            iconColor: Theme.of(context).primaryColor,
            icon: FontAwesomeIcons.envelope,
            progress: showProgress,
            onChanged: (value) => _email = value,
            validators: [
              ValidatorEmail()
            ],
            beginEdit: (te) {
              handleTextEntryBegin(te);
              _loginBloc.add(PrepareVerifyEmail());
            },
            endEdit: (te) async {
              if (await handleTextEntryEnd(te)) {
                _loginBloc.add(VerifyEmail(_email));
              }
            }
        )
    );
  }

  Widget _passwordField() {
    return Container(
        margin: EdgeInsets.only(top: 16),
        child: TextEntry(textEntryModel("password"),
            hint: LocaleKeys.common_password,
            secure: true,
            iconColor: Theme.of(context).primaryColor,
            icon: FontAwesomeIcons.lock,
            validators: [
              ValidatorEmpty()
            ]
        )
    );
  }

  Widget _actionButton(bool existingEmail) {
    return Container(
        height: 50,
        margin: EdgeInsets.fromLTRB(0, 32, 0, 0),
        child: Btn(text: (existingEmail ? LocaleKeys.login_login_action : LocaleKeys.login_register_action).tr(),
          backgroundColor: Theme.of(context).primaryColor,
          textStyle: Style.textSubtitle(context, color: Colors.white),
          enabled: _agreeTerms || existingEmail,
          onClick: () async {
            bool valid = await TextEntryModel.validateFields([textEntryModel("email"), textEntryModel("password")]);
            if (valid) {
              Progress.showFullscreen(context);
              if (existingEmail) {
                _loginBloc.add(LoginUser(textEntryModel("email").text, textEntryModel("password").text));
              } else {
                _loginBloc.add(RegisterUser(textEntryModel("email").text, textEntryModel("password").text));
              }
            } else {
              setState(() {});
            }
          },
        )
    );
  }

  Widget _terms() {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 16, 0, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              child: Checkbox(value: _agreeTerms, onChanged: (value) {
                setState(() {
                  _agreeTerms = value;
                });
              }),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: Txt(LocaleKeys.login_terms.tr())
                  ..addClickable(LocaleKeys.login_terms_clickable.tr(), (_) => _goToTerms())
                  ..addClickable(LocaleKeys.login_privacy_clickable.tr(), (_) => _goToPrivacy()),
              ),
            )
          ],
        )
    );
  }

  void _goToTerms() {
    AppRouter.push(context, TextContentScreen.path, params: {
      Constant.PARAM_TITLE: LocaleKeys.terms_title.tr(),
      Constant.PARAM_CONTENT: LocaleKeys.terms_content.tr()
    });
  }

  void _goToPrivacy() {
    AppRouter.push(context, TextContentScreen.path, params: {
      Constant.PARAM_TITLE: LocaleKeys.privacy_title.tr(),
      Constant.PARAM_CONTENT: LocaleKeys.privacy_content.tr()
    });
  }
}

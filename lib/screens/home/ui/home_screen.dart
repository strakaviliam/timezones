import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:timezones/application/app_cache.dart';
import 'package:timezones/application/app_routes.dart';
import 'package:timezones/application/style.dart';
import 'package:timezones/common/repository/user_repository_api.dart';
import 'package:timezones/common/widget/digital_clock.dart';
import 'package:timezones/generated/locale_keys.g.dart';
import 'package:timezones/screens/home/bloc/home_bloc.dart';
import 'package:timezones/screens/home/model/timezone_model.dart';
import 'package:timezones/screens/timezone_edit/bloc/timezone_edit_bloc.dart';
import 'package:timezones/screens/timezone_edit/ui/timezone_edit_view.dart';
import 'package:timezones/screens/user_search/bloc/user_search_bloc.dart';
import 'package:timezones/screens/user_search/ui/user_search_view.dart';
import 'package:timezones/tools/app_router.dart';
import 'package:timezones/tools/tools.dart';
import 'package:timezones/tools/widget/any_image.dart';
import 'package:timezones/tools/widget/btn.dart';
import 'package:timezones/tools/widget/font_awesome.dart';
import 'package:timezones/tools/widget/popup.dart';
import 'package:timezones/tools/widget/progress_indicator.dart';
import 'package:timezones/tools/widget/screen_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'timezone_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {

  static String path = "/home";

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ScreenState<HomeScreen> {

  SlidableController _slidableController = SlidableController();
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    _homeBloc.add(LoadTimezones());

    _homeBloc.listen((state) {
      if (state is TimezonesLoaded) {
        _refreshController.refreshCompleted();
      }
      if (state is HomeError) {
        Popup.showAlertError(context, state.error);
      }
      if (state is UserLoggedOut) {
        AppRouter.push(context, AppRoutes.loginPath, root: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pageStack = [];

    pageStack.add(BlocBuilder<HomeBloc, HomeState>(
        bloc: _homeBloc,
        buildWhen: (prevState, newState) => !(newState is HomeInitial),
        builder: (context, state) {
          if (state is TimezonesLoading) {
            return _loadingView();
          } else if (state is TimezonesLoaded) {
            if (state.timezones.isEmpty) {
              return _emptyView();
            } else {
              return _listView(state.timezones, state.userEmail);
            }
          }
          return _refreshView();
        }
    ));

    return buildPage(pageStack: pageStack, appBar: _appBar());
  }

  Widget _appBar() {
    return AppBar(
      title: Row(
        children: [
          AnyImage("images/logo.png", size: Size(30, 30),),
          DigitalClock(
            showSecondsDigit: true,
            hourMinuteDigitTextStyle: Style.textTitle(context),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      centerTitle: true,
      actions: [
        _actionButton()
      ],
    );
  }

  Widget _actionButton() {
    List<PopupOption> options = [];
    options.add(PopupOption(
        title: LocaleKeys.home_add.tr(),
        image: AnyImage(FontAwesomeIcons.plus, color: Theme.of(context).accentColor, size: Size(24, 24)),
        textStyle: Style.textNormal(context),
        action: () => _showEditTimezone(TimezoneModel())
    ));

    String role = Tools.parseJwtPayLoad(AppCache.instance.token)["role"];
    if(role == "ADMIN") {
      options.add(PopupOption(
          title: LocaleKeys.home_search.tr(),
          image: AnyImage(FontAwesomeIcons.search, color: Theme.of(context).accentColor, size: Size(24, 24)),
          textStyle: Style.textNormal(context),
          action: () => _showSearchUser()
      ));
    }

    options.add(PopupOption(
        title: LocaleKeys.common_logout.tr(),
        image: AnyImage(FontAwesomeIcons.signOutAlt, color: Colors.redAccent, size: Size(24, 24)),
        textStyle: Style.textNormal(context),
        action: () => _doLogout()
    ));

    return Container(
      width: 50,
      height: 50,
      child: Btn(
        image: FontAwesomeIcons.ellipsisV,
        padding: EdgeInsets.all(8),
        popupMenu: options
      ),
    );
  }

  Widget _loadingView() {
    return Container(
      child: Center(
          child: Progress.view(context, size: Size(100, 100))
      ),
    );
  }

  Widget _refreshView() {
    return Container(
      child: Center(
          child: Container(
            width: 100,
            height: 100,
            child: Btn(
              imageColor: Theme.of(context).primaryColor.withAlpha(130),
              image: FontAwesomeIcons.sync,
              onClick: () => _homeBloc.add(LoadTimezones()),
            ),
          )
      ),
    );
  }

  Widget _emptyView() {
    return Container(
      child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(LocaleKeys.home_timezone_empty_add.tr(), style: Style.textTitle(context).copyWith(color: Colors.blueGrey),),
              Container(
                width: 100,
                height: 100,
                child: Btn(
                  imageColor: Theme.of(context).primaryColor.withAlpha(130),
                  image: FontAwesomeIcons.plusCircle,
                  onClick: () => _showEditTimezone(TimezoneModel()),
                ),
              )
            ],
          )
      ),
    );
  }

  Widget _listView(List<TimezoneModel> timezones, String userEmail) {
    return Column(
      children: [
        userEmail == null ? Container() : Container(
          height: 40,
          margin: EdgeInsets.only(left: 4),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.blueGrey, width: 1)
            )
          ),
          child: Row(
            children: [
              AnyImage(FontAwesomeIcons.filter, color: Theme.of(context).primaryColor, size: Size(22,22)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 8),
                  child: Text(userEmail, style: Style.textNormal(context))
                ),
              ),
              Btn(
                imageColor: Colors.redAccent,
                image: FontAwesomeIcons.times,
                padding: EdgeInsets.all(8),
                onClick: () => _homeBloc.add(FilterUser(null)),
              )
            ],
          ),
        ),
        Expanded(
          child: Container(
              child: SmartRefresher(
                enablePullDown: true,
                header: WaterDropHeader(),
                controller: _refreshController,
                onRefresh: () => _homeBloc.add(ReloadTimezones()),
                child: ListView.builder(
                    itemCount: timezones.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Slidable(
                          controller: _slidableController,
                          actionPane: SlidableBehindActionPane(),
                          actionExtentRatio: 0.2,
                          child: TimezoneView(timezones[index]),

                          secondaryActions: <Widget>[
                            IconSlideAction(
                              caption: LocaleKeys.common_remove.tr(),
                              color: Colors.redAccent,
                              icon: FontAwesomeIcons.faIcons[FontAwesomeIcons.trashAlt].icon(),
                              onTap: () => _homeBloc.add(RemoveTimezone(timezones[index])),
                            ),
                            IconSlideAction(
                              caption: LocaleKeys.common_edit.tr(),
                              color: Theme.of(context).primaryColor,
                              icon: FontAwesomeIcons.faIcons[FontAwesomeIcons.edit].icon(),
                              onTap: () => _showEditTimezone(timezones[index]),
                            )
                          ]
                      );
                    }
                ),
              )
          ),
        ),
      ],
    );
  }

  void _doLogout() {
    Popup.showAlert(context, LocaleKeys.common_logout, LocaleKeys.home_logout_question, confirm: LocaleKeys.common_yes, confirmAction: () {
      _homeBloc.add(LogoutUser());
    });
  }

  void _showEditTimezone(TimezoneModel timezone) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          color: Colors.transparent,
          child: MultiBlocProvider(
              providers: [
                BlocProvider<TimezoneEditBloc>(create: (context) => TimezoneEditBloc()),
              ],
              child: TimezoneEditView(timezone, _homeBloc)
          )
        );
      }
    );
  }

  void _showSearchUser() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
              color: Colors.transparent,
              child: MultiBlocProvider(
                  providers: [
                    BlocProvider<UserSearchBloc>(create: (context) => UserSearchBloc(UserRepositoryApi())),
                  ],
                  child: UserSearchView(_homeBloc)
              )
          );
        }
    );
  }
}

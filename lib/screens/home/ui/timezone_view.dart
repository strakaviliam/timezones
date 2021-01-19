
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:timezones/application/style.dart';
import 'package:timezones/common/widget/digital_clock.dart';
import 'package:timezones/generated/locale_keys.g.dart';
import 'package:timezones/screens/home/model/timezone_model.dart';
import 'package:timezones/tools/tools.dart';
import 'package:timezones/tools/widget/any_image.dart';
import 'package:timezones/tools/widget/font_awesome.dart';
import 'package:easy_localization/easy_localization.dart';

class TimezoneView extends StatelessWidget {

  final TimezoneModel timezoneModel;

  TimezoneView(this.timezoneModel);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 80,
        padding: EdgeInsets.fromLTRB(4, 4, 8, 4),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.blueGrey.withAlpha(120), width: 1)
          )
        ),
        child: Row(
          children: [
            Expanded(child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Text(timezoneModel.name, style: Style.textNote(context))
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          child: AnyImage(FontAwesomeIcons.mapMarkerAlt, color: Theme.of(context).accentColor,),
                        ),
                        Flexible(
                          child: Container(
                            alignment: Alignment(-1, 0),
                            child: Text(timezoneModel.city,
                              style: Style.textTitle(context).copyWith(fontWeight: FontWeight.bold, fontSize: 24)
                            )
                          ),
                        ),
                      ],
                    )
                  )
                ],
              ),
            )),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: DigitalClock(
                      gmtDiff: timezoneModel.gmtDiff,
                      showSecondsDigit: false,
                      hourMinuteDigitTextStyle: Style.textHeader(context).copyWith(fontSize: 30),
                    ),
                  ),
                  Container(
                    alignment: Alignment(-1, 0),
                    margin: EdgeInsets.only(right: 28),
                    child: Text(LocaleKeys.home_gmt_diff.tr(args: [_localDiff()]),
                      style: Style.textSubtitle(context).copyWith(color: Colors.blueGrey)
                    )
                  )
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Slidable.of(context).open(actionType: SlideActionType.secondary);
      },
    );
  }

  String _localDiff() {
    int localGmtDiff = DateTime.now().timeZoneOffset.inSeconds;
    int diff = timezoneModel.gmtDiff - localGmtDiff;
    return Tools.formatGmtDiff(diff);
  }
}
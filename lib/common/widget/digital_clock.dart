
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timezones/application/style.dart';
import 'package:timezones/common/widget/spinner_text.dart';

class DigitalClock extends StatefulWidget {

  final bool showSecondsDigit;
  final TextStyle hourMinuteDigitTextStyle;
  final TextStyle secondDigitTextStyle;
  final TextStyle amPmDigitTextStyle;
  final int gmtDiff;

  DigitalClock({
    this.gmtDiff,
    this.showSecondsDigit,
    this.hourMinuteDigitTextStyle,
    this.secondDigitTextStyle,
    this.amPmDigitTextStyle,
  });

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  ClockModel _clockModel;
  Timer _clockTimer;
  int _gmtDiff;

  @override
  void initState() {
    super.initState();

    _gmtDiff = widget.gmtDiff ?? DateTime.now().timeZoneOffset.inSeconds;

    _clockModel = ClockModel();
    _buildClockModel();
    _runTimer();
  }

  void _runTimer() async {
    int needDelayToWholeSecond = 1000 - DateTime.now().millisecondsSinceEpoch % 1000;
    await Future.delayed(Duration(milliseconds: needDelayToWholeSecond));
    _clockTimer = Timer.periodic(Duration(seconds: 1), (_) {
      _buildClockModel();
      if (mounted) {
        setState(() {});
      } else {
        _clockTimer?.cancel();
      }
    });
  }

  void _buildClockModel() {
    DateTime dateTime = DateTime.now().toUtc().add(Duration(seconds: _gmtDiff));
    _clockModel.hour = dateTime.hour;
    _clockModel.minute = dateTime.minute;
    _clockModel.second = dateTime.second;
  }

  @override
  void dispose() {
    try {
      _clockTimer?.cancel();
    } catch (_) {}

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          _hour(),
          Container(
            margin: EdgeInsets.only(left: 2, right: 2, bottom: 2),
            child: Text(":", style: widget.hourMinuteDigitTextStyle ?? Style.textSubtitle(context)),
          ),
          _minute(),
          _second(),
          _amPm()
        ],
      ),
    );
  }

  Widget _hour() => Container(
    child: SpinnerText(
      text: _formatHour(_clockModel.hour)[0],
      textStyle: widget.hourMinuteDigitTextStyle ?? Style.textSubtitle(context),
    ),
  );

  Widget _minute() => Container(
    child: SpinnerText(
      text: _formatTimeDigits(_clockModel.minute),
      textStyle: widget.hourMinuteDigitTextStyle ?? Style.textSubtitle(context),
    ),
  );

  Widget _second() => !(widget.showSecondsDigit ?? true) ? Text("") : Container(
    margin: EdgeInsets.only(left: 4, right: 2),
    width: (widget.secondDigitTextStyle ?? Style.textNormal(context)).fontSize * 1.5,
    child: SpinnerText(
      text: _formatTimeDigits(_clockModel.second),
      textStyle: widget.secondDigitTextStyle ?? Style.textNormal(context)
    ),
  );

  Widget _amPm() => Container(
    margin: EdgeInsets.only(bottom: (widget.hourMinuteDigitTextStyle ?? Style.textSubtitle(context)).fontSize - (widget.amPmDigitTextStyle ?? Style.textNote(context)).fontSize),
    child: Text(_formatHour(_clockModel.hour)[1],
      style: widget.amPmDigitTextStyle ?? Style.textNote(context),
    ),
  );

  List<String> _formatHour(int hour) {
    String sHour;
    String h12State;
    List<String> times = [];
    if (hour < 10) {
      sHour = "0$hour";
      h12State = "AM";
    } else if (hour > 9 && hour < 13) {
      sHour = "$hour";
      h12State = "AM";
    } else if (hour > 12 && hour < 22) {
      sHour = "0${hour % 12}";
      h12State = "PM";
    } else if (hour > 21) {
      sHour = "${hour % 12}";
      h12State = "PM";
    }
    times.add(sHour);
    times.add(h12State);
    return times;
  }

  String _formatTimeDigits(int time) => "$time".padLeft(2, "0");
}

class ClockModel {
  int hour;
  int minute;
  int second;
}

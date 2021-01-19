import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:timezones/application/app_cache.dart';
import 'package:timezones/common/model/utc_model.dart';

part 'init_event.dart';
part 'init_state.dart';

class InitBloc extends Bloc<InitEvent, InitState> {
  InitBloc() : super(InitLoading());

  @override
  Stream<InitState> mapEventToState(InitEvent event) async* {
    if (event is InitApplication) {
      yield* _initApplication(event);
    }
  }

  Stream<InitState> _initApplication(InitApplication event) async* {
    yield InitLoading();
    await AppCache.instance.init();
    //parse timezones info
    if (event.context != null) {
      String utcData = await DefaultAssetBundle.of(event.context).loadString("assets/data/timezones.json");
      List<dynamic> jsonResult = json.decode(utcData);
      List<UtcModel> utcModels = jsonResult.map((it) => UtcModel.fromMap(Map<String, dynamic>.of(it))).toList();

      utcModels.forEach((utcModel) {
        utcModel.utc.forEach((utc) {
          String cityName = utc.split("/").last.replaceAll("_", " ");
          AppCache.instance.utcModels[cityName] = utcModel;
        });
      });
    }


    await Future.delayed(Duration(milliseconds: 500));
    yield InitLoaded();
  }
}

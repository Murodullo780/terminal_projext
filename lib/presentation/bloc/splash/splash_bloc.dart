import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:terminal_project/core/constants/pref_const.dart';

part 'splash_event.dart';

part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<SplashEvent>((event, emit) {});

    on<InitSplashEvent>((event, emit) async {
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      final String host = sharedPreferences.getString(PrefConst.host) ?? '';
      // для эмуляции загрузки
      if (!kDebugMode) await Future.delayed(const Duration(seconds: 2));
      if (host.isNotEmpty) {
        emit(SplashHaveData());
      } else {
        emit(SplashNoData());
      }
    });
  }
}

//SplashInitial
// SplashHaveData
// SplashNoData

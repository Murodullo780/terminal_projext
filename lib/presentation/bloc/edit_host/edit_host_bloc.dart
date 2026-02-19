import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:terminal_project/core/constants/pref_const.dart';

part 'edit_host_event.dart';

part 'edit_host_state.dart';

class EditHostBloc extends Bloc<EditHostEvent, EditHostState> {
  EditHostBloc() : super(EditHostInitial()) {
    on<EditHostEvent>((event, emit) {});

    on<SaveEditedHost>((event, emit) async {
      final String host = event.host;
      final String port = event.port;

      if (host.isEmpty || port.isEmpty) {
        emit(EditHostError(message: 'host'.tr()));
        return;
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(PrefConst.host, event.host);
      await prefs.setString(PrefConst.port, event.port);
      emit(EditHostDone());
    });

    on<InitEditHostEvent>((event, emit) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String host = prefs.getString(PrefConst.host) ?? '';
      final String port = prefs.getString(PrefConst.port) ?? '';
      emit(EditHostLoaded(host: host, port: port));
    });
  }
}

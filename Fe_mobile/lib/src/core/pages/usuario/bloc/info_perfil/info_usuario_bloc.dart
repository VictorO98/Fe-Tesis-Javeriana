import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:Fe_mobile/src/core/models/info_usuario_model.dart';

part 'info_usuario_event.dart';
part 'info_usuario_state.dart';

class InfoUsuarioBloc extends Bloc<InfoUsuarioEvent, InfoUsuarioState> {
  InfoUsuarioBloc() : super(InfoUsuarioState());

  @override
  Stream<InfoUsuarioState> mapEventToState(
    InfoUsuarioEvent event,
  ) async* {
    if (event is OnSetearInfoUsuario) {
      yield state.copyWith(infoUsuarioModel: event.infoUsuarioModel);
    }
  }
}

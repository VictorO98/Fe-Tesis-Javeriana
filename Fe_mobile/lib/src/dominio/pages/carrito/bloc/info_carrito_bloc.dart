import 'dart:async';

import 'package:Fe_mobile/src/dominio/models/producto_servicio_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'info_carrito_event.dart';
part 'info_carrito_state.dart';

class InfoCarritoBloc extends Bloc<InfoCarritoEvent, InfoCarritoState> {
  InfoCarritoBloc() : super(InfoCarritoState(carrito: []));

  @override
  Stream<InfoCarritoState> mapEventToState(
    InfoCarritoEvent event,
  ) async* {
    if (event is OnSetearInfoCarrito) {
      yield state.copyWith(carrito: event.carrito);
    }
  }
}

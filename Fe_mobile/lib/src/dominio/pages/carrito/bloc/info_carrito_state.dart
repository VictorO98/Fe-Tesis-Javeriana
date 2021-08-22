part of 'info_carrito_bloc.dart';

@immutable
class InfoCarritoState {
  final CarritoComprasModel? carrito;

  InfoCarritoState({this.carrito});

  InfoCarritoState copyWith({CarritoComprasModel? carrito}) =>
      new InfoCarritoState(carrito: carrito ?? this.carrito);
}

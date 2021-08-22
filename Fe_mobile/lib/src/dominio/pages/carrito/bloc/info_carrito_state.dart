part of 'info_carrito_bloc.dart';

@immutable
class InfoCarritoState {
  final List<ProductoServicioModel?> carrito;

  InfoCarritoState({required this.carrito});

  InfoCarritoState copyWith({required List<ProductoServicioModel> carrito}) =>
      new InfoCarritoState(carrito: carrito);
}

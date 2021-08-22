part of 'info_carrito_bloc.dart';

@immutable
abstract class InfoCarritoEvent {}

class OnSetearInfoCarrito extends InfoCarritoEvent {
  final List<ProductoServicioModel> carrito;

  OnSetearInfoCarrito(this.carrito);
}

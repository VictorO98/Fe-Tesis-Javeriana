import 'package:Fe_mobile/src/dominio/models/producto_servicio_model.dart';

class CarritoComprasModel {
  static int _contadorCarrito = 0;
  static List<ProductoServicioModel> _carritoCompras = [];

  List<ProductoServicioModel> returnCarrito() {
    return _carritoCompras;
  }

  addElementCarrito(ProductoServicioModel publicacion, int cantidad) {
    for (int i = 0; i < cantidad; i++) {
      _carritoCompras.add(publicacion);
      print("Se agrego un producto: " + publicacion.nombre!);
    }
    _contadorCarrito = _carritoCompras.length;
  }

  printCarrito() {
    print("Carrito tamaño: " + _carritoCompras.length.toString());
    for (int i = 0; i < _carritoCompras.length; i++) {
      print(_carritoCompras[i].nombre);
    }
  }
}

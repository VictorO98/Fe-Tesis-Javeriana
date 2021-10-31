import 'package:Fe_mobile/src/dominio/models/producto_servicio_model.dart';

class CarritoComprasModel {
  static int _contadorCarrito = 0;
  static int _totalCheckout = 0;
  static List<ProductoServicioModel> _carritoCompras = [];

  List<ProductoServicioModel> returnCarrito() {
    return _carritoCompras;
  }

  int returSizeCarrito() {
    return _contadorCarrito;
  }

  int getTotalCheckOut() {
    return _totalCheckout;
  }

  setTotalCheckOut(int value) {
    _totalCheckout = value;
  }

  deleteElementCarrito(ProductoServicioModel publicacion) {
    _carritoCompras.remove(publicacion);
    _contadorCarrito = _carritoCompras.length;
    print("Se quito " + publicacion.nombre! + " del carrito");
  }

  addElementCarrito(ProductoServicioModel publicacion, int cantidad) {
    if (_carritoCompras.contains(publicacion)) {
      var pos = _carritoCompras.indexOf(publicacion);
      _carritoCompras[pos].cantidadComprador =
          _carritoCompras[pos].cantidadComprador! + cantidad;
      print("Se sumo cantidad al producto: " + publicacion.nombre!);
    } else {
      publicacion.cantidadComprador = cantidad;
      _carritoCompras.add(publicacion);
      print("Se agrego un producto: " + publicacion.nombre!);
    }
    _contadorCarrito = _carritoCompras.length;
  }

  printCarrito() {
    print("Carrito tamaño: " + _carritoCompras.length.toString());
    for (int i = 0; i < _carritoCompras.length; i++) {
      print("Producto: " +
          _carritoCompras[i].nombre! +
          " Cantidad a llevar: " +
          _carritoCompras[i].cantidadComprador.toString());
    }
  }
}

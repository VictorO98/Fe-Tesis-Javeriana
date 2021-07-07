import 'dart:convert';

import 'package:Fe_mobile/src/core/util/servicio_util.dart';
import 'package:Fe_mobile/src/dominio/models/producto_servicio_model.dart';
import 'package:flutter/widgets.dart';

class ContenidoProvider {
  Future<List<ProductoServicioModel>> getProductosDescuento() async {
    String? data = await ServicioUtil.get(
        "dominio/COContenido/GetPublicacionesPorDescuento");
    if (data == null) return [];
    final List<dynamic> decodedData = json.decode(data);
    final List<ProductoServicioModel> listado =
        List<ProductoServicioModel>.from(
            decodedData.map((model) => ProductoServicioModel.fromJson(model)));
    return listado;
  }

  Future<List<ProductoServicioModel>> _filtroTipoPublicacion(
      BuildContext context, int idTipoPublicacion) async {
    String? data = await ServicioUtil.get(
        "dominio/COContenido/FiltrarPublicacion",
        params: {"idTipoPublicacion": idTipoPublicacion.toString()});
    if (data == null) return [];
    final List<dynamic> decodedData = json.decode(data);
    final List<ProductoServicioModel> listado =
        List<ProductoServicioModel>.from(
            decodedData.map((model) => ProductoServicioModel.fromJson(model)));
    return listado;
  }
}

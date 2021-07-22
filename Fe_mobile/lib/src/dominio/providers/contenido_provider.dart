import 'dart:convert';

import 'package:Fe_mobile/src/core/models/respuesta_datos_model.dart';
import 'package:Fe_mobile/src/core/util/servicio_util.dart';
import 'package:Fe_mobile/src/dominio/models/categoria_model.dart';
import 'package:Fe_mobile/src/dominio/models/crear_publicacion_model.dart';
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

  Future<List<ProductoServicioModel>> filtroTipoPublicacion(
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

  Future<List<CategoriaModel>> getAllCategorias() async {
    String? data = await ServicioUtil.get("dominio/COContenido/GetCategorias");
    if (data == null) return [];
    final List<dynamic> decodedData = json.decode(data);
    final List<CategoriaModel> listado = List<CategoriaModel>.from(
        decodedData.map((model) => CategoriaModel.fromJson(model)));
    return listado;
  }

  Future<RespuestaDatosModel?> guardarPublicacion(
      CrearPublicacionModel publicacion, BuildContext context) async {
    String? data = await ServicioUtil.post(
        "dominio/COContenido/GuardarPublicacion", json.encode(publicacion),
        isMostratAlertError: true, contextErr: context);
    if (data == null) return null;
    final dynamic decodedData = json.decode(data);
    return RespuestaDatosModel.fromJson(decodedData);
  }
}

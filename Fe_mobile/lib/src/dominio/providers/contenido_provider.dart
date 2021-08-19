import 'dart:convert';

import 'package:Fe_mobile/src/core/models/respuesta_datos_model.dart';
import 'package:Fe_mobile/src/core/util/servicio_util.dart';
import 'package:Fe_mobile/src/dominio/models/categoria_model.dart';
import 'package:Fe_mobile/src/dominio/models/crear_publicacion_model.dart';
import 'package:Fe_mobile/src/dominio/models/producto_servicio_model.dart';
import 'package:flutter/widgets.dart';

class ContenidoProvider {
  Future<List<ProductoServicioModel>> getPublicacionesPorIdDemografia(
      String idDemografia) async {
    String? data = await ServicioUtil.get(
        "dominio/COContenido/GetPublicacionesPorIdUsuario",
        params: {"idDemografia": idDemografia});
    if (data == null) return [];
    final List<dynamic> decodedData = json.decode(data);
    final List<ProductoServicioModel> listado =
        List<ProductoServicioModel>.from(
            decodedData.map((model) => ProductoServicioModel.fromJson(model)));
    return listado;
  }

  Future<List<ProductoServicioModel>> getProductosDescuento(
      String idUsuario) async {
    String? data = await ServicioUtil.get(
        "dominio/COContenido/GetPublicacionesPorDescuento",
        params: {"idUsuario": idUsuario});
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

  Future<List<ProductoServicioModel>> busquedaProductosPorNombre(
      BuildContext context, String nombrePublicacion) async {
    String? data = await ServicioUtil.get(
        "dominio/COContenido/BuscarPublicacion",
        params: {"nombre": nombrePublicacion.toString()});
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
      Map<String, dynamic> param, BuildContext context) async {
    dynamic data = await ServicioUtil.file(
        "dominio/COContenido/GuardarPublicacion", param,
        isMostrarAlertError: true, contextErr: context);
    if (data == null) return null;
    RespuestaDatosModel respuesta = RespuestaDatosModel.fromJson(data);
    return respuesta;
  }
}

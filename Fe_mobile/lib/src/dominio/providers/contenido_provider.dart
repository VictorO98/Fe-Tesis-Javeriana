import 'dart:convert';

import 'package:Fe_mobile/src/core/models/respuesta_datos_model.dart';
import 'package:Fe_mobile/src/core/util/servicio_util.dart';
import 'package:Fe_mobile/src/dominio/models/categoria_model.dart';
import 'package:Fe_mobile/src/dominio/models/crear_publicacion_model.dart';
import 'package:Fe_mobile/src/dominio/models/editar_publicacion_model.dart';
import 'package:Fe_mobile/src/dominio/models/guardar_favorito_model.dart';
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

  Future<ProductoServicioModel?> getPublicacionesPorIdPublicacion(
      String idPublicacion) async {
    String? data = await ServicioUtil.get(
        "dominio/COContenido/GetProductoPorIdProducto",
        params: {"idPublicacion": idPublicacion},
        isMostrarAlertError: true);
    if (data == null) return null;
    final dynamic decodedData = json.decode(data);
    return ProductoServicioModel.fromJson(decodedData);
  }

  Future<List<ProductoServicioModel>> getPublicacionesFavoritas(
      String idDemografia) async {
    String? data = await ServicioUtil.get(
        "dominio/COContenido/GetFavoritosPorIdDemografia",
        params: {"idDemografia": idDemografia});
    if (data == null) return [];
    final List<dynamic> decodedData = json.decode(data);
    final List<ProductoServicioModel> listado =
        List<ProductoServicioModel>.from(
            decodedData.map((model) => ProductoServicioModel.fromJson(model)));
    return listado;
  }

  Future<bool> isFavorito(String idDemografia, String idPublicacion) async {
    String? data = await ServicioUtil.get("dominio/COContenido/FavoritoMio",
        params: {"idUsuario": idDemografia, "idPublicacion": idPublicacion});
    if (data == null) return false;
    return data == 'true';
  }

  Future<RespuestaDatosModel?> guardarPublicacionFavorita(
      GuardarPublicacionFavoritaModel publicacion, BuildContext context) async {
    String? data = await ServicioUtil.post(
        "dominio/COContenido/GuardarFavorito", json.encode(publicacion),
        isMostratAlertError: true, contextErr: context);
    if (data == null) return null;
    final dynamic decodedData = json.decode(data);
    return RespuestaDatosModel.fromJson(decodedData);
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

  Future<List<ProductoServicioModel>> elimiarFavorito(String idFavorito) async {
    String? data = await ServicioUtil.get("dominio/COContenido/RemoverFavorito",
        params: {"idFavorito": idFavorito});
    if (data == null) return [];
    final List<dynamic> decodedData = json.decode(data);
    final List<ProductoServicioModel> listado =
        List<ProductoServicioModel>.from(
            decodedData.map((model) => ProductoServicioModel.fromJson(model)));
    return listado;
  }

  Future<List<ProductoServicioModel>> filtroTipoPublicacion(
      BuildContext context, int idTipoPublicacion, String idUsuario) async {
    String? data = await ServicioUtil.get(
        "dominio/COContenido/FiltrarPublicacion",
        params: {
          "idTipoPublicacion": idTipoPublicacion.toString(),
          "idUsuario": idUsuario
        });
    if (data == null) return [];
    final List<dynamic> decodedData = json.decode(data);
    final List<ProductoServicioModel> listado =
        List<ProductoServicioModel>.from(
            decodedData.map((model) => ProductoServicioModel.fromJson(model)));
    return listado;
  }

  Future<List<ProductoServicioModel>> busquedaProductosPorNombre(
      BuildContext context, String nombrePublicacion, String idUsuario) async {
    String? data = await ServicioUtil.get(
        "dominio/COContenido/BuscarPublicacion",
        params: {
          "nombre": nombrePublicacion.toString(),
          "idUsuario": idUsuario
        });
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

  Future<RespuestaDatosModel?> modificarPublicacion(
      EditarPublicacionModel datosPublicacion, BuildContext context) async {
    String? data = await ServicioUtil.put(
        "dominio/COContenido/ModificarPublicacionApp",
        json.encode(datosPublicacion),
        contextErr: context,
        isMostrarAlertError: true);
    if (data == null) return null;
    final dynamic decodedData = json.decode(data);
    return RespuestaDatosModel.fromJson(decodedData);
  }
}

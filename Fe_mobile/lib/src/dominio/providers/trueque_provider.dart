import 'dart:convert';

import 'package:Fe_mobile/src/core/models/respuesta_datos_model.dart';
import 'package:Fe_mobile/src/core/util/servicio_util.dart';
import 'package:Fe_mobile/src/dominio/models/crear_trueque_model.dart';
import 'package:Fe_mobile/src/dominio/models/info_trueques_model.dart';
import 'package:flutter/cupertino.dart';

class TruequeProvider {
  Future<RespuestaDatosModel?> crearTrueque(
      CrearTruequeModel publicacion, BuildContext context) async {
    String? data = await ServicioUtil.post(
        "trueque/TRTrueque/GuardarTrueque", json.encode(publicacion),
        isMostratAlertError: true, contextErr: context);
    if (data == null) return null;
    final dynamic decodedData = json.decode(data);
    return RespuestaDatosModel.fromJson(decodedData);
  }

  Future<List<InfoTruequesModel>> getTruequesPorIdComprador(
      String idComprador) async {
    String? data = await ServicioUtil.get(
        "trueque/TRTrueque/GetTruequesPorIdComprador",
        params: {"idComprador": idComprador});
    if (data == null) return [];
    final List<dynamic> decodedData = json.decode(data);
    final List<InfoTruequesModel> listado = List<InfoTruequesModel>.from(
        decodedData.map((model) => InfoTruequesModel.fromJson(model)));
    return listado;
  }

  Future<List<InfoTruequesModel>> getTruequesPorIdVendedor(
      String idComprador) async {
    String? data = await ServicioUtil.get(
        "trueque/TRTrueque/GetTruequesPorIdVendedor",
        params: {"idVendedor": idComprador});
    if (data == null) return [];
    final List<dynamic> decodedData = json.decode(data);
    final List<InfoTruequesModel> listado = List<InfoTruequesModel>.from(
        decodedData.map((model) => InfoTruequesModel.fromJson(model)));
    return listado;
  }
}

import 'dart:convert';

import 'package:Fe_mobile/src/core/models/respuesta_datos_model.dart';
import 'package:Fe_mobile/src/core/util/servicio_util.dart';
import 'package:Fe_mobile/src/dominio/models/guardar_pedido_model.dart';
import 'package:Fe_mobile/src/dominio/models/guardar_producto_pedido_model.dart';
import 'package:Fe_mobile/src/dominio/models/info_pedidos_model.dart';
import 'package:flutter/cupertino.dart';

class PedidoProvider {
  Future<List<InfoPedidosModel>> getPedidosPorIdUsuario(
      String idUsuario) async {
    String? data = await ServicioUtil.get(
        "dominio/PEPedido/ListarTodosLosPedidosPorUsuario",
        params: {"idUsuario": idUsuario});
    if (data == null) return [];
    final List<dynamic> decodedData = json.decode(data);
    final List<InfoPedidosModel> listado = List<InfoPedidosModel>.from(
        decodedData.map((model) => InfoPedidosModel.fromJson(model)));
    return listado;
  }

  Future<int> crearPedido(
      GuardarPedidoModel publicacion, BuildContext context) async {
    String? data = await ServicioUtil.post(
        "dominio/PEPedido/GuardarPedido", json.encode(publicacion),
        isMostratAlertError: true, contextErr: context);
    if (data == null) return 0;
    return int.parse(data);
  }

  Future<RespuestaDatosModel?> guardarProductoPedidoPorId(
      GuardarProductoPedidoModel publicacion, BuildContext context) async {
    String? data = await ServicioUtil.post(
        "dominio/PEPedido/GuardarProductoPedido", json.encode(publicacion),
        isMostratAlertError: true, contextErr: context);
    if (data == null) return null;
    final dynamic decodedData = json.decode(data);
    return RespuestaDatosModel.fromJson(decodedData);
  }
}

import 'dart:convert';

import 'package:Fe_mobile/src/core/util/servicio_util.dart';
import 'package:Fe_mobile/src/dominio/models/info_pedidos_model.dart';

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
}

import 'dart:convert';

import 'package:Fe_mobile/src/core/util/servicio_util.dart';
import 'package:Fe_mobile/src/dominio/models/pago_tarjeta_credito_model.dart';
import 'package:flutter/cupertino.dart';

class FacturaProvider {
  Future<String> pagoConTC(
      PagoTarjetaCreditoModel datosTC, BuildContext context) async {
    String? data = await ServicioUtil.post(
        "factura/FAFactura/PagoConTC", json.encode(datosTC),
        isMostratAlertError: true, contextErr: context);
    if (data == null) return "";

    return data;
  }
}

import 'dart:convert';

import 'package:Fe_mobile/src/core/models/respuesta_datos_model.dart';
import 'package:Fe_mobile/src/core/util/alert_util.dart';
import 'package:Fe_mobile/src/core/util/jwt_util.dart';
import 'package:Fe_mobile/src/core/util/preferencias_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'conf_api.dart';

class ServicioUtil {
  //Método GET HTTP
  static Future<String?> get(String api,
      {Map<String, String>? params,
      bool isMostrarAlertError = false,
      BuildContext? contextErr}) async {
    var client = http.Client();
    try {
      var uri = Uri.parse(ConfServer.SERVER + api);
      if (params != null) uri = uri.replace(queryParameters: params);
      final response = await client.get(uri, headers: await formarHeader());
      if (response.statusCode == 200) return response.body;

      controlarError(contextErr!, response, isMostrarAlertError);
      return null;
    } catch (e) {
      print("Error Get: $e");
      AlertUtil.error(contextErr!, "Ocurrió un problema con los servicios. ");
      throw e;
    } finally {
      client.close();
    }
  }

  static dynamic post(String api, String body,
      {bool isMostratAlertError = false, BuildContext? contextErr}) async {
    var client = http.Client();
    var uri = Uri.http(ConfServer.HOST, api);
    try {
      final response =
          await client.post(uri, body: body, headers: await formarHeader());

      if (response.statusCode == 200) return response.body;
      controlarError(contextErr!, response, isMostratAlertError);
      return null;
    } catch (e) {
      print("Error en servicio - $e");
      AlertUtil.error(contextErr!, "Ocurrió un problema con los servicios. ");
      throw e;
    } finally {
      client.close();
    }
  }

  static Future<Map<String, String>> formarHeader(
      {bool isSendAccept = true}) async {
    final prefs = new PreferenciasUtil();
    String? token = await prefs.getPrefStr("token");
    Map<String, String> headers = {};
    headers["Accept"] = "application/json";
    if (!isSendAccept) {
      // headers["Content-Type"] = "multipart/form-data";
    } else {
      headers["Content-Type"] = "application/json";
    }
    if (token != null && token.isNotEmpty)
      headers["Authorization"] = "Bearer $token";

    return headers;
  }

  static controlarError(
      BuildContext context, http.Response? response, bool isMostratAlertError) {
    String? data = response?.body;
    if (data == null) return null;
    var respuestaDatos;

    if (response == null) {
    } else {
      try {
        final dynamic decodedData = json.decode(data);
        respuestaDatos = RespuestaDatosModel.fromJson(decodedData);
        if ((isMostratAlertError) && response.statusCode == 400)
          AlertUtil.error(context, respuestaDatos.mensaje);
        if (response.statusCode == 402)
          AlertUtil.error(context, "Error al conectarse al servidor");
        if (response.statusCode == 500)
          AlertUtil.error(context, respuestaDatos.mensaje);
        if (response.statusCode == 401)
          AlertUtil.error(
              context, "No tiene autorización. Por favor ingrese de nuevo. ",
              respuesta: () {
            JWTUtil.removerTokenYValoresUsuario();
            Navigator.of(context)
                .pushNamedAndRemoveUntil("login", (route) => false);
          });
      } catch (e) {}

      if (response.statusCode == 502 ||
          response.statusCode == 402 ||
          response.statusCode == 404)
        AlertUtil.error(context,
            "No hay conexión con los servicios de Buya. Por favor, intentelo más tarde. ");
    }
  }
}

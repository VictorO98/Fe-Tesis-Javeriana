import 'dart:convert';

import 'package:Fe_mobile/src/core/models/login_model.dart';
import 'package:Fe_mobile/src/core/models/modificar_demografia_model.dart';
import 'package:Fe_mobile/src/core/models/registro_model.dart';
import 'package:Fe_mobile/src/core/models/respuesta_datos_model.dart';
import 'package:Fe_mobile/src/core/models/respuesta_login_model.dart';
import 'package:Fe_mobile/src/core/util/servicio_util.dart';
import 'package:flutter/cupertino.dart';

class UsuarioProvider {
  refreshToken(String token) {}

  Future<RespuestaDatosModel?> registrarUsuario(
      RegistroModel datosRegistro, BuildContext context) async {
    String? data = await ServicioUtil.post(
        "api/Authenticate/Register", json.encode(datosRegistro),
        isMostratAlertError: true, contextErr: context);
    if (data == null) return null;
    final dynamic decodedData = json.decode(data);
    return RespuestaDatosModel.fromJson(decodedData);
  }

  Future<RespuestaDatosModel?> modificarUsuario(
      EditarDemografiaModel datosUsuario, BuildContext context) async {
    String? data = await ServicioUtil.put(
        "api/Authenticate/ModificarDemografia", json.encode(datosUsuario),
        contextErr: context, isMostrarAlertError: true);
    if (data == null) return null;
    final dynamic decodedData = json.decode(data);
    return RespuestaDatosModel.fromJson(decodedData);
  }

  Future<RespuestaDatosModel?> subirDocumentosEmprendedor(
      Map<String, dynamic> param, BuildContext context) async {
    dynamic data = await ServicioUtil.file(
        "api/Authenticate/SubirDocumentosEmprendedor", param,
        isMostrarAlertError: true, contextErr: context);
    if (data == null) return null;
    RespuestaDatosModel respuesta = RespuestaDatosModel.fromJson(data);
    return respuesta;
  }

  Future<RespuestaLoginModel?> iniciarSesion(
      LoginModel loginModel, BuildContext context) async {
    String? data = await ServicioUtil.post(
        "api/Authenticate/Login", json.encode(loginModel),
        isMostratAlertError: true, contextErr: context);
    if (data == null) return null;
    final dynamic decodedData = json.decode(data);
    return RespuestaLoginModel.fromJson(decodedData);
  }
}

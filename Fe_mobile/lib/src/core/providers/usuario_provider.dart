import 'dart:convert';

import 'package:Fe_mobile/src/core/models/cuentas_bancarias_model.dart';
import 'package:Fe_mobile/src/core/models/datos_bancarios_demografia_model.dart';
import 'package:Fe_mobile/src/core/models/login_model.dart';
import 'package:Fe_mobile/src/core/models/modificar_demografia_model.dart';
import 'package:Fe_mobile/src/core/models/registro_model.dart';
import 'package:Fe_mobile/src/core/models/respuesta_datos_model.dart';
import 'package:Fe_mobile/src/core/models/respuesta_login_model.dart';
import 'package:Fe_mobile/src/core/util/servicio_util.dart';
import 'package:flutter/cupertino.dart';

class UsuarioProvider {
  refreshToken(String token) {}

  Future<CuentaBancariaDemografiaModel?> obtenerDatosBancariosEmprendedor(
      BuildContext context, String idDemografia) async {
    String? data = await ServicioUtil.get(
        "api/Authenticate/ObtenerDatosbancarios",
        params: {"idDemografia": idDemografia},
        contextErr: context,
        isMostrarAlertError: true);
    if (data == null) return null;
    final dynamic decodedData = json.decode(data);
    return CuentaBancariaDemografiaModel.fromJson(decodedData);
  }

  Future<RespuestaDatosModel?> generarEnlaceDeConfirmacion(
      BuildContext context, String email) async {
    String? data = await ServicioUtil.get(
        "api/Authenticate/GenerarEnlaceConfirmacion",
        params: {"email": email},
        contextErr: context,
        isMostrarAlertError: true);
    if (data == null) return null;
    final dynamic decodedData = json.decode(data);
    return RespuestaDatosModel.fromJson(decodedData);
  }

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

  Future<bool> isFotoPerfil(String? correo) async {
    String? data = await ServicioUtil.get("api/Authenticate/IsImagen",
        params: {"correoUsuario": correo.toString()});
    if (data == null) return false;
    return data == 'true';
  }

  Future<RespuestaDatosModel?> guardarFotoUsuario(
      Map<String, dynamic> param, BuildContext context) async {
    dynamic data = await ServicioUtil.file(
        "api/Authenticate/SubirImagenSocial", param,
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

  Future<RespuestaDatosModel?> cargarDatosBancariosEmprendedor(
      DatosBancariosModel? datosBancariosModel, BuildContext context) async {
    String? data = await ServicioUtil.post(
        "api/Authenticate/GuardarDatosBancarios",
        json.encode(datosBancariosModel),
        isMostratAlertError: true,
        contextErr: context);
    if (data == null) return null;
    final dynamic decodedData = json.decode(data);
    return RespuestaDatosModel.fromJson(decodedData);
  }
}

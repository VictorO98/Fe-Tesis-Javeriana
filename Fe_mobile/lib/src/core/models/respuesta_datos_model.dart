// To parse this JSON data, do
//
//     final respuestaDatosModel = respuestaDatosModelFromJson(jsonString);

import 'dart:convert';

RespuestaDatosModel respuestaDatosModelFromJson(String str) =>
    RespuestaDatosModel.fromJson(json.decode(str));

String respuestaDatosModelToJson(RespuestaDatosModel data) =>
    json.encode(data.toJson());

class RespuestaDatosModel {
  RespuestaDatosModel({
    this.codigo,
    this.mensaje,
  });

  int codigo;
  String mensaje;

  factory RespuestaDatosModel.fromJson(Map<String, dynamic> json) =>
      RespuestaDatosModel(
        codigo: json["codigo"],
        mensaje: json["mensaje"],
      );

  Map<String, dynamic> toJson() => {
        "codigo": codigo,
        "mensaje": mensaje,
      };
}

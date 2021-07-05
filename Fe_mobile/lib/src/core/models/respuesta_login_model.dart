// To parse this JSON data, do
//
//     final respuestaLoginModel = respuestaLoginModelFromJson(jsonString);

import 'dart:convert';

RespuestaLoginModel respuestaLoginModelFromJson(String str) =>
    RespuestaLoginModel.fromJson(json.decode(str));

String respuestaLoginModelToJson(RespuestaLoginModel data) =>
    json.encode(data.toJson());

class RespuestaLoginModel {
  RespuestaLoginModel({
    this.codigo,
    this.mensaje,
    this.token,
    this.expire,
  });

  int? codigo;
  String? mensaje;
  String? token;
  String? expire;

  factory RespuestaLoginModel.fromJson(Map<String, dynamic> json) =>
      RespuestaLoginModel(
        codigo: json["codigo"],
        mensaje: json["mensaje"],
        token: json["token"],
        expire: json["expire"],
      );

  Map<String, dynamic> toJson() => {
        "codigo": codigo,
        "mensaje": mensaje,
        "token": token,
        "expire": expire,
      };
}

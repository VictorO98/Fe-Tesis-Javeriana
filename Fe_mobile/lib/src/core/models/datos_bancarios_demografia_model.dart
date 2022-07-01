// To parse this JSON data, do
//
//     final datosBancariosModel = datosBancariosModelFromJson(jsonString);

import 'dart:convert';

DatosBancariosModel datosBancariosModelFromJson(String str) =>
    DatosBancariosModel.fromJson(json.decode(str));

String datosBancariosModelToJson(DatosBancariosModel data) =>
    json.encode(data.toJson());

class DatosBancariosModel {
  DatosBancariosModel({
    this.email,
    this.numeroCuentaBancaria,
    this.tipoDeCuenta,
    this.entidadBancaria,
  });

  String? email;
  String? numeroCuentaBancaria;
  String? tipoDeCuenta;
  int? entidadBancaria;

  factory DatosBancariosModel.fromJson(Map<String, dynamic> json) =>
      DatosBancariosModel(
        email: json["email"],
        numeroCuentaBancaria: json["numeroCuentaBancaria"],
        tipoDeCuenta: json["tipoDeCuenta"],
        entidadBancaria: json["entidadBancaria"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "numeroCuentaBancaria": numeroCuentaBancaria,
        "tipoDeCuenta": tipoDeCuenta,
        "entidadBancaria": entidadBancaria,
      };
}

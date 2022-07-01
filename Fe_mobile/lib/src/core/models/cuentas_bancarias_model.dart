// To parse this JSON data, do
//
//     final cuentaBancariaDemografiaModel = cuentaBancariaDemografiaModelFromJson(jsonString);

import 'dart:convert';

CuentaBancariaDemografiaModel cuentaBancariaDemografiaModelFromJson(
        String str) =>
    CuentaBancariaDemografiaModel.fromJson(json.decode(str));

String cuentaBancariaDemografiaModelToJson(
        CuentaBancariaDemografiaModel data) =>
    json.encode(data.toJson());

class CuentaBancariaDemografiaModel {
  CuentaBancariaDemografiaModel({
    this.numero,
    this.tipocuenta,
    this.identidadbancaria,
  });

  int? numero;
  String? tipocuenta;
  String? identidadbancaria;

  factory CuentaBancariaDemografiaModel.fromJson(Map<String, dynamic> json) =>
      CuentaBancariaDemografiaModel(
        numero: json["numero"],
        tipocuenta: json["tipocuenta"],
        identidadbancaria: json["identidadbancaria"],
      );

  Map<String, dynamic> toJson() => {
        "numero": numero,
        "tipocuenta": tipocuenta,
        "identidadbancaria": identidadbancaria,
      };
}

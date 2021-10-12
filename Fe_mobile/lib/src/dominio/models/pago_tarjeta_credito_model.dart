// To parse this JSON data, do
//
//     final pagoTarjetaCreditoModel = pagoTarjetaCreditoModelFromJson(jsonString);

import 'dart:convert';

PagoTarjetaCreditoModel pagoTarjetaCreditoModelFromJson(String str) =>
    PagoTarjetaCreditoModel.fromJson(json.decode(str));

String pagoTarjetaCreditoModelToJson(PagoTarjetaCreditoModel data) =>
    json.encode(data.toJson());

class PagoTarjetaCreditoModel {
  PagoTarjetaCreditoModel({
    this.idDemografiaComprador,
    this.numeroTc,
    this.anioTc,
    this.mesTc,
    this.cvcTc,
    this.idPedido,
    this.cuotas,
  });

  int? idDemografiaComprador;
  String? numeroTc;
  int? anioTc;
  int? mesTc;
  int? cvcTc;
  int? idPedido;
  int? cuotas;

  factory PagoTarjetaCreditoModel.fromJson(Map<String, dynamic> json) =>
      PagoTarjetaCreditoModel(
        idDemografiaComprador: json["IdDemografiaComprador"],
        numeroTc: json["NumeroTC"],
        anioTc: json["AnioTC"],
        mesTc: json["MesTC"],
        cvcTc: json["CvcTC"],
        idPedido: json["IdPedido"],
        cuotas: json["Cuotas"],
      );

  Map<String, dynamic> toJson() => {
        "IdDemografiaComprador": idDemografiaComprador,
        "NumeroTC": numeroTc,
        "AnioTC": anioTc,
        "MesTC": mesTc,
        "CvcTC": cvcTc,
        "IdPedido": idPedido,
        "Cuotas": cuotas,
      };
}

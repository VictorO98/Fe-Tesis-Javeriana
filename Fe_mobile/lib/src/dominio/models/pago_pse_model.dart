// To parse this JSON data, do
//
//     final pagoPseModel = pagoPseModelFromJson(jsonString);

import 'dart:convert';

PagoPseModel pagoPseModelFromJson(String str) =>
    PagoPseModel.fromJson(json.decode(str));

String pagoPseModelToJson(PagoPseModel data) => json.encode(data.toJson());

class PagoPseModel {
  PagoPseModel({
    this.idDemografiaComprador,
    this.idPedido,
    this.banco,
  });

  int? idDemografiaComprador;
  int? idPedido;
  String? banco;

  factory PagoPseModel.fromJson(Map<String, dynamic> json) => PagoPseModel(
        idDemografiaComprador: json["IdDemografiaComprador"],
        idPedido: json["IdPedido"],
        banco: json["Banco"],
      );

  Map<String, dynamic> toJson() => {
        "IdDemografiaComprador": idDemografiaComprador,
        "IdPedido": idPedido,
        "Banco": banco,
      };
}

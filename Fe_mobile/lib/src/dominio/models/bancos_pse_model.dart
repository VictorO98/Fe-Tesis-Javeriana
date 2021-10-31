// To parse this JSON data, do
//
//     final bancosPseModel = bancosPseModelFromJson(jsonString);

import 'dart:convert';

BancosPseModel bancosPseModelFromJson(String str) =>
    BancosPseModel.fromJson(json.decode(str));

String bancosPseModelToJson(BancosPseModel data) => json.encode(data.toJson());

class BancosPseModel {
  BancosPseModel({
    this.id,
    this.nombre,
  });

  int? id;
  String? nombre;

  factory BancosPseModel.fromJson(Map<String, dynamic> json) => BancosPseModel(
        id: json["id"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
      };
}

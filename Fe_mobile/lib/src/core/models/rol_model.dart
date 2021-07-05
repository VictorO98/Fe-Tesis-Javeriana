// To parse this JSON data, do
//
//     final rolModel = rolModelFromJson(jsonString);

import 'dart:convert';

List<RolModel> rolModelFromJson(String str) =>
    List<RolModel>.from(json.decode(str).map((x) => RolModel.fromJson(x)));

String rolModelToJson(List<RolModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RolModel {
  RolModel({
    this.id,
    this.nombre,
    this.creacion,
    this.demografiaCors,
  });

  int? id;
  String? nombre;
  DateTime? creacion;
  List<dynamic>? demografiaCors;

  factory RolModel.fromJson(Map<String, dynamic> json) => RolModel(
        id: json["id"],
        nombre: json["nombre"],
        creacion: DateTime.parse(json["creacion"]),
        demografiaCors:
            List<dynamic>.from(json["demografiaCors"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "creacion": creacion!.toIso8601String(),
        "demografiaCors": List<dynamic>.from(demografiaCors!.map((x) => x)),
      };
}

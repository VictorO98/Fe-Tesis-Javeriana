// To parse this JSON data, do
//
//     final departamentoModel = departamentoModelFromJson(jsonString);

import 'dart:convert';

DepartamentoModel departamentoModelFromJson(String str) =>
    DepartamentoModel.fromJson(json.decode(str));

String departamentoModelToJson(DepartamentoModel data) =>
    json.encode(data.toJson());

class DepartamentoModel {
  DepartamentoModel({
    this.id,
    this.nombre,
    this.poblacionCors,
  });

  int? id;
  String? nombre;
  List<dynamic>? poblacionCors;

  factory DepartamentoModel.fromJson(Map<String, dynamic> json) =>
      DepartamentoModel(
        id: json["id"],
        nombre: json["nombre"],
        poblacionCors: List<dynamic>.from(json["poblacionCors"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "poblacionCors": List<dynamic>.from(poblacionCors!.map((x) => x)),
      };
}

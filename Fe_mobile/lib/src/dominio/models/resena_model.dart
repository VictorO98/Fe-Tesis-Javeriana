// To parse this JSON data, do
//
//     final resenaModel = resenaModelFromJson(jsonString);

import 'dart:convert';

ResenaModel resenaModelFromJson(String str) =>
    ResenaModel.fromJson(json.decode(str));

String resenaModelToJson(ResenaModel data) => json.encode(data.toJson());

class ResenaModel {
  ResenaModel({
    this.id,
    this.idpublicacion,
    this.comentarios,
    this.puntuacion,
    this.creacion,
    this.idpublicacionNavigation,
  });

  int? id;
  int? idpublicacion;
  String? comentarios;
  double? puntuacion;
  DateTime? creacion;
  dynamic idpublicacionNavigation;

  factory ResenaModel.fromJson(Map<String, dynamic> json) => ResenaModel(
        id: json["id"],
        idpublicacion: json["idpublicacion"],
        comentarios: json["comentarios"],
        puntuacion: json["puntuacion"].toDouble(),
        creacion: DateTime.parse(json["creacion"]),
        idpublicacionNavigation: json["idpublicacionNavigation"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idpublicacion": idpublicacion,
        "comentarios": comentarios,
        "puntuacion": puntuacion,
        "creacion": creacion!.toIso8601String(),
        "idpublicacionNavigation": idpublicacionNavigation,
      };
}

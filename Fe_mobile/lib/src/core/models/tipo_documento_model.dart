// To parse this JSON data, do
//
//     final tipoDocumentoCorModel = tipoDocumentoCorModelFromJson(jsonString);

import 'dart:convert';

TipoDocumentoCorModel tipoDocumentoCorModelFromJson(String str) =>
    TipoDocumentoCorModel.fromJson(json.decode(str));

String tipoDocumentoCorModelToJson(TipoDocumentoCorModel data) =>
    json.encode(data.toJson());

class TipoDocumentoCorModel {
  TipoDocumentoCorModel({
    this.id,
    this.nombre,
    this.creacion,
    this.demografiaCors,
  });

  int id;
  String nombre;
  DateTime creacion;
  List<dynamic> demografiaCors;

  factory TipoDocumentoCorModel.fromJson(Map<String, dynamic> json) =>
      TipoDocumentoCorModel(
        id: json["id"],
        nombre: json["nombre"],
        creacion: DateTime.parse(json["creacion"]),
        demografiaCors:
            List<dynamic>.from(json["demografiaCors"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "creacion": creacion.toIso8601String(),
        "demografiaCors": List<dynamic>.from(demografiaCors.map((x) => x)),
      };
}

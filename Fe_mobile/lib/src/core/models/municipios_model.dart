// To parse this JSON data, do
//
//     final municipiosModel = municipiosModelFromJson(jsonString);

import 'dart:convert';

MunicipiosModel municipiosModelFromJson(String str) =>
    MunicipiosModel.fromJson(json.decode(str));

String municipiosModelToJson(MunicipiosModel data) =>
    json.encode(data.toJson());

class MunicipiosModel {
  MunicipiosModel({
    this.id,
    this.nombre,
    this.idestadopoblacion,
    this.estado,
    this.idestadopoblacionNavigation,
    this.demografiaCors,
  });

  int? id;
  String? nombre;
  int? idestadopoblacion;
  String? estado;
  dynamic idestadopoblacionNavigation;
  List<dynamic>? demografiaCors;

  factory MunicipiosModel.fromJson(Map<String, dynamic> json) =>
      MunicipiosModel(
        id: json["id"],
        nombre: json["nombre"],
        idestadopoblacion: json["idestadopoblacion"],
        estado: json["estado"],
        idestadopoblacionNavigation: json["idestadopoblacionNavigation"],
        demografiaCors:
            List<dynamic>.from(json["demografiaCors"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "idestadopoblacion": idestadopoblacion,
        "estado": estado,
        "idestadopoblacionNavigation": idestadopoblacionNavigation,
        "demografiaCors": List<dynamic>.from(demografiaCors!.map((x) => x)),
      };
}

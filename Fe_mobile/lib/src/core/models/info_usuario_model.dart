// To parse this JSON data, do
//
//     final infoUsuarioModel = infoUsuarioModelFromJson(jsonString);

import 'dart:convert';

InfoUsuarioModel infoUsuarioModelFromJson(String str) =>
    InfoUsuarioModel.fromJson(json.decode(str));

String infoUsuarioModelToJson(InfoUsuarioModel data) =>
    json.encode(data.toJson());

class InfoUsuarioModel {
  InfoUsuarioModel({
    this.email,
    this.numeroTelefono,
    this.tipoDocumento,
    this.documento,
    this.nombreCompleto,
    this.nombres,
    this.apellidos,
    this.rol,
    this.direccion,
    this.poblacion,
    this.estado,
  });

  String? email;
  String? numeroTelefono;
  String? tipoDocumento;
  String? documento;
  String? nombreCompleto;
  String? nombres;
  String? apellidos;
  String? rol;
  String? direccion;
  String? poblacion;
  String? estado;

  factory InfoUsuarioModel.fromJson(Map<String, dynamic> json) =>
      InfoUsuarioModel(
          email: json["email"],
          numeroTelefono: json["numeroTelefono"],
          tipoDocumento: json["tipoDocumento"],
          documento: json["documento"],
          nombreCompleto: json["nombreCompleto"],
          nombres: json["nombres"],
          apellidos: json["apellidos"],
          rol: json["rol"],
          direccion: json["direccion"],
          poblacion: json["poblacion"],
          estado: json["estado"]);

  Map<String, dynamic> toJson() => {
        "email": email,
        "numeroTelefono": numeroTelefono,
        "tipoDocumento": tipoDocumento,
        "documento": documento,
        "nombreCompleto": nombreCompleto,
        "nombres": nombres,
        "apellidos": apellidos,
        "rol": rol,
        "direccion": direccion,
        "poblacion": poblacion,
        "estado": estado,
      };
}

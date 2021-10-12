// To parse this JSON data, do
//
//     final editarDemografiaModel = editarDemografiaModelFromJson(jsonString);

import 'dart:convert';

EditarDemografiaModel editarDemografiaModelFromJson(String str) =>
    EditarDemografiaModel.fromJson(json.decode(str));

String editarDemografiaModelToJson(EditarDemografiaModel data) =>
    json.encode(data.toJson());

class EditarDemografiaModel {
  EditarDemografiaModel({
    this.nombre,
    this.apellido,
    this.nroDocumento,
    this.telefono,
    this.direccion,
    this.idPoblacion,
    this.correo,
  });

  String? nombre;
  String? apellido;
  int? nroDocumento;
  int? telefono;
  String? direccion;
  int? idPoblacion;
  String? correo;

  factory EditarDemografiaModel.fromJson(Map<String, dynamic> json) =>
      EditarDemografiaModel(
        nombre: json["Nombre"],
        apellido: json["Apellido"],
        nroDocumento: json["NroDocumento"],
        telefono: json["Telefono"],
        direccion: json["Direccion"],
        idPoblacion: json["IdPoblacion"],
        correo: json["Correo"],
      );

  Map<String, dynamic> toJson() => {
        "Nombre": nombre,
        "Apellido": apellido,
        "NroDocumento": nroDocumento,
        "Telefono": telefono,
        "Direccion": direccion,
        "IdPoblacion": idPoblacion,
        "Correo": correo,
      };
}

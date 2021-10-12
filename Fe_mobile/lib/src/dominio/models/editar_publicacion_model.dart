// To parse this JSON data, do
//
//     final editarPublicacionModel = editarPublicacionModelFromJson(jsonString);

import 'dart:convert';

EditarPublicacionModel editarPublicacionModelFromJson(String str) =>
    EditarPublicacionModel.fromJson(json.decode(str));

String editarPublicacionModelToJson(EditarPublicacionModel data) =>
    json.encode(data.toJson());

class EditarPublicacionModel {
  EditarPublicacionModel({
    this.id,
    this.nombre,
    this.descripcion,
    this.cantidadtotal,
    this.preciounitario,
    this.descuento,
    this.habilitatrueque,
  });

  int? id;
  String? nombre;
  String? descripcion;
  int? cantidadtotal;
  int? preciounitario;
  double? descuento;
  int? habilitatrueque;

  factory EditarPublicacionModel.fromJson(Map<String, dynamic> json) =>
      EditarPublicacionModel(
        id: json["Id"],
        nombre: json["Nombre"],
        descripcion: json["Descripcion"],
        cantidadtotal: json["Cantidad"],
        preciounitario: json["Preciounitario"],
        descuento: json["Descuento"],
        habilitatrueque: json["Habilitatrueque"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Nombre": nombre,
        "Descripcion": descripcion,
        "Cantidad": cantidadtotal,
        "Preciounitario": preciounitario,
        "Descuento": descuento,
        "Habilitatrueque": habilitatrueque,
      };
}

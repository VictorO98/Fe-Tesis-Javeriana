// To parse this JSON data, do
//
//     final crearTruequeModel = crearTruequeModelFromJson(jsonString);

import 'dart:convert';

CrearTruequeModel crearTruequeModelFromJson(String str) =>
    CrearTruequeModel.fromJson(json.decode(str));

String crearTruequeModelToJson(CrearTruequeModel data) =>
    json.encode(data.toJson());

class CrearTruequeModel {
  CrearTruequeModel({
    this.idproductoserviciocomprador,
    this.idproductoserviciovendedor,
    this.cantidadcomprador,
    this.cantidadvendedor,
  });

  int? idproductoserviciocomprador;
  int? idproductoserviciovendedor;
  int? cantidadcomprador;
  int? cantidadvendedor;

  factory CrearTruequeModel.fromJson(Map<String, dynamic> json) =>
      CrearTruequeModel(
        idproductoserviciocomprador: json["Idproductoserviciocomprador"],
        idproductoserviciovendedor: json["Idproductoserviciovendedor"],
        cantidadcomprador: json["Cantidadcomprador"],
        cantidadvendedor: json["Cantidadvendedor"],
      );

  Map<String, dynamic> toJson() => {
        "Idproductoserviciocomprador": idproductoserviciocomprador,
        "Idproductoserviciovendedor": idproductoserviciovendedor,
        "Cantidadcomprador": cantidadcomprador,
        "Cantidadvendedor": cantidadvendedor,
      };
}

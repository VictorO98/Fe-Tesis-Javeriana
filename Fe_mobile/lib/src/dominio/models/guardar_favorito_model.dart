// To parse this JSON data, do
//
//     final guardarPublicacionFavoritaModel = guardarPublicacionFavoritaModelFromJson(jsonString);

import 'dart:convert';

GuardarPublicacionFavoritaModel guardarPublicacionFavoritaModelFromJson(
        String str) =>
    GuardarPublicacionFavoritaModel.fromJson(json.decode(str));

String guardarPublicacionFavoritaModelToJson(
        GuardarPublicacionFavoritaModel data) =>
    json.encode(data.toJson());

class GuardarPublicacionFavoritaModel {
  GuardarPublicacionFavoritaModel({
    this.iddemografia,
    this.idproductoservicio,
  });

  int? iddemografia;
  int? idproductoservicio;

  factory GuardarPublicacionFavoritaModel.fromJson(Map<String, dynamic> json) =>
      GuardarPublicacionFavoritaModel(
        iddemografia: json["Iddemografia"],
        idproductoservicio: json["Idproductoservicio"],
      );

  Map<String, dynamic> toJson() => {
        "Iddemografia": iddemografia,
        "Idproductoservicio": idproductoservicio,
      };
}

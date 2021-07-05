// To parse this JSON data, do
//
//     final preguntaRespuestaModel = preguntaRespuestaModelFromJson(jsonString);

import 'dart:convert';

PreguntaRespuestaModel preguntaRespuestaModelFromJson(String str) =>
    PreguntaRespuestaModel.fromJson(json.decode(str));

String preguntaRespuestaModelToJson(PreguntaRespuestaModel data) =>
    json.encode(data.toJson());

class PreguntaRespuestaModel {
  PreguntaRespuestaModel({
    this.id,
    this.idproductoservicio,
    this.pregunta,
    this.respuesta,
    this.creacion,
    this.modificacion,
    this.idproductoservicioNavigation,
  });

  int? id;
  int? idproductoservicio;
  String? pregunta;
  String? respuesta;
  DateTime? creacion;
  DateTime? modificacion;
  dynamic idproductoservicioNavigation;

  factory PreguntaRespuestaModel.fromJson(Map<String, dynamic> json) =>
      PreguntaRespuestaModel(
        id: json["id"],
        idproductoservicio: json["idproductoservicio"],
        pregunta: json["pregunta"],
        respuesta: json["respuesta"],
        creacion: DateTime.parse(json["creacion"]),
        modificacion: DateTime.parse(json["modificacion"]),
        idproductoservicioNavigation: json["idproductoservicioNavigation"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idproductoservicio": idproductoservicio,
        "pregunta": pregunta,
        "respuesta": respuesta,
        "creacion": creacion!.toIso8601String(),
        "modificacion": modificacion!.toIso8601String(),
        "idproductoservicioNavigation": idproductoservicioNavigation,
      };
}

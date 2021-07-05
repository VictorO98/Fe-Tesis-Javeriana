// To parse this JSON data, do
//
//     final productoServicioModel = productoServicioModelFromJson(jsonString);

import 'dart:convert';

import 'package:Fe_mobile/src/dominio/models/preguntas_respuestas_model.dart';

ProductoServicioModel productoServicioModelFromJson(String str) =>
    ProductoServicioModel.fromJson(json.decode(str));

String productoServicioModelToJson(ProductoServicioModel data) =>
    json.encode(data.toJson());

class ProductoServicioModel {
  ProductoServicioModel({
    this.id,
    this.descripcion,
    this.cantidadtotal,
    this.tiempoentrega,
    this.tiempogarantia,
    this.preciounitario,
    this.descuento,
    this.calificacionpromedio,
    this.habilitatrueque,
    this.nombre,
    this.urlimagenproductoservicio,
    this.nombreCategoria,
    this.tipoPublicacion,
    this.idusuarioNavigation,
    this.preguntasRespuestas,
    this.prodSerTruequeTrueIdproductoserviciocompradorNavigations,
    this.prodSerTruequeTrueIdproductoserviciovendedorNavigations,
    this.prodSerXVendidosPeds,
    this.resenas,
  });

  int id;
  String descripcion;
  int cantidadtotal;
  DateTime tiempoentrega;
  DateTime tiempogarantia;
  int preciounitario;
  int descuento;
  double calificacionpromedio;
  int habilitatrueque;
  String nombre;
  String urlimagenproductoservicio;
  String nombreCategoria;
  String tipoPublicacion;
  dynamic idusuarioNavigation;
  List<PreguntaRespuestaModel> preguntasRespuestas;
  dynamic prodSerTruequeTrueIdproductoserviciocompradorNavigations;
  dynamic prodSerTruequeTrueIdproductoserviciovendedorNavigations;
  dynamic prodSerXVendidosPeds;
  List<Resena> resenas;

  factory ProductoServicioModel.fromJson(Map<String, dynamic> json) =>
      ProductoServicioModel(
        id: json["id"],
        descripcion: json["descripcion"],
        cantidadtotal: json["cantidadtotal"],
        tiempoentrega: DateTime.parse(json["tiempoentrega"]),
        tiempogarantia: DateTime.parse(json["tiempogarantia"]),
        preciounitario: json["preciounitario"],
        descuento: json["descuento"],
        calificacionpromedio: json["calificacionpromedio"].toDouble(),
        habilitatrueque: json["habilitatrueque"],
        nombre: json["nombre"],
        urlimagenproductoservicio: json["urlimagenproductoservicio"],
        nombreCategoria: json["nombreCategoria"],
        tipoPublicacion: json["tipoPublicacion"],
        idusuarioNavigation: json["idusuarioNavigation"],
        preguntasRespuestas: List<PreguntaRespuestaModel>.from(
            json["preguntasRespuestas"]
                .map((x) => PreguntaRespuestaModel.fromJson(x))),
        prodSerTruequeTrueIdproductoserviciocompradorNavigations:
            json["prodSerTruequeTrueIdproductoserviciocompradorNavigations"],
        prodSerTruequeTrueIdproductoserviciovendedorNavigations:
            json["prodSerTruequeTrueIdproductoserviciovendedorNavigations"],
        prodSerXVendidosPeds: json["prodSerXVendidosPeds"],
        resenas:
            List<Resena>.from(json["resenas"].map((x) => Resena.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "descripcion": descripcion,
        "cantidadtotal": cantidadtotal,
        "tiempoentrega": tiempoentrega.toIso8601String(),
        "tiempogarantia": tiempogarantia.toIso8601String(),
        "preciounitario": preciounitario,
        "descuento": descuento,
        "calificacionpromedio": calificacionpromedio,
        "habilitatrueque": habilitatrueque,
        "nombre": nombre,
        "urlimagenproductoservicio": urlimagenproductoservicio,
        "nombreCategoria": nombreCategoria,
        "tipoPublicacion": tipoPublicacion,
        "idusuarioNavigation": idusuarioNavigation,
        "preguntasRespuestas":
            List<dynamic>.from(preguntasRespuestas.map((x) => x.toJson())),
        "prodSerTruequeTrueIdproductoserviciocompradorNavigations":
            prodSerTruequeTrueIdproductoserviciocompradorNavigations,
        "prodSerTruequeTrueIdproductoserviciovendedorNavigations":
            prodSerTruequeTrueIdproductoserviciovendedorNavigations,
        "prodSerXVendidosPeds": prodSerXVendidosPeds,
        "resenas": List<dynamic>.from(resenas.map((x) => x.toJson())),
      };
}

class Resena {
  Resena({
    this.id,
    this.idpublicacion,
    this.comentarios,
    this.puntuacion,
    this.creacion,
    this.idpublicacionNavigation,
  });

  int id;
  int idpublicacion;
  String comentarios;
  double puntuacion;
  DateTime creacion;
  dynamic idpublicacionNavigation;

  factory Resena.fromJson(Map<String, dynamic> json) => Resena(
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
        "creacion": creacion.toIso8601String(),
        "idpublicacionNavigation": idpublicacionNavigation,
      };
}

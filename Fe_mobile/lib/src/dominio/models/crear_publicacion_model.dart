// To parse this JSON data, do
//
//     final crearPublicacionModel = crearPublicacionModelFromJson(jsonString);

import 'dart:convert';

CrearPublicacionModel crearPublicacionModelFromJson(String str) => CrearPublicacionModel.fromJson(json.decode(str));

String crearPublicacionModelToJson(CrearPublicacionModel data) => json.encode(data.toJson());

class CrearPublicacionModel {
    CrearPublicacionModel({
        this.idcategoria,
        this.idtipopublicacion,
        this.idusuario,
        this.nombre,
        this.descripcion,
        this.cantidadtotal,
        this.tiempoentrega,
        this.tiempogarantia,
        this.preciounitario,
        this.descuento,
        this.habilitatrueque,
        this.urlimagenproductoservicio,
    });

    int? idcategoria;
    int? idtipopublicacion;
    int? idusuario;
    String? nombre;
    String? descripcion;
    int? cantidadtotal;
    DateTime? tiempoentrega;
    DateTime? tiempogarantia;
    int? preciounitario;
    int? descuento;
    int? habilitatrueque;
    String? urlimagenproductoservicio;

    factory CrearPublicacionModel.fromJson(Map<String, dynamic> json) => CrearPublicacionModel(
        idcategoria: json["Idcategoria"],
        idtipopublicacion: json["Idtipopublicacion"],
        idusuario: json["Idusuario"],
        nombre: json["Nombre"],
        descripcion: json["Descripcion"],
        cantidadtotal: json["Cantidadtotal"],
        tiempoentrega: DateTime.parse(json["Tiempoentrega"]),
        tiempogarantia: DateTime.parse(json["Tiempogarantia"]),
        preciounitario: json["Preciounitario"],
        descuento: json["Descuento"],
        habilitatrueque: json["Habilitatrueque"],
        urlimagenproductoservicio: json["Urlimagenproductoservicio"],
    );

    Map<String, dynamic> toJson() => {
        "Idcategoria": idcategoria,
        "Idtipopublicacion": idtipopublicacion,
        "Idusuario": idusuario,
        "Nombre": nombre,
        "Descripcion": descripcion,
        "Cantidadtotal": cantidadtotal,
        "Tiempoentrega": "${tiempoentrega!.year.toString().padLeft(4, '0')}-${tiempoentrega!.month.toString().padLeft(2, '0')}-${tiempoentrega!.day.toString().padLeft(2, '0')}",
        "Tiempogarantia": "${tiempogarantia!.year.toString().padLeft(4, '0')}-${tiempogarantia!.month.toString().padLeft(2, '0')}-${tiempogarantia!.day.toString().padLeft(2, '0')}",
        "Preciounitario": preciounitario,
        "Descuento": descuento,
        "Habilitatrueque": habilitatrueque,
        "Urlimagenproductoservicio": urlimagenproductoservicio,
    };
}

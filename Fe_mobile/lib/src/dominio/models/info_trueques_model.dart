// To parse this JSON data, do
//
//     final infoTruequesModel = infoTruequesModelFromJson(jsonString);

import 'dart:convert';

List<InfoTruequesModel> infoTruequesModelFromJson(String str) =>
    List<InfoTruequesModel>.from(
        json.decode(str).map((x) => InfoTruequesModel.fromJson(x)));

String infoTruequesModelToJson(List<InfoTruequesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InfoTruequesModel {
  InfoTruequesModel({
    this.id,
    this.idcomprador,
    this.idvendedor,
    this.estado,
    this.fechatrueque,
    this.idcompradorNavigation,
    this.idvendedorNavigation,
    this.detalleTrueque,
    this.prodSerTruequeTrues,
  });

  int? id;
  int? idcomprador;
  int? idvendedor;
  String? estado;
  DateTime? fechatrueque;
  dynamic idcompradorNavigation;
  dynamic idvendedorNavigation;
  ProdSerTruequeTrue? detalleTrueque;
  List<ProdSerTruequeTrue>? prodSerTruequeTrues;

  factory InfoTruequesModel.fromJson(Map<String, dynamic> json) =>
      InfoTruequesModel(
        id: json["id"],
        idcomprador: json["idcomprador"],
        idvendedor: json["idvendedor"],
        estado: json["estado"],
        fechatrueque: DateTime.parse(json["fechatrueque"]),
        idcompradorNavigation: json["idcompradorNavigation"],
        idvendedorNavigation: json["idvendedorNavigation"],
        prodSerTruequeTrues: List<ProdSerTruequeTrue>.from(
            json["prodSerTruequeTrues"]
                .map((x) => ProdSerTruequeTrue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idcomprador": idcomprador,
        "idvendedor": idvendedor,
        "estado": estado,
        "fechatrueque": fechatrueque!.toIso8601String(),
        "idcompradorNavigation": idcompradorNavigation,
        "idvendedorNavigation": idvendedorNavigation,
        "prodSerTruequeTrues":
            List<dynamic>.from(prodSerTruequeTrues!.map((x) => x.toJson())),
      };
}

class ProdSerTruequeTrue {
  ProdSerTruequeTrue({
    this.id,
    this.idtruequepedido,
    this.idproductoserviciocomprador,
    this.idproductoserviciovendedor,
    this.cantidadcomprador,
    this.cantidadvendedor,
    this.creacion,
    this.idproductoserviciocompradorNavigation,
    this.idproductoserviciovendedorNavigation,
    this.idtruequepedidoNavigation,
  });

  int? id;
  int? idtruequepedido;
  int? idproductoserviciocomprador;
  int? idproductoserviciovendedor;
  int? cantidadcomprador;
  int? cantidadvendedor;
  DateTime? creacion;
  dynamic idproductoserviciocompradorNavigation;
  dynamic idproductoserviciovendedorNavigation;
  dynamic idtruequepedidoNavigation;

  factory ProdSerTruequeTrue.fromJson(Map<String, dynamic> json) =>
      ProdSerTruequeTrue(
        id: json["id"],
        idtruequepedido: json["idtruequepedido"],
        idproductoserviciocomprador: json["idproductoserviciocomprador"],
        idproductoserviciovendedor: json["idproductoserviciovendedor"],
        cantidadcomprador: json["cantidadcomprador"],
        cantidadvendedor: json["cantidadvendedor"],
        creacion: DateTime.parse(json["creacion"]),
        idproductoserviciocompradorNavigation:
            json["idproductoserviciocompradorNavigation"],
        idproductoserviciovendedorNavigation:
            json["idproductoserviciovendedorNavigation"],
        idtruequepedidoNavigation: json["idtruequepedidoNavigation"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idtruequepedido": idtruequepedido,
        "idproductoserviciocomprador": idproductoserviciocomprador,
        "idproductoserviciovendedor": idproductoserviciovendedor,
        "cantidadcomprador": cantidadcomprador,
        "cantidadvendedor": cantidadvendedor,
        "creacion": creacion!.toIso8601String(),
        "idproductoserviciocompradorNavigation":
            idproductoserviciocompradorNavigation,
        "idproductoserviciovendedorNavigation":
            idproductoserviciovendedorNavigation,
        "idtruequepedidoNavigation": idtruequepedidoNavigation,
      };
}

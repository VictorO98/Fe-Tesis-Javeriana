// To parse this JSON data, do
//
//     final guardarProductoPedidoModel = guardarProductoPedidoModelFromJson(jsonString);

import 'dart:convert';

GuardarProductoPedidoModel guardarProductoPedidoModelFromJson(String str) =>
    GuardarProductoPedidoModel.fromJson(json.decode(str));

String guardarProductoPedidoModelToJson(GuardarProductoPedidoModel data) =>
    json.encode(data.toJson());

class GuardarProductoPedidoModel {
  GuardarProductoPedidoModel({
    this.id,
    this.idproductoservico,
    this.idpedido,
    this.preciototal,
    this.cantidadespedida,
  });

  int? id;
  int? idproductoservico;
  int? idpedido;
  int? preciototal;
  int? cantidadespedida;

  factory GuardarProductoPedidoModel.fromJson(Map<String, dynamic> json) =>
      GuardarProductoPedidoModel(
        id: json["Id"],
        idproductoservico: json["Idproductoservico"],
        idpedido: json["Idpedido"],
        preciototal: json["Preciototal"],
        cantidadespedida: json["Cantidadespedida"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Idproductoservico": idproductoservico,
        "Idpedido": idpedido,
        "Preciototal": preciototal,
        "Cantidadespedida": cantidadespedida,
      };
}

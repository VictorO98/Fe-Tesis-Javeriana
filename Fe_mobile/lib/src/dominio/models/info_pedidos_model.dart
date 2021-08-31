// To parse this JSON data, do
//
//     final infoPedidosModel = infoPedidosModelFromJson(jsonString);

import 'dart:convert';

List<InfoPedidosModel> infoPedidosModelFromJson(String str) =>
    List<InfoPedidosModel>.from(
        json.decode(str).map((x) => InfoPedidosModel.fromJson(x)));

String infoPedidosModelToJson(List<InfoPedidosModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InfoPedidosModel {
  InfoPedidosModel({
    this.id,
    this.estado,
    this.fechapedido,
    this.productos,
    this.idusuarioNavigation,
    this.prodSerXVendidosPeds,
  });

  int? id;
  String? estado;
  DateTime? fechapedido;
  List<Producto>? productos;
  dynamic idusuarioNavigation;
  dynamic prodSerXVendidosPeds;

  factory InfoPedidosModel.fromJson(Map<String, dynamic> json) =>
      InfoPedidosModel(
        id: json["id"],
        estado: json["estado"],
        fechapedido: DateTime.parse(json["fechapedido"]),
        productos: List<Producto>.from(
            json["productos"].map((x) => Producto.fromJson(x))),
        idusuarioNavigation: json["idusuarioNavigation"],
        prodSerXVendidosPeds: json["prodSerXVendidosPeds"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "estado": estado,
        "fechapedido": fechapedido!.toIso8601String(),
        "productos": List<dynamic>.from(productos!.map((x) => x.toJson())),
        "idusuarioNavigation": idusuarioNavigation,
        "prodSerXVendidosPeds": prodSerXVendidosPeds,
      };
}

class Producto {
  Producto({
    this.id,
    this.precio,
    this.cantidad,
    this.fecha,
    this.idpedidoNavigation,
    this.idproductoservicoNavigation,
  });

  int? id;
  int? precio;
  int? cantidad;
  DateTime? fecha;
  dynamic idpedidoNavigation;
  dynamic idproductoservicoNavigation;

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        id: json["id"],
        precio: json["precio"],
        cantidad: json["cantidad"],
        fecha: DateTime.parse(json["fecha"]),
        idpedidoNavigation: json["idpedidoNavigation"],
        idproductoservicoNavigation: json["idproductoservicoNavigation"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "precio": precio,
        "cantidad": cantidad,
        "fecha": fecha!.toIso8601String(),
        "idpedidoNavigation": idpedidoNavigation,
        "idproductoservicoNavigation": idproductoservicoNavigation,
      };
}

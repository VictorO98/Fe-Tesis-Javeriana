// To parse this JSON data, do
//
//     final guardarPedidoModel = guardarPedidoModelFromJson(jsonString);

import 'dart:convert';

GuardarPedidoModel guardarPedidoModelFromJson(String str) =>
    GuardarPedidoModel.fromJson(json.decode(str));

String guardarPedidoModelToJson(GuardarPedidoModel data) =>
    json.encode(data.toJson());

class GuardarPedidoModel {
  GuardarPedidoModel({
    this.id,
    this.idusuario,
    this.estado,
  });

  int? id;
  int? idusuario;
  String? estado;

  factory GuardarPedidoModel.fromJson(Map<String, dynamic> json) =>
      GuardarPedidoModel(
        id: json["Id"],
        idusuario: json["Idusuario"],
        estado: json["Estado"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Idusuario": idusuario,
        "Estado": estado,
      };
}

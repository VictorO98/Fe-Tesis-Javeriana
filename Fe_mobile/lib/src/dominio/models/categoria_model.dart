// To parse this JSON data, do
//
//     final categoriaModel = categoriaModelFromJson(jsonString);

import 'dart:convert';

CategoriaModel categoriaModelFromJson(String str) =>
    CategoriaModel.fromJson(json.decode(str));

String categoriaModelToJson(CategoriaModel data) => json.encode(data.toJson());

class CategoriaModel {
  CategoriaModel({
    this.id,
    this.nombre,
    this.creacion,
    this.productosServiciosPcs,
  });

  int? id;
  String? nombre;
  DateTime? creacion;
  List<dynamic>? productosServiciosPcs;

  factory CategoriaModel.fromJson(Map<String, dynamic> json) => CategoriaModel(
        id: json["id"],
        nombre: json["nombre"],
        creacion: DateTime.parse(json["creacion"]),
        productosServiciosPcs:
            List<dynamic>.from(json["productosServiciosPcs"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "creacion": creacion!.toIso8601String(),
        "productosServiciosPcs":
            List<dynamic>.from(productosServiciosPcs!.map((x) => x)),
      };
}

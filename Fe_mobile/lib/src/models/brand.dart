import 'package:Fe_mobile/src/dominio/models/producto_servicio_model.dart';
import 'package:Fe_mobile/src/models/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Brand {
  String id = UniqueKey().toString();
  String name;
  String logo;
  bool? selected;
  double rate;
  List<ProductoServicioModel> products;
  Color color;

  Brand(this.name, this.logo, this.color, this.selected, this.rate,
      this.products);
}

class BrandsList {
  List<Brand>? _list;

  List<Brand>? get list => _list;

  selectById(String id) {
    this._list!.forEach((Brand brand) {
      brand.selected = false;
      if (brand.id == id) {
        brand.selected = true;
      }
    });
  }
}

import 'dart:ui';

import 'package:Fe_mobile/config/ui_icons.dart';
import 'package:Fe_mobile/src/dominio/models/carrito_compras_model.dart';
import 'package:flutter/material.dart';

class ShoppingCartButtonWidget extends StatelessWidget {
  ShoppingCartButtonWidget({
    this.iconColor,
    this.labelColor,
    this.labelCount = 0,
    Key? key,
  }) : super(key: key);

  final Color? iconColor;
  final Color? labelColor;
  int labelCount;

  CarritoComprasModel carritoComprasModel = new CarritoComprasModel();

  @override
  Widget build(BuildContext context) {
    labelCount = carritoComprasModel.returSizeCarrito();
    return FlatButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/Cart');
      },
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Icon(
              Icons.add_shopping_cart_outlined,
              color: this.iconColor,
              size: 28,
            ),
          ),
          Container(
            child: Text(
              this.labelCount.toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption!.merge(
                    TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 9),
                  ),
            ),
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
                color: this.labelColor,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            constraints: BoxConstraints(
                minWidth: 15, maxWidth: 15, minHeight: 15, maxHeight: 15),
          ),
        ],
      ),
      color: Colors.transparent,
    );
  }
}

import 'package:Fe_mobile/src/core/util/alert_util.dart';
import 'package:Fe_mobile/src/core/util/currency_util.dart';
import 'package:Fe_mobile/src/dominio/models/carrito_compras_model.dart';
import 'package:Fe_mobile/src/dominio/models/producto_servicio_model.dart';
import 'package:Fe_mobile/src/models/product.dart';
import 'package:Fe_mobile/src/models/route_argument.dart';
import 'package:flutter/material.dart';

class CartItemWidget extends StatefulWidget {
  String? heroTag;
  ProductoServicioModel? product;
  int quantity;

  CartItemWidget({Key? key, this.product, this.heroTag, this.quantity = 0})
      : super(key: key);

  @override
  _CartItemWidgetState createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  CarritoComprasModel _carrito = new CarritoComprasModel();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        Navigator.of(context).pushNamed('/Product',
            arguments: RouteArgument(
                id: widget.product!.id,
                argumentsList: [widget.product, widget.heroTag]));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).focusColor.withOpacity(0.1),
                blurRadius: 5,
                offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: widget.heroTag! + widget.product!.id.toString(),
              child: Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  image: DecorationImage(
                    image: NetworkImage(
                        widget.product!.urlimagenproductoservicio.toString()),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            SizedBox(width: 15),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.product!.nombre!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Text(
                          widget.product!.descuento == 0.0
                              ? "${CurrencyUtil.convertFormatMoney('COP', widget.product!.preciounitario!)}"
                              : "${CurrencyUtil.convertFormatMoney('COP', widget.product!.preciounitario! - ((widget.product!.descuento! / 100) * widget.product!.preciounitario!).toInt())}",
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          setState(() {
                            widget.product!.cantidadComprador =
                                this.incrementQuantity();
                          });
                        },
                        iconSize: 30,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        icon: Icon(Icons.add_circle_outline),
                        color: Theme.of(context).hintColor,
                      ),
                      Text(widget.product!.cantidadComprador.toString(),
                          style: Theme.of(context).textTheme.subtitle1),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            widget.product!.cantidadComprador =
                                this.decrementQuantity();
                          });
                        },
                        iconSize: 30,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        icon: Icon(Icons.remove_circle_outline),
                        color: Theme.of(context).hintColor,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  incrementQuantity() {
    if (widget.product!.cantidadComprador! <= 99) {
      widget.product!.cantidadComprador =
          widget.product!.cantidadComprador! + 1;
      return widget.product!.cantidadComprador;
    } else {
      return widget.product!.cantidadComprador;
    }
  }

  decrementQuantity() {
    if (widget.product!.cantidadComprador! > 1) {
      widget.product!.cantidadComprador =
          widget.product!.cantidadComprador! - 1;
      setState(() {
        var aux = _carrito.getTotalCheckOut() - widget.product!.preciounitario!;
        _carrito.setTotalCheckOut(aux);
      });

      return widget.product!.cantidadComprador;
    } else {
      widget.product!.cantidadComprador = 0;
      setState(() {
        _carrito.deleteElementCarrito(widget.product!);
        _carrito.setTotalCheckOut(
            _carrito.getTotalCheckOut() - widget.product!.preciounitario!);
        Navigator.pop(context);
        Navigator.of(context).pushNamed('/Cart');
        AlertUtil.info(context, 'Producto Eliminado del carrito');
      });
      return 0;
    }
  }
}

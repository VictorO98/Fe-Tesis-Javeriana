import 'package:Fe_mobile/src/core/util/currency_util.dart';
import 'package:Fe_mobile/src/dominio/models/producto_servicio_model.dart';
import 'package:Fe_mobile/src/models/route_argument.dart';
import 'package:flutter/material.dart';

class TruequetemWidget extends StatefulWidget {
  String? heroTag;
  ProductoServicioModel? productoOferta;
  ProductoServicioModel? product;
  int quantity;

  TruequetemWidget({
    Key? key,
    this.product,
    this.heroTag,
    this.quantity = 0,
    this.productoOferta,
  }) : super(key: key);

  @override
  _TruequetemWidgetState createState() => _TruequetemWidgetState();
}

class _TruequetemWidgetState extends State<TruequetemWidget> {
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
            widget.product!.cantidadtotal != 0
                ? Flexible(
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
                                style: Theme.of(context).textTheme.subhead,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text('Disponible: ' +
                                  widget.product!.cantidadtotal.toString()),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "${CurrencyUtil.convertFormatMoney('COP', widget.product!.preciounitario!)}",
                                style: Theme.of(context).textTheme.display1,
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
                                  widget.quantity =
                                      this.incrementQuantity(widget.quantity);
                                });
                              },
                              iconSize: 30,
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              icon: Icon(Icons.add_circle_outline),
                              color: Theme.of(context).hintColor,
                            ),
                            Text(widget.quantity.toString(),
                                style: Theme.of(context).textTheme.subhead),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  widget.quantity =
                                      this.decrementQuantity(widget.quantity);
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
                : Text(
                    'No tienes disponibilidad del producto',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
          ],
        ),
      ),
    );
  }

  incrementQuantity(int quantity) {
    if (quantity <= 99) {
      return ++quantity;
    } else {
      return quantity;
    }
  }

  decrementQuantity(int quantity) {
    if (quantity > 0) {
      return --quantity;
    } else {
      return quantity;
    }
  }

  int getQuantity() {
    return widget.quantity;
  }
}
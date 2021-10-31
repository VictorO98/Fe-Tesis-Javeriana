import 'package:Fe_mobile/config/ui_icons.dart';
import 'package:Fe_mobile/src/core/util/currency_util.dart';
import 'package:Fe_mobile/src/dominio/models/producto_servicio_model.dart';
import 'package:Fe_mobile/src/models/product.dart';
import 'package:Fe_mobile/src/models/route_argument.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FavoriteListItemWidget extends StatefulWidget {
  String? heroTag;
  ProductoServicioModel? product;
  VoidCallback? onDismissed;

  FavoriteListItemWidget(
      {Key? key, this.heroTag, this.product, this.onDismissed})
      : super(key: key);

  @override
  _FavoriteListItemWidgetState createState() => _FavoriteListItemWidgetState();
}

class _FavoriteListItemWidgetState extends State<FavoriteListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(this.widget.product.hashCode.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
      ),
      onDismissed: (direction) {
        // Remove the item from the data source.
        setState(() {
          widget.onDismissed!();
        });

        // Then show a snackbar.
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
                "${widget.product!.nombre} han sido removidas de tu lista favorita")));
      },
      child: InkWell(
        splashColor: Theme.of(context).accentColor,
        focusColor: Theme.of(context).accentColor,
        highlightColor: Theme.of(context).primaryColor,
        onTap: () {
          Navigator.of(context).pushNamed('/Product',
              arguments: new RouteArgument(
                  argumentsList: [this.widget.product, this.widget.heroTag],
                  id: this.widget.product!.id));
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
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
                          Row(
                            children: <Widget>[
                              // The title of the product
                              Text(
                                // TODO: AComodar esta vaina de las ventas
                                // '${widget.product!.v} Ventas',
                                '95 ventas',
                                style: Theme.of(context).textTheme.bodyText2,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                              ),
                              SizedBox(width: 10),
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 18,
                              ),
                              Text(
                                (widget.product!.calificacionpromedio! * 10)
                                    .toString(),
                                style: Theme.of(context).textTheme.bodyText1,
                              )
                            ],
                            crossAxisAlignment: CrossAxisAlignment.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    widget.product!.descuento! > 0.0
                        ? Text(
                            "${CurrencyUtil.convertFormatMoney('COP', widget.product!.preciounitario! - ((widget.product!.descuento! / 100) * widget.product!.preciounitario!).toInt())}",
                            style: Theme.of(context).textTheme.headline4)
                        : Text(
                            "${CurrencyUtil.convertFormatMoney('COP', widget.product!.preciounitario!)}",
                            style: Theme.of(context).textTheme.headline4),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

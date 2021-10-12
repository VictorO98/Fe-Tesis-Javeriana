import 'package:Fe_mobile/config/ui_icons.dart';
import 'package:Fe_mobile/src/core/util/currency_util.dart';
import 'package:Fe_mobile/src/core/util/publicaciones_util.dart';
import 'package:Fe_mobile/src/dominio/models/producto_servicio_model.dart';
import 'package:Fe_mobile/src/models/order.dart';
import 'package:Fe_mobile/src/models/route_argument.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ProductoUsuarioListItemWidget extends StatefulWidget {
  String? heroTag;
  ProductoServicioModel? product;
  VoidCallback? onDismissed;

  ProductoUsuarioListItemWidget(
      {Key? key, this.heroTag, this.product, this.onDismissed})
      : super(key: key);

  @override
  _ProductoUsuarioListItemWidgetState createState() =>
      _ProductoUsuarioListItemWidgetState();
}

class _ProductoUsuarioListItemWidgetState
    extends State<ProductoUsuarioListItemWidget> {
  @override
  Widget build(BuildContext context) {
    var calificacionProducto = widget.product!.calificacionpromedio! * 10;

    return Dismissible(
      key: Key(this.widget.product.hashCode.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Icon(
              UiIcons.trash,
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
                "The ${widget.product!.nombre} order is removed from wish list")));
      },
      child: InkWell(
        splashColor: Theme.of(context).accentColor,
        focusColor: Theme.of(context).accentColor,
        highlightColor: Theme.of(context).primaryColor,
        // TODO : ARREGLAR EL DETALLE DEL PRODUCTO PARA MODIFICARLO
        onTap: () {
          // Navigator.of(context).pushNamed('/Product',
          //     arguments: RouteArgument(
          //         id: widget.product!.id,
          //         argumentsList: [widget.product, widget.heroTag]));
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
                          SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.attach_file,
                                    color: Theme.of(context).focusColor,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    widget.product!.nombreCategoria!,
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.money,
                                    color: Theme.of(context).focusColor,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '95 ventas', // TODO  cambiar por el número del modelo
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.format_list_numbered_rtl_outlined,
                                    color: Theme.of(context).focusColor,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Unidades: ' +
                                        widget.product!.cantidadtotal
                                            .toString(), // TODO  cambiar por el número del modelo
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                  ),
                                ],
                              ),
                            ],
//                            crossAxisAlignment: CrossAxisAlignment.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                            "${CurrencyUtil.convertFormatMoney('COP', widget.product!.preciounitario!.round())}",
                            style: Theme.of(context).textTheme.headline4),
                        SizedBox(height: 6),
                        ActionChip(
                          avatar: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                                '/EditarPublicacion',
                                arguments: new RouteArgument(
                                    argumentsList: [widget.product]));
                          },
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          backgroundColor: Colors.transparent,
                          shape: StadiumBorder(
                              side: BorderSide(
                                  color: Theme.of(context).focusColor)),
                          label: Text(
                            'Editar',
                            style:
                                TextStyle(color: Theme.of(context).focusColor),
                          ),
                        )
                      ],
                    ),
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

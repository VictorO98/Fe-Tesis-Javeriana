import 'package:Fe_mobile/config/ui_icons.dart';
import 'package:Fe_mobile/src/core/util/currency_util.dart';
import 'package:Fe_mobile/src/core/util/preferencias_util.dart';
import 'package:Fe_mobile/src/dominio/models/producto_servicio_model.dart';
import 'package:Fe_mobile/src/models/product.dart';
import 'package:Fe_mobile/src/models/product_color.dart';
import 'package:Fe_mobile/src/models/product_size.dart';
import 'package:Fe_mobile/src/models/route_argument.dart';
import 'package:Fe_mobile/src/widgets/FlashSalesCarouselWidget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ProductHomeTabWidget extends StatefulWidget {
  ProductoServicioModel? product;
  ProductsList _productsList = new ProductsList();

  ProductHomeTabWidget({this.product});

  @override
  ProductHomeTabWidgetState createState() => ProductHomeTabWidgetState();
}

class ProductHomeTabWidgetState extends State<ProductHomeTabWidget> {
  final _prefs = new PreferenciasUtil();

  String? idRoleUsuario;

  @override
  void initState() {
    super.initState();
    _initialConfiguration();
  }

  _initialConfiguration() async {
    var id = await _prefs.getPrefStr("roles");
    setState(() {
      idRoleUsuario = id!;
    });
  }

  @override
  Widget build(BuildContext context) {
    var descuento = widget.product!.preciounitario! -
        (widget.product!.preciounitario! * (widget.product!.descuento! / 100));
    var calificacionProducto = widget.product!.calificacionpromedio! * 10;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  widget.product!.nombre!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              Chip(
                padding: EdgeInsets.all(0),
                label: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(calificacionProducto.toString(),
                        style: Theme.of(context).textTheme.bodyText1!.merge(
                            TextStyle(color: Theme.of(context).primaryColor))),
                    Icon(
                      Icons.star_border,
                      color: Theme.of(context).primaryColor,
                      size: 16,
                    ),
                  ],
                ),
                backgroundColor: Theme.of(context).accentColor.withOpacity(0.9),
                shape: StadiumBorder(),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              widget.product!.descuento != 0.0 // Widget que tiene descuento
                  ? Text(
                      "${CurrencyUtil.convertFormatMoney('COP', descuento.round())}",
                      style: Theme.of(context).textTheme.headline2)
                  : SizedBox(),
              SizedBox(width: 10),
              widget.product!.descuento != 0.0
                  ? Text(
                      // widget.product!.getPrice(myPrice: widget.product!.price + 10.0),
                      "${CurrencyUtil.convertFormatMoney('COP', widget.product!.preciounitario!.round())}",
                      style: Theme.of(context).textTheme.headline5!.merge(
                          TextStyle(
                              color: Theme.of(context).focusColor,
                              decoration: TextDecoration.lineThrough)),
                    )
                  : Text(
                      "${CurrencyUtil.convertFormatMoney('COP', widget.product!.preciounitario!.round())}",
                      style: Theme.of(context).textTheme.headline2),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  //'${widget.product!.descuento.toString()} Ventas',
                  '100 Vendidos',
                  textAlign: TextAlign.right,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        idRoleUsuario == "Emprendedor"
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/Trueque',
                        arguments: new RouteArgument(
                            argumentsList: [1, widget.product!]));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Realizar intercambio',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            : SizedBox(),
        // Container(
        //   width: double.infinity,
        //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        //   decoration: BoxDecoration(
        //     color: Theme.of(context).primaryColor.withOpacity(0.9),
        //     boxShadow: [
        //       BoxShadow(
        //           color: Theme.of(context).focusColor.withOpacity(0.15),
        //           blurRadius: 5,
        //           offset: Offset(0, 2)),
        //     ],
        //   ),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: <Widget>[
        //       // TODO Futura implementacion para colores de ropa
        //       // Row(
        //       //   children: <Widget>[
        //       //     Expanded(
        //       //       child: Text(
        //       //         'Select Color',
        //       //         style: Theme.of(context).textTheme.body2,
        //       //       ),
        //       //     ),
        //       //     MaterialButton(
        //       //       onPressed: () {},
        //       //       padding: EdgeInsets.all(0),
        //       //       minWidth: 0,
        //       //       child: Text(
        //       //         'Clear All',
        //       //         style: Theme.of(context).textTheme.body1,
        //       //       ),
        //       //     )
        //       //   ],
        //       // ),
        //       // SizedBox(height: 10),
        //       // SelectColorWidget()
        //     ],
        //   ),
        // ),
        // Container(
        //   width: double.infinity,
        //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        //   margin: EdgeInsets.symmetric(vertical: 20),
        //   decoration: BoxDecoration(
        //     color: Theme.of(context).primaryColor.withOpacity(0.9),
        //     boxShadow: [
        //       BoxShadow(
        //           color: Theme.of(context).focusColor.withOpacity(0.15),
        //           blurRadius: 5,
        //           offset: Offset(0, 2)),
        //     ],
        //   ),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: <Widget>[
        //       // Row( // TODO Futura implementación para camisetas y ropa Tallas de camiseta
        //       //   children: <Widget>[
        //       //     Expanded(
        //       //       child: Text(
        //       //         'Select Size',
        //       //         style: Theme.of(context).textTheme.body2,
        //       //       ),
        //       //     ),
        //       //     MaterialButton(
        //       //       onPressed: () {},
        //       //       padding: EdgeInsets.all(0),
        //       //       minWidth: 0,
        //       //       child: Text(
        //       //         'Clear All',
        //       //         style: Theme.of(context).textTheme.body1,
        //       //       ),
        //       //     )
        //       //   ],
        //       // ),
        //       // SizedBox(height: 10),
        //       // SelectSizeWidget()
        //     ],
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            leading: Icon(
              Icons.more_outlined,
              color: Theme.of(context).hintColor,
            ),
            title: Text(
              'Productos Relacionados',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        ),
        // FlashSalesCarouselWidget(
        //     heroTag: 'product_related_products',
        //     productsList: widget._productsList.flashSalesList),
      ],
    );
  }
}

class SelectColorWidget extends StatefulWidget {
  SelectColorWidget({
    Key? key,
  }) : super(key: key);

  @override
  _SelectColorWidgetState createState() => _SelectColorWidgetState();
}

class _SelectColorWidgetState extends State<SelectColorWidget> {
  ProductColorsList _productColorsList = new ProductColorsList();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(_productColorsList.list!.length, (index) {
        var _color = _productColorsList.list!.elementAt(index);
        return buildColor(_color);
      }),
    );
  }

  SizedBox buildColor(ProductColor color) {
    return SizedBox(
      width: 38,
      height: 38,
      child: FilterChip(
        label: Text(''),
        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
        backgroundColor: color.color,
        selectedColor: color.color,
        selected: color.selected!,
        shape: StadiumBorder(),
        avatar: Text(''),
        onSelected: (bool value) {
          setState(() {
            color.selected = value;
          });
        },
      ),
    );
  }
}

class SelectSizeWidget extends StatefulWidget {
  SelectSizeWidget({
    Key? key,
  }) : super(key: key);

  @override
  _SelectSizeWidgetState createState() => _SelectSizeWidgetState();
}

class _SelectSizeWidgetState extends State<SelectSizeWidget> {
  ProductSizesList _productSizesList = new ProductSizesList();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(_productSizesList.list!.length, (index) {
        var _size = _productSizesList.list!.elementAt(index);
        return buildSize(_size);
      }),
    );
  }

  SizedBox buildSize(ProductSize size) {
    return SizedBox(
      height: 38,
      child: RawChip(
        label: Text(size.code),
        labelStyle: TextStyle(color: Theme.of(context).hintColor),
        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
        backgroundColor: Theme.of(context).focusColor.withOpacity(0.05),
        selectedColor: Theme.of(context).focusColor.withOpacity(0.2),
        selected: size.selected!,
        shape: StadiumBorder(
            side: BorderSide(
                color: Theme.of(context).focusColor.withOpacity(0.05))),
        onSelected: (bool value) {
          setState(() {
            size.selected = value;
          });
        },
      ),
    );
  }
}

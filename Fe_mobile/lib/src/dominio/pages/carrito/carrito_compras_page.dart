import 'package:Fe_mobile/src/core/util/alert_util.dart';
import 'package:Fe_mobile/src/core/util/comisiones_util.dart';
import 'package:Fe_mobile/src/core/util/currency_util.dart';
import 'package:Fe_mobile/src/dominio/models/carrito_compras_model.dart';
import 'package:Fe_mobile/src/dominio/models/producto_servicio_model.dart';
import 'package:Fe_mobile/src/dominio/widgets/vacio_carrito_widget.dart';
import 'package:Fe_mobile/src/widgets/CartItemWidget.dart';
import 'package:flutter/material.dart';

class CartWidget extends StatefulWidget {
  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  List<ProductoServicioModel?> _productsList = [];
  CarritoComprasModel _carrito = new CarritoComprasModel();

  int _totalCancelar = 0;
  int _comision = 0;
  int _checkout = 0;

  @override
  void initState() {
    super.initState();
    _initialConfiguration();
  }

  void _initialConfiguration() {
    var lista = _carrito.returnCarrito();

    setState(() {
      _productsList = lista;
    });

    var total = 0;
    for (int i = 0; i < _productsList.length; i++) {
      if (_productsList[i]!.descuento! > 0.0) {
        total += ((_productsList[i]!.preciounitario! -
                    ((_productsList[i]!.descuento! / 100) *
                        _productsList[i]!.preciounitario!)) *
                _productsList[i]!.cantidadComprador!)
            .toInt();
      } else {
        total += _productsList[i]!.preciounitario! *
            _productsList[i]!.cantidadComprador!;
      }
    }

    var comision = total * ComisionesUtil.COMISION_BUYA;
    setState(() {
      _totalCancelar = total;
      _comision = comision.toInt();
      _checkout = _totalCancelar + _comision + ComisionesUtil.IMPUESTO_EPAYCO;
      _carrito.setTotalCheckOut(_checkout);
    });
    // setState(() {
    //   _cargandoUsuario = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Atrás',
          style: Theme.of(context).textTheme.headline4,
        ),
        actions: <Widget>[
          Container(
              width: 30,
              height: 30,
              margin: EdgeInsets.only(top: 12.5, bottom: 12.5, right: 20),
              child: InkWell(
                borderRadius: BorderRadius.circular(300),
                onTap: () {
                  Navigator.of(context).pushNamed('/Tabs', arguments: 1);
                },
                child: CircleAvatar(
                  backgroundImage: AssetImage('img/user3.jpg'),
                ),
              )),
        ],
      ),
      body: _checkout > ComisionesUtil.IMPUESTO_EPAYCO
          ? Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 150),
                  padding: EdgeInsets.only(bottom: 15),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 10),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            leading: Icon(
                              Icons.add_shopping_cart_outlined,
                              color: Theme.of(context).hintColor,
                            ),
                            title: Text(
                              'Carrito de compras',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            subtitle: Text(
                              'Verifique su cantidad y dirijase al checkout',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        ),
                        ListView.separated(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: _productsList.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 15);
                          },
                          itemBuilder: (context, index) {
                            return carritoItemProductoWidget(
                                _productsList.elementAt(index)!, 'cart');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: 170,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.15),
                              offset: Offset(0, -2),
                              blurRadius: 5.0)
                        ]),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  'Subtotal',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              Text(
                                  "${CurrencyUtil.convertFormatMoney('COP', _totalCancelar)}",
                                  style: Theme.of(context).textTheme.subtitle1),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  'Comisión (2%)',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              Text(
                                  "${CurrencyUtil.convertFormatMoney('COP', _comision)}",
                                  style: Theme.of(context).textTheme.subtitle1),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  'Impuestos',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              Text(
                                  "${CurrencyUtil.convertFormatMoney('COP', ComisionesUtil.IMPUESTO_EPAYCO)}",
                                  style: Theme.of(context).textTheme.subtitle1),
                            ],
                          ),
                          SizedBox(height: 10),
                          Stack(
                            fit: StackFit.loose,
                            alignment: AlignmentDirectional.centerEnd,
                            children: <Widget>[
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 40,
                                child: FlatButton(
                                  onPressed: () {
                                    if (_checkout >=
                                        ComisionesUtil.MINIMO_COMPRA) {
                                      _carrito.setTotalCheckOut(_checkout);
                                      Navigator.of(context)
                                          .pushNamed('/Checkout');
                                    } else {
                                      AlertUtil.error(
                                          context,
                                          "El monto mínimo de compra son " +
                                              "${CurrencyUtil.convertFormatMoney('COP', ComisionesUtil.MINIMO_COMPRA)}");
                                    }
                                  },
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  color: Theme.of(context).accentColor,
                                  shape: StadiumBorder(),
                                  child: Text(
                                    'Checkout',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  "${CurrencyUtil.convertFormatMoney('COP', _carrito.getTotalCheckOut())}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .merge(TextStyle(
                                          color:
                                              Theme.of(context).primaryColor)),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : VacioCarritoWidget(),
    );
  }

  Widget carritoItemProductoWidget(
      ProductoServicioModel product, String heroTag) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        // Navigator.of(context).pushNamed('/Product',
        //     arguments: RouteArgument(
        //         id: widget.product!.id,
        //         argumentsList: [widget.product, widget.heroTag]));
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
              tag: heroTag + product.id.toString(),
              child: Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  image: DecorationImage(
                    image: NetworkImage(
                        product.urlimagenproductoservicio.toString()),
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
                          product.nombre!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Text(
                          product.descuento == 0.0
                              ? "${CurrencyUtil.convertFormatMoney('COP', product.preciounitario!)}"
                              : "${CurrencyUtil.convertFormatMoney('COP', product.preciounitario! - ((product.descuento! / 100) * product.preciounitario!).toInt())}",
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
                            product.cantidadComprador =
                                this.incrementQuantity(product);
                          });
                        },
                        iconSize: 30,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        icon: Icon(Icons.add_circle_outline),
                        color: Theme.of(context).hintColor,
                      ),
                      Text(product.cantidadComprador.toString(),
                          style: Theme.of(context).textTheme.subtitle1),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            product.cantidadComprador =
                                this.decrementQuantity(product);
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

  incrementQuantity(ProductoServicioModel product) {
    if (product.cantidadComprador! <= 99) {
      product.cantidadComprador = product.cantidadComprador! + 1;
      setState(() {
        _initialConfiguration();
      });
      return product.cantidadComprador;
    } else {
      setState(() {
        _initialConfiguration();
      });
      return product.cantidadComprador;
    }
  }

  decrementQuantity(ProductoServicioModel product) {
    if (product.cantidadComprador! > 1) {
      product.cantidadComprador = product.cantidadComprador! - 1;
      setState(() {
        _initialConfiguration();
      });

      return product.cantidadComprador;
    } else {
      product.cantidadComprador = 0;
      setState(() {
        _carrito.deleteElementCarrito(product);
        _initialConfiguration();
        Navigator.pop(context);
        Navigator.of(context).pushNamed('/Cart');
        AlertUtil.info(context, 'Producto Eliminado del carrito');
      });
      return 0;
    }
  }
}

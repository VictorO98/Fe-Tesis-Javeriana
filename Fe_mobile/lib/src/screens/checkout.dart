import 'dart:ui';

import 'package:Fe_mobile/src/core/models/info_usuario_model.dart';
import 'package:Fe_mobile/src/core/models/respuesta_datos_model.dart';
import 'package:Fe_mobile/src/core/pages/usuario/bloc/info_perfil/info_usuario_bloc.dart';
import 'package:Fe_mobile/src/core/util/alert_util.dart';
import 'package:Fe_mobile/src/core/util/currency_util.dart';
import 'package:Fe_mobile/src/core/util/estilo_util.dart';
import 'package:Fe_mobile/src/core/util/helpers_util.dart';
import 'package:Fe_mobile/src/core/util/preferencias_util.dart';
import 'package:Fe_mobile/src/dominio/models/carrito_compras_model.dart';
import 'package:Fe_mobile/src/dominio/models/guardar_pedido_model.dart';
import 'package:Fe_mobile/src/dominio/models/guardar_producto_pedido_model.dart';
import 'package:Fe_mobile/src/dominio/models/pago_tarjeta_credito_model.dart';
import 'package:Fe_mobile/src/dominio/providers/factura_provider.dart';
import 'package:Fe_mobile/src/dominio/providers/pedidos_provider.dart';
import 'package:Fe_mobile/src/widgets/ShoppingCartButtonWidget.dart';
import 'package:flutter/material.dart';

class CheckoutWidget extends StatefulWidget {
  @override
  _CheckoutWidgetState createState() => _CheckoutWidgetState();
}

class _CheckoutWidgetState extends State<CheckoutWidget> {
  CarritoComprasModel _carrito = new CarritoComprasModel();
  PagoTarjetaCreditoModel _pago = new PagoTarjetaCreditoModel();
  GuardarPedidoModel _pedido = new GuardarPedidoModel();

  PedidoProvider _pedidoProvider = new PedidoProvider();
  FacturaProvider _facturaProvider = new FacturaProvider();

  InfoUsuarioBloc? _infoUsuarioBloc;

  final _formTC = GlobalKey<FormState>();
  final _prefs = new PreferenciasUtil();

  List<String> meses = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12"
  ];

  int? nroCuotas;

  bool _cargandoUsuario = false;
  bool _pagando = false;

  @override
  void initState() {
    super.initState();
    _pago.numeroTc = "";
    _pago.anioTc = 25;
    _pago.mesTc = 01;
    _pago.cvcTc = 001;
    //_cargarInfoUsuario();
  }

  void _cargarInfoUsuario() async {
    setState(() {
      _cargandoUsuario = true;
    });

    if (_infoUsuarioBloc!.state.infoUsuarioModel != null) {
      _infoUsuarioBloc!.add(OnSetearInfoUsuario(new InfoUsuarioModel(
          id: await _prefs.getPrefStr("id"),
          documento: await _prefs.getPrefStr("documento"),
          tipoDocumento: await _prefs.getPrefStr("tipoDocumento"),
          email: await _prefs.getPrefStr("email"),
          nombres: await _prefs.getPrefStr("nombres"),
          apellidos: await _prefs.getPrefStr("apellidos"),
          nombreCompleto: await _prefs.getPrefStr("nombreCompleto"),
          numeroTelefono: await _prefs.getPrefStr("telefono"),
          rol: await _prefs.getPrefStr("roles"),
          direccion: await _prefs.getPrefStr("direccion"),
          estado: await _prefs.getPrefStr("estado"),
          poblacion: await _prefs.getPrefStr("poblacion"))));

      setState(() {
        _cargandoUsuario = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.keyboard_return_outlined,
              color: Theme.of(context).hintColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Pago',
          style: Theme.of(context).textTheme.headline4,
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor),
          Container(
              width: 30,
              height: 30,
              margin: EdgeInsets.only(top: 12.5, bottom: 12.5, right: 20),
              child: InkWell(
                  borderRadius: BorderRadius.circular(300),
                  onTap: () {
                    Navigator.of(context).pushNamed('/Tabs', arguments: 1);
                  },
                  child: Helpers.IS_FOTO_PERFIL
                      ? CircleAvatar(
                          // backgroundImage: AssetImage(_user.avatar!),
                          backgroundImage:
                              NetworkImage((Helpers.FOTO_USUARIO).toString()))
                      : CircleAvatar(
                          backgroundImage: AssetImage('img/user3.jpg'),
                        ))),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                leading: Icon(
                  Icons.credit_card,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  'Modo de pago',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline4,
                ),
                subtitle: Text(
                  'Selecciona tú método de pago preferido',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
            ),
            _widgetTarjetaCredito(),
            SizedBox(height: 20),
            Text("Datos de la tarjeta"),
            SizedBox(height: 5),
            Form(
              key: _formTC,
              child: Padding(
                padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: EstiloUtil.crearInputDecorationFormCustom(
                        "Número de la tarjeta \*",
                      ),
                      onSaved: (String? value) {
                        setState(() {
                          _pago.numeroTc = value;
                        });
                      },
                      onChanged: (String? value) {
                        setState(() {
                          _pago.numeroTc = value;
                        });
                      },
                      validator: (String? value) => (value!.isEmpty) ||
                              (value.trim().isEmpty) ||
                              (value == "")
                          ? 'Digite el número'
                          : null,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(children: <Widget>[
                      SizedBox(
                        width: width / 6,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: EstiloUtil.crearInputDecorationFormCustom(
                            "Mes \*",
                            hintText: "07",
                          ),
                          onSaved: (String? value) {
                            setState(() {
                              _pago.mesTc = int.parse(value!);
                            });
                          },
                          onChanged: (String? value) {
                            setState(() {
                              _pago.mesTc = int.parse(value!);
                            });
                          },
                          validator: (String? value) => (value!.isEmpty) ||
                                  (value.trim().isEmpty) ||
                                  (int.parse(value) > 12) ||
                                  (int.parse(value) < 1)
                              ? 'Error'
                              : null,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: width / 6,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: EstiloUtil.crearInputDecorationFormCustom(
                              "Año \*",
                              hintText: "21"),
                          onSaved: (String? value) {
                            setState(() {
                              _pago.anioTc = int.parse(value!);
                            });
                          },
                          onChanged: (String? value) {
                            setState(() {
                              _pago.anioTc = int.parse(value!);
                            });
                          },
                          validator: (String? value) =>
                              (value!.isEmpty) || (value.trim().isEmpty)
                                  ? 'Error'
                                  : null,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: width / 4,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: EstiloUtil.crearInputDecorationFormCustom(
                            "Cuotas \*",
                          ),
                          onSaved: (String? value) {
                            setState(() {
                              _pago.cuotas = int.parse(value!);
                            });
                          },
                          onChanged: (String? value) {
                            setState(() {
                              _pago.cuotas = int.parse(value!);
                            });
                          },
                          validator: (String? value) => (value!.isEmpty) ||
                                  (value.trim().isEmpty) ||
                                  (int.parse(value) > 36) ||
                                  (int.parse(value) < 1)
                              ? 'Error'
                              : null,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: width / 5,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: EstiloUtil.crearInputDecorationFormCustom(
                            "CCV \*",
                          ),
                          onSaved: (String? value) {
                            setState(() {
                              _pago.cvcTc = int.parse(value!);
                            });
                          },
                          onChanged: (String? value) {
                            setState(() {
                              _pago.cvcTc = int.parse(value!);
                            });
                          },
                          validator: (String? value) => (value!.isEmpty) ||
                                  (value.trim().isEmpty) ||
                                  (int.parse(value) > 2099)
                              ? 'Error'
                              : null,
                        ),
                      )
                    ]),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Positioned(
              bottom: 0,
              child: Container(
                height: 200,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).focusColor.withOpacity(0.15),
                          offset: Offset(0, -2),
                          blurRadius: 5.0)
                    ]),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text('O cancela con'),
                      SizedBox(height: 20),
                      Stack(
                        fit: StackFit.loose,
                        alignment: AlignmentDirectional.centerEnd,
                        children: <Widget>[
                          SizedBox(
                            width: 320,
                            child: FlatButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/Bancos');
                              },
                              padding: EdgeInsets.symmetric(vertical: 4),
                              color: Theme.of(context).accentColor,
                              shape: StadiumBorder(),
                              child: Container(
                                width: double.infinity,
                                padding:
                                    EdgeInsets.symmetric(horizontal: width / 3),
                                child: Text(
                                  'PSE',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: height / 50),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Icon(Icons.arrow_forward_ios_rounded,
                                  color: Colors.white))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      !_pagando
                          ? Stack(
                              fit: StackFit.loose,
                              alignment: AlignmentDirectional.centerEnd,
                              children: <Widget>[
                                SizedBox(
                                  width: 320,
                                  child: FlatButton(
                                    onPressed: () {
                                      AlertUtil.confirm(
                                          context,
                                          '¿Desea confirmar compra?',
                                          () => _submitTC(),
                                          confirmBtnText: 'Confirmar');
                                    },
                                    padding: EdgeInsets.symmetric(vertical: 14),
                                    color: Theme.of(context).accentColor,
                                    shape: StadiumBorder(),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Text(
                                        'Confirmar Pago',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Text(
                                    "${CurrencyUtil.convertFormatMoney('COP', _carrito.getTotalCheckOut())}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4!
                                        .merge(TextStyle(
                                            color: Theme.of(context)
                                                .primaryColor)),
                                  ),
                                )
                              ],
                            )
                          : CircularProgressIndicator(),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitTC() async {
    if (_formTC.currentState!.validate()) {
      _formTC.currentState!.save();

      Navigator.pop(context);

      setState(() {
        _pagando = true;
      });

      // Se crea la cabecera del pedido
      var idUsuario = await _prefs.getPrefStr("id");

      _pedido.id = 0;
      _pedido.idusuario = int.parse(idUsuario!);
      _pedido.estado = 'PEN';

      _pedidoProvider.crearPedido(_pedido, context).then((value) {
        var idPedido = value;
        var _productosAComprar = _carrito.returnCarrito();
        var _cantidadProductos = _carrito.returSizeCarrito();

        // Guardar Productos por pedido
        for (int i = 0; i < _cantidadProductos; i++) {
          var _productoPorPedido = new GuardarProductoPedidoModel();

          _productoPorPedido.id = 0;
          _productoPorPedido.idproductoservico = _productosAComprar[i].id;
          _productoPorPedido.idpedido = idPedido;
          _productoPorPedido.cantidadespedida =
              _productosAComprar[i].cantidadComprador;

          if (_productosAComprar[i].descuento! > 0.0) {
            _productoPorPedido.preciototal =
                ((_productosAComprar[i].preciounitario! -
                            ((_productosAComprar[i].descuento! / 100) *
                                _productosAComprar[i].preciounitario!)) *
                        _productosAComprar[i].cantidadComprador!)
                    .toInt();
          } else {
            _productoPorPedido.preciototal =
                _productosAComprar[i].preciounitario! *
                    _productosAComprar[i].cantidadComprador!;
          }
          print(_productoPorPedido.preciototal);

          _pedidoProvider
              .guardarProductoPedidoPorId(_productoPorPedido, context)
              .then((value) {
            RespuestaDatosModel? respuesta = value;
            print(respuesta!.mensaje);
          }).whenComplete(() => null);
        }

        //Cobro con TC
        _pago.idDemografiaComprador = int.parse(idUsuario);
        _pago.idPedido = 2;
        _pagatTC();
      }).whenComplete(() => null);
    } else {
      Navigator.pop(context);
    }
  }

  void _pagatTC() async {
    _facturaProvider.pagoConTC(_pago, context).then((value) {
      var respuesta = value;
      if (respuesta[13] == 'r') {
        setState(() {
          _pagando = false;
        });
        final funcionNavegar = () async {
          Navigator.pop(context);
          Navigator.of(context).pushNamed('/Tabs', arguments: 1);
        };

        AlertUtil.success(context, 'Transacción realizada correctamente',
            respuesta: funcionNavegar);
      } else {
        setState(() {
          _pagando = false;
        });
        AlertUtil.error(context, respuesta);
      }
    }).whenComplete(() => _pagando = true);
  }

  Widget _widgetTarjetaCredito() {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: <Widget>[
        Container(
          width: 259,
          height: 165,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).hintColor.withOpacity(0.15),
                  blurRadius: 20,
                  offset: Offset(0, 5)),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 12),
          width: 275,
          height: 177,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).hintColor.withOpacity(0.15),
                  blurRadius: 20,
                  offset: Offset(0, 5)),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 25),
          width: 300,
          height: 195,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).hintColor.withOpacity(0.15),
                  blurRadius: 20,
                  offset: Offset(0, 5)),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 21),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  'img/visa.png',
                  height: 22,
                  width: 70,
                ),
                SizedBox(height: 20),
                Text(
                  'Número de la tarjeta',
                  style: Theme.of(context).textTheme.caption,
                ),
                SizedBox(height: 5),
                Text(
                  _pago.numeroTc.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .merge(TextStyle(letterSpacing: 1.4)),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Fecha vencimiento',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Text(
                      'CVV',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '0' +
                          _pago.mesTc.toString() +
                          '/' +
                          _pago.anioTc.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .merge(TextStyle(letterSpacing: 1.4)),
                    ),
                    _pago.cvcTc! < 10
                        ? Text(
                            '00' + _pago.cvcTc.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .merge(TextStyle(letterSpacing: 1.4)),
                          )
                        : _pago.cvcTc! < 100
                            ? Text(
                                '0' + _pago.cvcTc.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .merge(TextStyle(letterSpacing: 1.4)),
                              )
                            : Text(
                                _pago.cvcTc.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .merge(TextStyle(letterSpacing: 1.4)),
                              ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

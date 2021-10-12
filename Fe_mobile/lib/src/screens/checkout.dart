import 'dart:ui';

import 'package:Fe_mobile/src/core/util/currency_util.dart';
import 'package:Fe_mobile/src/core/util/estilo_util.dart';
import 'package:Fe_mobile/src/dominio/models/carrito_compras_model.dart';
import 'package:Fe_mobile/src/dominio/models/pago_tarjeta_credito_model.dart';
import 'package:Fe_mobile/src/models/route_argument.dart';
import 'package:Fe_mobile/src/widgets/ShoppingCartButtonWidget.dart';
import 'package:flutter/material.dart';

class CheckoutWidget extends StatefulWidget {
  @override
  _CheckoutWidgetState createState() => _CheckoutWidgetState();
}

class _CheckoutWidgetState extends State<CheckoutWidget> {
  CarritoComprasModel _carrito = new CarritoComprasModel();
  PagoTarjetaCreditoModel _pago = new PagoTarjetaCreditoModel();

  final _formTC = GlobalKey<FormState>();

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

  @override
  void initState() {
    super.initState();
    _pago.numeroTc = "";
    _pago.anioTc = 25;
    _pago.mesTc = 01;
    _pago.cvcTc = 001;
    //_initialConfiguration();
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
                child: CircleAvatar(
                  backgroundImage: AssetImage('img/user3.jpg'),
                ),
              )),
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
            // TODO TARJETA DE CREDITO WIDGET
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
                                // Navigator.of(context)
                                //     .pushNamed('/CheckoutDone');
                              },
                              padding: EdgeInsets.symmetric(vertical: 10),
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
                                      fontSize: height / 40),
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
                      Stack(
                        fit: StackFit.loose,
                        alignment: AlignmentDirectional.centerEnd,
                        children: <Widget>[
                          SizedBox(
                            width: 320,
                            child: FlatButton(
                              onPressed: () {
                                _submitTC();
                              },
                              padding: EdgeInsets.symmetric(vertical: 14),
                              color: Theme.of(context).accentColor,
                              shape: StadiumBorder(),
                              child: Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  'Confirmar Pago',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "${CurrencyUtil.convertFormatMoney('COP', _carrito.getTotalCheckOut())}",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .merge(TextStyle(
                                      color: Theme.of(context).primaryColor)),
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
        ),
      ),
    );
  }

  void _submitTC() {
    if (_formTC.currentState!.validate()) {
      _formTC.currentState!.save();
    }
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

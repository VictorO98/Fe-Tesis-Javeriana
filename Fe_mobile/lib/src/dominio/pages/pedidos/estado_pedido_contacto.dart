import 'package:Fe_mobile/src/core/util/helpers_util.dart';
import 'package:Fe_mobile/src/widgets/SearchBarWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EstadoPedidoContactoPage extends StatefulWidget {
  @override
  _EstadoPedidoContactoPageState createState() =>
      _EstadoPedidoContactoPageState();
}

class _EstadoPedidoContactoPageState extends State<EstadoPedidoContactoPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 7),
        child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SearchBarWidget(),
          ),
        ]));
  }
}

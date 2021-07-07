import 'dart:io';

import 'package:Fe_mobile/src/core/util/estilo_util.dart';
import 'package:flutter/material.dart';

class VerImagenWidget extends StatefulWidget {
  final String? pathImage;
  final int? indexImage;
  final Function(bool, int)? callback;

  VerImagenWidget({Key? key, this.pathImage, this.callback, this.indexImage})
      : super(key: key);

  @override
  _VerImagenWidgetState createState() => _VerImagenWidgetState();
}

class _VerImagenWidgetState extends State<VerImagenWidget> {
  String? pathImage;

  @override
  void initState() {
    pathImage = this.widget.pathImage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          // title: Text("DETALLE IMAGEN"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.white,
        ),
        body: Column(children: [
          // _crearAppBar(context),
          _verImagen(context, pathImage ?? ''),
          _crearBoton(context)
        ]));
  }

  _verImagen(BuildContext context, String pathImage) {
    return FadeInImage(
      image: FileImage(File(pathImage)),
      height: 500,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: AssetImage("img/loading.gif"),
    );
  }

  _crearBoton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(Icons.delete_forever_sharp, color: Colors.white),
        label: Text("ELIMINAR IMAGEN", style: TextStyle(color: Colors.white)),
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(EstiloUtil.COLOR_ERROR)),
        onPressed: () {
          widget.callback!(true, this.widget.indexImage ?? 0);
        },
      ),
    );
  }
}

import 'package:Fe_mobile/src/core/util/estilo_util.dart';
import 'package:flutter/material.dart';

class TerminosYCondicionesPage extends StatefulWidget {
  TerminosYCondicionesPage({Key key}) : super(key: key);

  @override
  _TerminosYCondicionesPageState createState() =>
      _TerminosYCondicionesPageState();
}

class _TerminosYCondicionesPageState extends State<TerminosYCondicionesPage> {
  bool _isLoading = false;
  String _terminosYCondiciones = "";
  //final GeneralProvider _generalProvider = new GeneralProvider();

  @override
  void initState() {
    super.initState();
    _getTerminosYCondiciones();
  }

  _getTerminosYCondiciones() {
    // setState(() {
    //   _isLoading = true;
    // });
    // _generalProvider.getTerminosYCondiciones().then((data) {
    //   setState(() {
    //     _terminosYCondiciones = data;
    //   });
    // }).whenComplete(() => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
      SafeArea(
        child: SizedBox(),
      ),
      _crearHead(),
      _crearLayout()
    ])));
  }

  _crearHead() {
    return Row(children: [
      IconButton(
          icon: Icon(Icons.arrow_back_ios, color: EstiloUtil.COLOR_PRIMARY),
          onPressed: () => Navigator.pop(context)),
      Expanded(
          child: Padding(
              padding: EdgeInsets.only(left: 0),
              child: Text("TÉRMINOS Y CONDICIONES",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))))
    ]);
  }

  _crearLayout() {
    return Container(
        padding: EdgeInsets.all(25),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Text(_terminosYCondiciones));
  }
}

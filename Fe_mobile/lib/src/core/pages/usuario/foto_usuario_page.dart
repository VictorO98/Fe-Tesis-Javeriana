import 'package:Fe_mobile/src/widgets/SearchBarWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FotoUsuarioPage extends StatefulWidget {
  @override
  _FotoUsuarioPageState createState() => _FotoUsuarioPageState();
}

class _FotoUsuarioPageState extends State<FotoUsuarioPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _onWillPop() async {
    return (await (showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('¿Se encuentra seguro?'),
            content: new Text(
                'Tiene cambios pendientes, ¿está seguro de que desea descartarlos?'),
            actions: <Widget>[
              new ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Si'),
              ),
            ],
          ),
        )) ??
        false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).accentColor,
        body: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              margin: EdgeInsets.symmetric(vertical: 85, horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).primaryColor,
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).hintColor.withOpacity(0.2),
                      offset: Offset(0, 10),
                      blurRadius: 20)
                ],
              ),
              child: WillPopScope(
                  onWillPop: _onWillPop,
                  child: Scaffold(
                      key: _scaffoldKey,
                      body: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onPanDown: (_) {
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          child: _crearContent(context)))),
            ),
          ],
        ));
  }

  Widget _crearContent(BuildContext context) {
    return SizedBox();
  }
}

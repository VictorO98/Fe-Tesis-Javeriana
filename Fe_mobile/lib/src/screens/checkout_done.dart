import 'package:Fe_mobile/config/app_config.dart' as config;
import 'package:Fe_mobile/config/ui_icons.dart';
import 'package:Fe_mobile/src/core/models/info_usuario_model.dart';
import 'package:Fe_mobile/src/core/pages/usuario/bloc/info_perfil/info_usuario_bloc.dart';
import 'package:Fe_mobile/src/core/util/preferencias_util.dart';
import 'package:Fe_mobile/src/widgets/ShoppingCartButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutDoneWidget extends StatefulWidget {
  @override
  _CheckoutDoneWidgetState createState() => _CheckoutDoneWidgetState();
}

class _CheckoutDoneWidgetState extends State<CheckoutDoneWidget> {
  final _prefs = new PreferenciasUtil();

  InfoUsuarioBloc? _infoUsuarioBloc;

  bool _cargandoUsuario = false;

  @override
  void initState() {
    super.initState();
    _infoUsuarioBloc = BlocProvider.of<InfoUsuarioBloc>(context);
    _cargarInfoUsuario();
  }

  void _cargarInfoUsuario() async {
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
        _cargandoUsuario = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.keyboard_return,
              color: Theme.of(context).hintColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Finalizado',
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
          child: _cargandoUsuario
              ? Container(
                  alignment: AlignmentDirectional.center,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  height: config.App(context).appHeight(60),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                    colors: [
                                      Theme.of(context).accentColor,
                                      Theme.of(context)
                                          .accentColor
                                          .withOpacity(0.2),
                                    ])),
                            child: Icon(
                              Icons.check,
                              color: Theme.of(context).primaryColor,
                              size: 70,
                            ),
                          ),
                          Positioned(
                            right: -30,
                            bottom: -50,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .scaffoldBackgroundColor
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(150),
                              ),
                            ),
                          ),
                          Positioned(
                            left: -20,
                            top: -50,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .scaffoldBackgroundColor
                                    .withOpacity(0.15),
                                borderRadius: BorderRadius.circular(150),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Su pedido fue creado con exito, en su correo estarán las instrucciones para realizar el pago en efectivo',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      SizedBox(height: 50),
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/Orders');
                        },
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                        color: Theme.of(context).focusColor.withOpacity(0.15),
                        shape: StadiumBorder(),
                        child: Text(
                          'Mis pedidos',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator())),
    );
  }
}

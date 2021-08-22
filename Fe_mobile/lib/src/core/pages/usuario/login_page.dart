import 'dart:async';

import 'package:Fe_mobile/src/core/models/info_usuario_model.dart';
import 'package:Fe_mobile/src/core/models/login_model.dart';
import 'package:Fe_mobile/src/core/models/respuesta_login_model.dart';
import 'package:Fe_mobile/src/core/providers/usuario_provider.dart';
import 'package:Fe_mobile/src/core/util/jwt_util.dart';
import 'package:Fe_mobile/src/core/util/preferencias_util.dart';
import 'package:Fe_mobile/src/core/pages/usuario/bloc/info_perfil/info_usuario_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _usuarioProvider = new UsuarioProvider();
  final _loginModel = new LoginModel();
  final _preferenciasUtil = new PreferenciasUtil();
  bool _showPassword = false;
  bool _isLoadingIniciarSesion = false;
  bool isValidandoToken = true;

  bool _isRecordarUsuario = false;

  @override
  void initState() {
    super.initState();
    _isLoadingIniciarSesion = false;
    _redirectRouteInicial();
    _recordarUsuario();
  }

  void _redirectRouteInicial() async {
    Timer(Duration(seconds: 2), () {
      _redirect();
    });
  }

  _recordarUsuario() async {
    _preferenciasUtil.getPrefStr("isRecordarUsuario").then((value) {
      if (value != null) {
        setState(() {
          _isRecordarUsuario = true;
        });
        _preferenciasUtil.getPrefStr("email").then((value) {
          _loginModel.email = value;
        });
        _preferenciasUtil.getPrefStr("pass").then((value) {
          _loginModel.password = value;
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).accentColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  margin: EdgeInsets.symmetric(vertical: 65, horizontal: 50),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).primaryColor.withOpacity(0.6),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                  margin: EdgeInsets.symmetric(vertical: 85, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).primaryColor,
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).hintColor.withOpacity(0.2),
                            offset: Offset(0, 10),
                            blurRadius: 20)
                      ]),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.all(25),
                        child: Image.asset(
                          'img/logo_buya.png',
                          width: 500,
                        ),
                      ),
                      SizedBox(height: 20),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                initialValue: _loginModel.email,
                                onSaved: (String? value) {
                                  setState(() {
                                    _loginModel.email = value;
                                  });
                                },
                                decoration: new InputDecoration(
                                  hintText: 'Correo electrónico',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .merge(
                                        TextStyle(
                                          color: Theme.of(context).accentColor,
                                        ),
                                      ),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .accentColor
                                              .withOpacity(0.2))),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Theme.of(context).accentColor)),
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                                validator: (String? value) =>
                                    (value == null || value.isEmpty)
                                        ? 'Por favor diligencie el campo'
                                        : null,
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                style: TextStyle(
                                    color: Theme.of(context).accentColor),
                                keyboardType: TextInputType.text,
                                obscureText: !_showPassword,
                                initialValue: _loginModel.password,
                                onSaved: (String? value) {
                                  setState(() {
                                    _loginModel.password = value;
                                  });
                                },
                                validator: (String? value) =>
                                    (value == null || value.isEmpty)
                                        ? 'Por favor diligencie el campo'
                                        : null,
                                decoration: new InputDecoration(
                                  hintText: 'Contraseña',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .merge(
                                        TextStyle(
                                            color:
                                                Theme.of(context).accentColor),
                                      ),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .accentColor
                                              .withOpacity(0.2))),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Theme.of(context).accentColor)),
                                  prefixIcon: Icon(
                                    Icons.lock_open_sharp,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _showPassword = !_showPassword;
                                      });
                                    },
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.4),
                                    icon: Icon(_showPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                  ),
                                ),
                              ),
                            ],
                          )),

                      SizedBox(height: 20),
                      _isLoadingIniciarSesion
                          ? Center(child: CircularProgressIndicator())
                          : FlatButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 70),
                              onPressed: () {
                                _iniciarSesion(context);
                              },
                              child: Text(
                                'Iniciar Sesión',
                                style: Theme.of(context).textTheme.title!.merge(
                                      TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                              ),
                              color: Theme.of(context).accentColor,
                              shape: StadiumBorder(),
                            ),
                      SizedBox(height: 8),
                      FlatButton(
                        onPressed: () {},
                        child: Text(
                          '¿ Olvidaste tu contraseña ?',
                          style: Theme.of(context).textTheme.body1,
                        ),
                      ),

                      // SizedBox(height: 50),    FUTURA IMPLEMENTACION
                      // Text(
                      //   'Or using social media',
                      //   style: Theme.of(context).textTheme.body1,
                      // ),
                      // SizedBox(height: 20),
                      // new SocialMediaWidget()
                    ],
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/Registro');
              },
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.headline6!.merge(
                        TextStyle(color: Theme.of(context).primaryColor),
                      ),
                  children: [
                    TextSpan(text: '¿ No tienes cuenta ?'),
                    TextSpan(
                        text: ' Registrate',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _redirect() {
    //TODO: falta recordar usuario
    print("Recordar usuario");
  }

  void _iniciarSesion(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoadingIniciarSesion = true;
      });
      _formKey.currentState!.save();

      _usuarioProvider.iniciarSesion(_loginModel, context).then((value) async {
        RespuestaLoginModel? respuesta = value;
        if (respuesta?.codigo == 10) {
          // TODO: Agregar lo de recordar usuario
          await _preferenciasUtil.setPrefStr("token", respuesta!.token!);
          Map<String, dynamic> claims =
              JWTUtil.decodificarToken(respuesta.token!);
          if (claims.isNotEmpty) {
            JWTUtil.addPreferenciasUsuario(claims).then((value) async {
              final infoUsuarioBloc = BlocProvider.of<InfoUsuarioBloc>(context);
              infoUsuarioBloc.add(OnSetearInfoUsuario(new InfoUsuarioModel(
                  id: await _preferenciasUtil.getPrefStr("id"),
                  documento: await _preferenciasUtil.getPrefStr("documento"),
                  tipoDocumento:
                      await _preferenciasUtil.getPrefStr("tipoDocumento"),
                  email: await _preferenciasUtil.getPrefStr("email"),
                  nombres: await _preferenciasUtil.getPrefStr("nombres"),
                  apellidos: await _preferenciasUtil.getPrefStr("apellidos"),
                  nombreCompleto:
                      await _preferenciasUtil.getPrefStr("nombreCompleto"),
                  numeroTelefono:
                      await _preferenciasUtil.getPrefStr("telefono"),
                  rol: await _preferenciasUtil.getPrefStr("roles"),
                  direccion: await _preferenciasUtil.getPrefStr("direccion"),
                  poblacion: await _preferenciasUtil.getPrefStr("poblacion"),
                  estado: await _preferenciasUtil.getPrefStr("estado"))));
              // 2 number refer the index of Home page
              Navigator.of(context).pushNamed('/Tabs', arguments: 2);
            });
          } else if (respuesta.codigo == 11) {
            // TODO: Impelemtar este pedazo de cogido en el login
            print("Entro aqui");
          }
        }
      }).whenComplete(() => setState(() => _isLoadingIniciarSesion = false));
    }
  }
}

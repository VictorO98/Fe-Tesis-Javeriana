import 'package:Fe_mobile/config/ui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;

  Widget build(BuildContext context) {
    return Scaffold(
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
                              new TextFormField(
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                decoration: new InputDecoration(
                                  hintText: 'Correo electrónico',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .body1
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
                                    UiIcons.envelope,
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                                validator: (String value) =>
                                    (value == null || value.isEmpty)
                                        ? 'Por favor diligencie el campo'
                                        : null,
                              ),
                              SizedBox(height: 20),
                              new TextField(
                                style: TextStyle(
                                    color: Theme.of(context).accentColor),
                                keyboardType: TextInputType.text,
                                obscureText: !_showPassword,
                                decoration: new InputDecoration(
                                  hintText: 'Contraseña',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .body1
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
                                    UiIcons.padlock_1,
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
                      FlatButton(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 70),
                        onPressed: () {
                          _iniciarSesion(context);
                        },
                        child: Text(
                          'Iniciar Sesión',
                          style: Theme.of(context).textTheme.title.merge(
                                TextStyle(
                                    color: Theme.of(context).primaryColor),
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
                  style: Theme.of(context).textTheme.title.merge(
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

  void _iniciarSesion(BuildContext context) {
    // 2 number refer the index of Home page
    Navigator.of(context).pushNamed('/Tabs', arguments: 2);
  }
}

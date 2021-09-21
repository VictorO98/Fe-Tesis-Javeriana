import 'package:Fe_mobile/config/ui_icons.dart';
import 'package:Fe_mobile/src/core/models/info_usuario_model.dart';
import 'package:Fe_mobile/src/core/pages/usuario/bloc/info_perfil/info_usuario_bloc.dart';
import 'package:Fe_mobile/src/core/util/preferencias_util.dart';
import 'package:Fe_mobile/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final _prefs = new PreferenciasUtil();
  User _user = new User.init().getCurrentUser();

  InfoUsuarioBloc? _infoUsuarioBloc;

  bool _cargandoUsuario = false;

  @override
  void initState() {
    _infoUsuarioBloc = BlocProvider.of<InfoUsuarioBloc>(context);
    _cargarInfoUsuario();
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
    return Drawer(
      child: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/Tabs', arguments: 1);
            },
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withOpacity(0.1),
//              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35)),
              ),
              accountName: Text(
                _infoUsuarioBloc!.state.infoUsuarioModel!.nombreCompleto!,
                style: Theme.of(context).textTheme.title,
              ),
              accountEmail: Text(
                _infoUsuarioBloc!.state.infoUsuarioModel!.email!,
                style: Theme.of(context).textTheme.caption,
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Theme.of(context).accentColor,
                backgroundImage: AssetImage(_user.avatar!),
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Tabs', arguments: 2);
            },
            leading: Icon(
              Icons.home,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Inicio",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Tabs', arguments: 0);
            },
            leading: Icon(
              Icons.notifications_active_outlined,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Notificaciones",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),

          // TODO: Queda pendiente sacar el numerito
          // trailing: Chip(
          //   padding: EdgeInsets.symmetric(horizontal: 5),
          //   backgroundColor: Colors.transparent,
          //   shape: StadiumBorder(
          //       side: BorderSide(color: Theme.of(context).focusColor)),
          //   label: Text(
          //     '8',
          //     style: TextStyle(color: Theme.of(context).focusColor),
          //   ),
          // ),

          // ListTile(
          //   onTap: () {
          //     Navigator.of(context).pushNamed('/Categories');
          //   },
          //   leading: Icon(
          //     Icons.autorenew_sharp,
          //     color: Theme.of(context).focusColor.withOpacity(1),
          //   ),
          //   title: Text(
          //     "Mis trueques",
          //     style: Theme.of(context).textTheme.subhead,
          //   ),
          // ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Tabs', arguments: 4);
            },
            leading: Icon(
              Icons.favorite_border_outlined,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Favoritos",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          _infoUsuarioBloc!.state.infoUsuarioModel!.rol == "Emprendedor"
              ? ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed('/Create');
                  },
                  leading: Icon(
                    Icons.add,
                    color: Theme.of(context).focusColor.withOpacity(1),
                  ),
                  title: Text(
                    "Crear Venta",
                    style: Theme.of(context).textTheme.subhead,
                  ),
                )
              : SizedBox(),
          // TODO : Pendiente mas adelante mejorar
          // ListTile(
          //   dense: true,
          //   title: Text(
          //     "Mis ventas",
          //     style: Theme.of(context).textTheme.body1,
          //   ),
          //   trailing: Icon(
          //     Icons.attach_money_outlined,
          //     color: Theme.of(context).focusColor.withOpacity(0.3),
          //   ),
          // ),

          // ListTile(
          //   onTap: () {
          //     Navigator.of(context).pushNamed('/Brands');
          //   },
          //   leading: Icon(
          //     Icons.folder_open_outlined,
          //     color: Theme.of(context).focusColor.withOpacity(1),
          //   ),
          //   title: Text(
          //     "Mis Productos",
          //     style: Theme.of(context).textTheme.subhead,
          //   ),
          // ),
          ListTile(
            dense: true,
            title: Text(
              "Preferencias del usuario",
              style: Theme.of(context).textTheme.body1,
            ),
            trailing: Icon(
              Icons.remove,
              color: Theme.of(context).focusColor.withOpacity(0.3),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Help');
            },
            leading: Icon(
              Icons.question_answer,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Preguntas frecuentes",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Tabs', arguments: 1);
            },
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Configuración",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Login');
            },
            leading: Icon(
              Icons.upload,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Cerrar Sesión",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          ListTile(
            dense: true,
            title: Text(
              "Version 0.0.1",
              style: Theme.of(context).textTheme.body1,
            ),
            trailing: Icon(
              Icons.remove,
              color: Theme.of(context).focusColor.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}

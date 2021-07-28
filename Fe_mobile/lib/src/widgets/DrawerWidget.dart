import 'package:Fe_mobile/config/ui_icons.dart';
import 'package:Fe_mobile/src/models/user.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  User _user = new User.init().getCurrentUser();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                _user.name!,
                style: Theme.of(context).textTheme.title,
              ),
              accountEmail: Text(
                _user.email!,
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
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Orders', arguments: 0);
            },
            leading: Icon(
              Icons.inbox,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Mis pedidos",
              style: Theme.of(context).textTheme.subhead,
            ),
            trailing: Chip(
              padding: EdgeInsets.symmetric(horizontal: 5),
              backgroundColor: Colors.transparent,
              shape: StadiumBorder(
                  side: BorderSide(color: Theme.of(context).focusColor)),
              label: Text(
                '8',
                style: TextStyle(color: Theme.of(context).focusColor),
              ),
            ),
          ),
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
          ListTile(
            dense: true,
            title: Text(
              "Publicaciones",
              style: Theme.of(context).textTheme.body1,
            ),
            trailing: Icon(
              Icons.remove,
              color: Theme.of(context).focusColor.withOpacity(0.3),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Categories');
            },
            leading: Icon(
              Icons.folder_open_outlined,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Categorías",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Brands');
            },
            leading: Icon(
              Icons.folder_open_outlined,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Mis Producos",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
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

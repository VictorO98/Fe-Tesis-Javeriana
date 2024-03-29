import 'package:Fe_mobile/config/ui_icons.dart';
import 'package:Fe_mobile/src/core/pages/usuario/perfil_usuario_page.dart';
import 'package:Fe_mobile/src/core/providers/usuario_provider.dart';
import 'package:Fe_mobile/src/core/util/helpers_util.dart';
import 'package:Fe_mobile/src/core/util/preferencias_util.dart';
import 'package:Fe_mobile/src/screens/chat.dart';
import 'package:Fe_mobile/src/dominio/pages/contenido/favoritos_usuario_page.dart';
import 'package:Fe_mobile/src/dominio/pages/Contenido/contenido_home_page.dart';
import 'package:Fe_mobile/src/screens/messages.dart';
import 'package:Fe_mobile/src/screens/notifications.dart';
import 'package:Fe_mobile/src/widgets/DrawerWidget.dart';
import 'package:Fe_mobile/src/widgets/FilterWidget.dart';
import 'package:Fe_mobile/src/widgets/ShoppingCartButtonWidget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TabsWidget extends StatefulWidget {
  int? currentTab = 2;
  int? selectedTab = 2;
  String currentTitle = 'Home';
  Widget currentPage = ContenidoHomePage();

  TabsWidget({
    Key? key,
    this.currentTab,
  }) : super(key: key);

  @override
  _TabsWidgetState createState() {
    return _TabsWidgetState();
  }
}

class _TabsWidgetState extends State<TabsWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var sizeIcons = 22.0;

  final _prefs = new PreferenciasUtil();

  UsuarioProvider _usuarioProvider = new UsuarioProvider();

  @override
  initState() {
    _selectTab(widget.currentTab);
    _cargarImagenUsuario();
    super.initState();
  }

  _cargarImagenUsuario() async {
    if (!Helpers.IS_FOTO_PERFIL) {
      var email = await _prefs.getPrefStr("email");
      var ans = await _usuarioProvider.isFotoPerfil(email);

      setState(() {
        Helpers.IS_FOTO_PERFIL = ans;
        if (ans) {
          Helpers.FOTO_USUARIO = Helpers.FOTO_USUARIO + email!;
        }
      });
    }
  }

  @override
  void didUpdateWidget(TabsWidget oldWidget) {
    _selectTab(oldWidget.currentTab);
    super.didUpdateWidget(oldWidget);
  }

  void _selectTab(int? tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      widget.selectedTab = tabItem;
      switch (tabItem) {
        case 0:
          widget.currentTitle = 'Notificaciones';
          widget.currentPage = NotificationsWidget();
          break;
        case 1:
          widget.currentTitle = 'Cuenta';
          widget.currentPage = PerfilUsuarioPage();
          break;
        case 2:
          widget.currentTitle = 'Inicio';
          widget.currentPage = ContenidoHomePage();
          break;
        case 3:
          widget.currentTitle = 'Mensajes';
          widget.currentPage = MessagesWidget();
          break;
        case 4:
          widget.currentTitle = 'Favoritos';
          widget.currentPage = FavoritosUsuarioPage();
          break;
        case 5:
          widget.selectedTab = 3;
          widget.currentTitle = 'Chat';
          widget.currentPage = ChatWidget();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(),
      endDrawer: FilterWidget(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
//        leading: new IconButton(
//          icon: new Icon(UiIcons.return_icon, color: Theme.of(context).hintColor),
//          onPressed: () => Navigator.of(context).pop(),
//        ),
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.currentTitle,
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
                child: Helpers.IS_FOTO_PERFIL
                    ? CircleAvatar(
                        backgroundColor: Theme.of(context).accentColor,
                        backgroundImage:
                            NetworkImage((Helpers.FOTO_USUARIO).toString()))
                    : CircleAvatar(
                        backgroundColor: Theme.of(context).accentColor,
                        backgroundImage: AssetImage('img/user3.jpg'),
                      ),
              )),
        ],
      ),
      body: widget.currentPage,
//      bottomNavigationBar: CurvedNavigationBar(
//        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//        buttonBackgroundColor: Theme.of(context).accentColor,
//        color: Theme.of(context).focusColor.withOpacity(0.2),
//        height: 60,
//        index: widget.selectedTab,
//        onTap: (int i) {
//          this._selectTab(i);
//        },
//        items: <Widget>[
//          Icon(
//            UiIcons.bell,
//            size: 23,
//            color: Theme.of(context).focusColor,
//          ),
//          Icon(
//            UiIcons.user_1,
//            size: 23,
//            color: Theme.of(context).focusColor,
//          ),
//          Icon(
//            UiIcons.home,
//            size: 23,
//            color: Theme.of(context).focusColor,
//          ),
//          Icon(
//            UiIcons.chat,
//            size: 23,
//            color: Theme.of(context).focusColor,
//          ),
//          Icon(
//            UiIcons.heart,
//            size: 23,
//            color: Theme.of(context).focusColor,
//          ),
//        ],
//      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).accentColor,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        iconSize: 22,
        elevation: 0,
        backgroundColor: Colors.transparent,
        selectedIconTheme: IconThemeData(size: 25),
        unselectedItemColor: Theme.of(context).hintColor.withOpacity(1),
        currentIndex: widget.selectedTab!,
        onTap: (int i) {
          this._selectTab(i);
        },
        // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active_outlined, size: sizeIcons),
            title: new Container(height: 0.0),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_outlined, size: sizeIcons),
            title: new Container(height: 0.0),
          ),
          BottomNavigationBarItem(
              title: new Container(height: 5.0),
              icon: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).accentColor.withOpacity(0.4),
                        blurRadius: 40,
                        offset: Offset(0, 15)),
                    BoxShadow(
                        color: Theme.of(context).accentColor.withOpacity(0.4),
                        blurRadius: 13,
                        offset: Offset(0, 3))
                  ],
                ),
                child: new Icon(Icons.home,
                    color: Theme.of(context).primaryColor, size: sizeIcons + 4),
              )),
          BottomNavigationBarItem(
            icon: new Icon(Icons.chat_outlined, size: sizeIcons),
            title: new Container(height: 0.0),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.favorite_border_outlined, size: sizeIcons),
            title: new Container(height: 0.0),
          ),
        ],
      ),
    );
  }
}

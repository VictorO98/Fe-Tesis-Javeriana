import 'package:Fe_mobile/src/dominio/models/producto_servicio_model.dart';
import 'package:Fe_mobile/src/dominio/widgets/busqueda_usuario_widget.dart';
import 'package:Fe_mobile/src/dominio/widgets/publicaciones_usuario_widget.dart';
import 'package:Fe_mobile/src/models/order.dart';
import 'package:Fe_mobile/src/models/route_argument.dart';
import 'package:Fe_mobile/src/screens/orders_products.dart';
import 'package:Fe_mobile/src/widgets/DrawerWidget.dart';
import 'package:Fe_mobile/src/widgets/ShoppingCartButtonWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BusquedaProductosPage extends StatefulWidget {
  int? currentTab;
  RouteArgument? routeArgument;
  String? _tipoProducto;
  List<ProductoServicioModel>? _listaPublicaciones;

  BusquedaProductosPage({Key? key, this.currentTab, this.routeArgument}) {
    _tipoProducto = this.routeArgument!.argumentsList![0] as String?;
    _listaPublicaciones =
        this.routeArgument!.argumentsList![1] as List<ProductoServicioModel>?;
  }

  @override
  _BusquedaProductosPageState createState() => _BusquedaProductosPageState();
}

class _BusquedaProductosPageState extends State<BusquedaProductosPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<ProductoServicioModel>? _orderList = [];

  @override
  Widget build(BuildContext context) {
    _orderList = widget._listaPublicaciones;
    var publicacion = widget._tipoProducto;
    return DefaultTabController(
        initialIndex: widget.currentTab ?? 0,
        length: 5,
        child: Scaffold(
            key: _scaffoldKey,
            drawer: DrawerWidget(),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              // leading: new IconButton(
              //   icon: new Icon(UiIcons.return_icon,
              //       color: Theme.of(context).hintColor),
              //   onPressed: () => Navigator.of(context).pop(),
              // ),
              leading: new IconButton(
                icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
                onPressed: () => _scaffoldKey.currentState!.openDrawer(),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                'Tú busqueda',
                style: Theme.of(context).textTheme.display1,
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
                        backgroundImage: AssetImage('img/user2.jpg'),
                      ),
                    )),
              ],
            ),
            body: BusquedaUsuarioWidget(
              publicaciones: _orderList,
              tipoPublicacion: publicacion,
            )));
  }
}

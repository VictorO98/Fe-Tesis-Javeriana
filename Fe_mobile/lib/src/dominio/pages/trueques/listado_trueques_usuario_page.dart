import 'package:Fe_mobile/src/core/models/info_usuario_model.dart';
import 'package:Fe_mobile/src/core/pages/usuario/bloc/info_perfil/info_usuario_bloc.dart';
import 'package:Fe_mobile/src/core/util/estados_trueque_util.dart';
import 'package:Fe_mobile/src/core/util/helpers_util.dart';
import 'package:Fe_mobile/src/core/util/preferencias_util.dart';
import 'package:Fe_mobile/src/dominio/models/info_trueques_model.dart';
import 'package:Fe_mobile/src/dominio/widgets/trueque_detalle_widget.dart';
import 'package:Fe_mobile/src/models/order.dart';
import 'package:Fe_mobile/src/models/route_argument.dart';
import 'package:Fe_mobile/src/screens/orders_products.dart';
import 'package:Fe_mobile/src/widgets/DrawerWidget.dart';
import 'package:Fe_mobile/src/widgets/ShoppingCartButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListadoTruequesUsuarioWidget extends StatefulWidget {
  int? currentTab;
  RouteArgument? routeArgument;
  List<InfoTruequesModel>? _listadoTrueques;

  ListadoTruequesUsuarioWidget(
      {Key? key, this.currentTab, this.routeArgument}) {
    _listadoTrueques =
        this.routeArgument!.argumentsList![0] as List<InfoTruequesModel>;
  }
  @override
  _ListadoTruequesUsuarioWidgetState createState() =>
      _ListadoTruequesUsuarioWidgetState();
}

class _ListadoTruequesUsuarioWidgetState
    extends State<ListadoTruequesUsuarioWidget> {
  final _prefs = new PreferenciasUtil();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  InfoUsuarioBloc? _infoUsuarioBloc;

  bool _cargandoUsuario = false;

  @override
  void initState() {
    super.initState();
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
    return DefaultTabController(
        initialIndex: widget.currentTab ?? 0,
        length: 4,
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
              'Trueques',
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
                              // backgroundImage: AssetImage(_user.avatar!),
                              backgroundImage: NetworkImage(
                                  (Helpers.FOTO_USUARIO).toString()))
                          : CircleAvatar(
                              backgroundImage: AssetImage('img/user3.jpg'),
                            ))),
            ],
            bottom: TabBar(
                indicatorPadding: EdgeInsets.all(10),
                labelPadding: EdgeInsets.symmetric(horizontal: 5),
                unselectedLabelColor: Theme.of(context).accentColor,
                labelColor: Theme.of(context).primaryColor,
                isScrollable: true,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Theme.of(context).accentColor),
                tabs: [
                  Tab(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              color: Theme.of(context).accentColor, width: 1)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Todos"),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              color: Theme.of(context).accentColor, width: 1)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Aceptado"),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              color: Theme.of(context).accentColor, width: 1)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Ofertado"),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              color: Theme.of(context).accentColor, width: 1)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Rechazado"),
                      ),
                    ),
                  ),
                ]),
          ),
          body: TabBarView(children: [
            TruequeDetalleWidget(infoTrueques: widget._listadoTrueques),
            TruequeDetalleWidget(
                infoTrueques: widget._listadoTrueques!
                    .where((trueque) =>
                        trueque.estado == EstadosTruequeUtil.ACEPTADO)
                    .toList()),
            TruequeDetalleWidget(
                infoTrueques: widget._listadoTrueques!
                    .where((trueque) =>
                        trueque.estado == EstadosTruequeUtil.OFERTADO)
                    .toList()),
            TruequeDetalleWidget(
                infoTrueques: widget._listadoTrueques!
                    .where((trueque) =>
                        trueque.estado == EstadosTruequeUtil.RECHAZADO)
                    .toList())
          ]),
        ));
  }
}

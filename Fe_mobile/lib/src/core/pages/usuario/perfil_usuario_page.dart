import 'package:Fe_mobile/config/ui_icons.dart';
import 'package:Fe_mobile/src/core/models/info_usuario_model.dart';
import 'package:Fe_mobile/src/core/pages/usuario/bloc/info_perfil/info_usuario_bloc.dart';
import 'package:Fe_mobile/src/core/util/alert_util.dart';
import 'package:Fe_mobile/src/core/util/conf_api.dart';
import 'package:Fe_mobile/src/core/util/estados_pedido_util.dart';
import 'package:Fe_mobile/src/core/util/estados_trueque_util.dart';
import 'package:Fe_mobile/src/core/util/estilo_util.dart';
import 'package:Fe_mobile/src/core/util/preferencias_util.dart';
import 'package:Fe_mobile/src/dominio/models/info_pedidos_model.dart';
import 'package:Fe_mobile/src/dominio/models/info_trueques_model.dart';
import 'package:Fe_mobile/src/dominio/models/producto_servicio_model.dart';
import 'package:Fe_mobile/src/dominio/providers/contenido_provider.dart';
import 'package:Fe_mobile/src/dominio/providers/pedidos_provider.dart';
import 'package:Fe_mobile/src/dominio/providers/trueque_provider.dart';
import 'package:Fe_mobile/src/models/route_argument.dart';
import 'package:Fe_mobile/src/models/user.dart';
import 'package:Fe_mobile/src/widgets/ProfileSettingsDialog.dart';
import 'package:Fe_mobile/src/widgets/SearchBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PerfilUsuarioPage extends StatefulWidget {
  @override
  _PerfilUsuarioPageState createState() => _PerfilUsuarioPageState();
}

class _PerfilUsuarioPageState extends State<PerfilUsuarioPage> {
  final _prefs = new PreferenciasUtil();

  List<ProductoServicioModel> _productos = [];
  List<ProductoServicioModel> _servicios = [];
  List<InfoTruequesModel> _infoTrueques = [];
  List<InfoPedidosModel> _infoPedidos = [];
  List<InfoTruequesModel> _infoTruequesSolicitados = [];

  InfoUsuarioBloc? _infoUsuarioBloc;
  ContenidoProvider _contenidoProvider = new ContenidoProvider();
  TruequeProvider _truequeProvider = new TruequeProvider();
  PedidoProvider _pedidoProvider = new PedidoProvider();

  bool _cargandoUsuario = false;
  bool _cargandoProductos = false;
  bool _cargandoPedidos = false;

  User _user = new User.init().getCurrentUser();

  String? idDemografia;
  int? _pedidoPendiente;
  int? _pedidoEmpaquetado;
  int? _pedidoEnviado;
  int? _pedidoCancelado;
  int? _truequeOfertado;
  int? _truequeAceptado;
  int? _truequeRechazdo;

  @override
  void initState() {
    super.initState();
    _infoUsuarioBloc = BlocProvider.of<InfoUsuarioBloc>(context);
    _cargarInfoUsuario();
    _infoUsuarioBloc!.state.infoUsuarioModel!.rol == "Emprendedor"
        ? _cargarProductos()
        : SizedBox();
    _cargarPedidos();
    _infoUsuarioBloc!.state.infoUsuarioModel!.rol == "Emprendedor"
        ? _cargarTrueques()
        : SizedBox();
  }

  _cargarTrueques() async {
    var lista = await _truequeProvider.getTruequesPorIdComprador(
        _infoUsuarioBloc!.state.infoUsuarioModel!.id!);
    var list = await _truequeProvider.getTruequesPorIdVendedor(
        _infoUsuarioBloc!.state.infoUsuarioModel!.id!);
    var ace = 0;
    var ofe = 0;
    var rec = 0;
    for (var i = 0; i < lista.length; i++) {
      if (EstadosTruequeUtil.ACEPTADO == lista[i].estado) {
        ace += 1;
      }
      if (EstadosTruequeUtil.RECHAZADO == lista[i].estado) {
        rec += 1;
      }
      if (EstadosTruequeUtil.OFERTADO == lista[i].estado) {
        ofe += 1;
      }
    }

    if (mounted)
      setState(() {
        _infoTrueques = lista;
        _infoTruequesSolicitados = list;
        _truequeOfertado = ofe;
        _truequeAceptado = ace;
        _truequeRechazdo = rec;
      });
  }

  _cargarPedidos() async {
    var lista = await _pedidoProvider
        .getPedidosPorIdUsuario(_infoUsuarioBloc!.state.infoUsuarioModel!.id!);
    var pen = 0;
    var env = 0;
    var emp = 0;
    var can = 0;
    for (var i = 0; i < lista.length; i++) {
      if (EstadosPedidosUtil.PENDIENTE == lista[i].estado) {
        pen += 1;
      }
      if (EstadosPedidosUtil.ENVIADO == lista[i].estado) {
        env += 1;
      }
      if (EstadosPedidosUtil.EMPAQUETADO == lista[i].estado) {
        emp += 1;
      }
      if (EstadosPedidosUtil.CANCELADO == lista[i].estado) {
        can += 1;
      }
    }
    if (mounted)
      setState(() {
        _infoPedidos = lista;
        _pedidoPendiente = pen;
        _pedidoEmpaquetado = emp;
        _pedidoEnviado = env;
        _pedidoCancelado = can;
        _cargandoPedidos = true;
      });
  }

  _cargarProductos() async {
    var lista = await _contenidoProvider.getPublicacionesPorIdDemografia(
        _infoUsuarioBloc!.state.infoUsuarioModel!.id.toString());
    List<ProductoServicioModel> listaProductos = [];
    List<ProductoServicioModel> listaServicios = [];

    var idUsuario = _infoUsuarioBloc!.state.infoUsuarioModel!.id.toString();

    for (var i = 0; i < lista.length; i++) {
      lista[i].urlimagenproductoservicio =
          "${ConfServer.SERVER}dominio/COContenido/GetImagenProdcuto?idPublicacion=${lista[i].id}";
    }

    for (int i = 0; i < lista.length; i++) {
      if (lista[i].tipoPublicacion == "Producto") {
        listaProductos.add(lista[i]);
      } else {
        listaServicios.add(lista[i]);
      }
    }
    if (mounted)
      setState(() {
        _productos = listaProductos;
        _servicios = listaServicios;
        _cargandoProductos = true;
      });
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
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 7),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SearchBarWidget(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        _infoUsuarioBloc!.state.infoUsuarioModel!.nombreCompleto
                            .toString(),
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.display2,
                      ),
                      Text(
                        _infoUsuarioBloc!.state.infoUsuarioModel!.email
                            .toString(),
                        style: Theme.of(context).textTheme.caption,
                      )
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
                SizedBox(
                    width: 55,
                    height: 55,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(300),
                      onTap: () {
                        Navigator.of(context).pushNamed('/Tabs', arguments: 1);
                      },
                      child: CircleAvatar(
                        backgroundImage: AssetImage(_user.avatar!),
                      ),
                    )),
              ],
            ),
          ),
          _tabPrincipal(context),
          _infoUsuarioBloc!.state.infoUsuarioModel!.rol == "Emprendedor"
              ? _infoProductosEmprendedores(context)
              : _infoUsuarios(context),
          _cargandoPedidos ? _userOrders(context) : CircularProgressIndicator(),
          _infoUsuarioBloc!.state.infoUsuarioModel!.rol == "Emprendedor"
              ? _infoFacturacionEmprendedor(context)
              : SizedBox(),
          _infoUsuarioBloc!.state.infoUsuarioModel!.rol == "Emprendedor"
              ? _userTrueques(context)
              : SizedBox(),
          _infoUsuarioBloc!.state.infoUsuarioModel!.rol == "Emprendedor"
              ? _userTruequeSolicitados(context)
              : SizedBox(),
          _cargandoUsuario
              ? Center(child: CircularProgressIndicator())
              : _userProfile(context),
          _acountSettings(context),
        ],
      ),
    );
  }

  Widget _tabPrincipal(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).hintColor.withOpacity(0.15),
                offset: Offset(0, 3),
                blurRadius: 10)
          ],
        ),
        child: _infoUsuarioBloc!.state.infoUsuarioModel!.rol == "Usuario"
            ? Row(
                children: <Widget>[
                  Expanded(
                    child: FlatButton(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        onPressed: () {
                          AlertUtil.success(context,
                              '¡Ya iniciaste tu camino como emprendedor! \n Ahora anexa tus documentos');
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.group,
                                color: Theme.of(context).hintColor),
                            Text(
                              '¿Quieres ser emprendedor? Haz click aquí',
                              style: Theme.of(context).textTheme.bodyText2,
                            )
                          ],
                        )),
                  ),
                ],
              )
            : Row(
                children: <Widget>[
                  Expanded(
                    child: FlatButton(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/Orders');
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.shopping_cart_outlined,
                                color: Theme.of(context).hintColor),
                            Text(
                              'Mis pedidos',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyText2,
                            )
                          ],
                        )),
                  ),
                  Expanded(
                    child: FlatButton(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/Orders');
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.attach_money_outlined,
                                color: Theme.of(context).hintColor),
                            Text(
                              'Mis ventas',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyText2,
                            )
                          ],
                        )),
                  ),
                  Expanded(
                    child: FlatButton(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/SolicitudTrueques',
                              arguments: new RouteArgument(
                                  argumentsList: [_infoTruequesSolicitados]));
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.autorenew_sharp,
                                color: Theme.of(context).hintColor),
                            Text(
                              'Intercambios',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyText2,
                            )
                          ],
                        )),
                  ),
                  Expanded(
                    child: FlatButton(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/Create');
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.add, color: Theme.of(context).hintColor),
                            Text(
                              'Crear venta',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyText2,
                            )
                          ],
                        )),
                  ),
                ],
              ));
  }

  Widget _userOrders(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).hintColor.withOpacity(0.15),
              offset: Offset(0, 3),
              blurRadius: 10)
        ],
      ),
      child: ListView(
        shrinkWrap: true,
        primary: false,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.inbox_outlined),
            title: Text(
              'Mis pedidos',
              style: Theme.of(context).textTheme.body2,
            ),
            trailing: ButtonTheme(
              padding: EdgeInsets.all(0),
              minWidth: 50.0,
              height: 25.0,
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/Orders');
                },
                child: Text(
                  "Ver todo",
                  style: Theme.of(context).textTheme.body1,
                ),
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Orders');
            },
            dense: true,
            title: Text(
              'Pendiente',
              style: Theme.of(context).textTheme.body1,
            ),
            trailing: Chip(
              padding: EdgeInsets.symmetric(horizontal: 10),
              backgroundColor: Colors.transparent,
              shape: StadiumBorder(
                  side: BorderSide(color: Theme.of(context).focusColor)),
              label: Text(
                // TODO CAMBIAR ESTA SHIT
                '1',
                //_pedidoPendiente.toString(),
                style: TextStyle(color: Theme.of(context).focusColor),
              ),
            ),
          ),
          ListTile(
              onTap: () {
                Navigator.of(context).pushNamed('/Orders');
              },
              dense: true,
              title: Text(
                'Enviado',
                style: Theme.of(context).textTheme.body1,
              ),
              trailing: Chip(
                padding: EdgeInsets.symmetric(horizontal: 10),
                backgroundColor: Colors.transparent,
                shape: StadiumBorder(
                    side: BorderSide(color: Theme.of(context).focusColor)),
                label: Text(
                  '1',
                  // _pedidoEnviado.toString(),
                  style: TextStyle(color: Theme.of(context).focusColor),
                ),
              )),
          ListTile(
              onTap: () {
                Navigator.of(context).pushNamed('/Orders');
              },
              dense: true,
              title: Text(
                'Entregado',
                style: Theme.of(context).textTheme.body1,
              ),
              trailing: Chip(
                padding: EdgeInsets.symmetric(horizontal: 10),
                backgroundColor: Colors.transparent,
                shape: StadiumBorder(
                    side: BorderSide(color: Theme.of(context).focusColor)),
                label: Text(
                  '1',
                  //_pedidoEmpaquetado.toString(),
                  style: TextStyle(color: Theme.of(context).focusColor),
                ),
              )),
          ListTile(
              onTap: () {
                Navigator.of(context).pushNamed('/Orders');
              },
              dense: true,
              title: Text(
                'Devoluciones',
                style: Theme.of(context).textTheme.body1,
              ),
              trailing: Chip(
                padding: EdgeInsets.symmetric(horizontal: 10),
                backgroundColor: Colors.transparent,
                shape: StadiumBorder(
                    side: BorderSide(color: Theme.of(context).focusColor)),
                label: Text(
                  _pedidoCancelado.toString(),
                  style: TextStyle(color: Theme.of(context).focusColor),
                ),
              ))
        ],
      ),
    );
  }

  Widget _userTruequeSolicitados(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).hintColor.withOpacity(0.15),
              offset: Offset(0, 3),
              blurRadius: 10)
        ],
      ),
      child: ListView(
        shrinkWrap: true,
        primary: false,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.business),
            title: Text(
              'Intercambios solictados',
              style: Theme.of(context).textTheme.body2,
            ),
            trailing: ButtonTheme(
              padding: EdgeInsets.all(0),
              minWidth: 50.0,
              height: 25.0,
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/SolicitudTrueques',
                      arguments: new RouteArgument(
                          argumentsList: [_infoTruequesSolicitados]));
                },
                child: Text(
                  "Ver todo",
                  style: Theme.of(context).textTheme.body1,
                ),
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Orders');
            },
            dense: true,
            title: Text(
              'Solicitados',
              style: Theme.of(context).textTheme.body1,
            ),
            trailing: Chip(
              padding: EdgeInsets.symmetric(horizontal: 10),
              backgroundColor: Colors.transparent,
              shape: StadiumBorder(
                  side: BorderSide(color: Theme.of(context).focusColor)),
              label: Text(
                _infoTruequesSolicitados.length.toString(),
                style: TextStyle(color: Theme.of(context).focusColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _userTrueques(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).hintColor.withOpacity(0.15),
              offset: Offset(0, 3),
              blurRadius: 10)
        ],
      ),
      child: ListView(
        shrinkWrap: true,
        primary: false,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.approval_outlined),
            title: Text(
              'Mis intercambios',
              style: Theme.of(context).textTheme.body2,
            ),
            trailing: ButtonTheme(
              padding: EdgeInsets.all(0),
              minWidth: 50.0,
              height: 25.0,
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/TruquesUsuario',
                      arguments:
                          new RouteArgument(argumentsList: [_infoTrueques]));
                },
                child: Text(
                  "Ver todo",
                  style: Theme.of(context).textTheme.body1,
                ),
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Orders');
            },
            dense: true,
            title: Text(
              'Ofertado',
              style: Theme.of(context).textTheme.body1,
            ),
            trailing: Chip(
              padding: EdgeInsets.symmetric(horizontal: 10),
              backgroundColor: Colors.transparent,
              shape: StadiumBorder(
                  side: BorderSide(color: Theme.of(context).focusColor)),
              label: Text(
                _truequeOfertado.toString(),
                style: TextStyle(color: Theme.of(context).focusColor),
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Orders');
            },
            dense: true,
            title: Text(
              'Aceptado',
              style: Theme.of(context).textTheme.body1,
            ),
            trailing: Chip(
              padding: EdgeInsets.symmetric(horizontal: 10),
              backgroundColor: Colors.transparent,
              shape: StadiumBorder(
                  side: BorderSide(color: Theme.of(context).focusColor)),
              label: Text(
                _truequeAceptado.toString(),
                style: TextStyle(color: Theme.of(context).focusColor),
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Orders');
            },
            dense: true,
            title: Text(
              'Rechazado',
              style: Theme.of(context).textTheme.body1,
            ),
            trailing: Chip(
              padding: EdgeInsets.symmetric(horizontal: 10),
              backgroundColor: Colors.transparent,
              shape: StadiumBorder(
                  side: BorderSide(color: Theme.of(context).focusColor)),
              label: Text(
                _truequeRechazdo.toString(),
                style: TextStyle(color: Theme.of(context).focusColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoFacturacionEmprendedor(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).hintColor.withOpacity(0.15),
              offset: Offset(0, 3),
              blurRadius: 10)
        ],
      ),
      child: ListView(
        shrinkWrap: true,
        primary: false,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.money_outlined),
            title: Text(
              'Mis ventas',
              style: Theme.of(context).textTheme.body2,
            ),
            trailing: ButtonTheme(
              padding: EdgeInsets.all(0),
              minWidth: 50.0,
              height: 25.0,
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/Orders');
                },
                child: Text(
                  "Ver todo",
                  style: Theme.of(context).textTheme.body1,
                ),
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Orders');
            },
            dense: true,
            title: Text(
              'Facturadas',
              style: Theme.of(context).textTheme.body1,
            ),
            trailing: Chip(
              padding: EdgeInsets.symmetric(horizontal: 10),
              backgroundColor: Colors.transparent,
              shape: StadiumBorder(
                  side: BorderSide(color: Theme.of(context).focusColor)),
              label: Text(
                '0',
                style: TextStyle(color: Theme.of(context).focusColor),
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Orders');
            },
            dense: true,
            title: Text(
              'Enviadas',
              style: Theme.of(context).textTheme.body1,
            ),
            trailing: Chip(
              padding: EdgeInsets.symmetric(horizontal: 10),
              backgroundColor: Colors.transparent,
              shape: StadiumBorder(
                  side: BorderSide(color: Theme.of(context).focusColor)),
              label: Text(
                '0',
                style: TextStyle(color: Theme.of(context).focusColor),
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Orders');
            },
            dense: true,
            title: Text(
              'Entregadas',
              style: Theme.of(context).textTheme.body1,
            ),
            trailing: Chip(
              padding: EdgeInsets.symmetric(horizontal: 10),
              backgroundColor: Colors.transparent,
              shape: StadiumBorder(
                  side: BorderSide(color: Theme.of(context).focusColor)),
              label: Text(
                '0',
                style: TextStyle(color: Theme.of(context).focusColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoProductosEmprendedores(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).hintColor.withOpacity(0.15),
              offset: Offset(0, 3),
              blurRadius: 10)
        ],
      ),
      child: ListView(
        shrinkWrap: true,
        primary: false,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.file_present_outlined),
            title: Text(
              'Publicaciones',
              style: Theme.of(context).textTheme.body2,
            ),
            trailing: ButtonTheme(
              padding: EdgeInsets.all(0),
              minWidth: 50.0,
              height: 25.0,
              child: FlatButton(
                onPressed: () {},
                child: Text("Vender",
                    style: Theme.of(context).textTheme.bodyText2),
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/MisPub',
                  arguments: new RouteArgument(
                      argumentsList: ['Productos', _productos]));
            },
            dense: true,
            title: Text(
              'Productos',
              style: Theme.of(context).textTheme.body1,
            ),
            trailing: Chip(
              padding: EdgeInsets.symmetric(horizontal: 10),
              backgroundColor: Colors.transparent,
              shape: StadiumBorder(
                  side: BorderSide(color: Theme.of(context).focusColor)),
              label: Text(
                _productos.length.toString(),
                style: TextStyle(color: Theme.of(context).focusColor),
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/MisPub',
                  arguments: new RouteArgument(
                      argumentsList: ['Servicios', _servicios]));
            },
            dense: true,
            title: Text(
              'Servicios',
              style: Theme.of(context).textTheme.body1,
            ),
            trailing: Chip(
              padding: EdgeInsets.symmetric(horizontal: 10),
              backgroundColor: Colors.transparent,
              shape: StadiumBorder(
                  side: BorderSide(color: Theme.of(context).focusColor)),
              label: Text(
                _servicios.length.toString(),
                style: TextStyle(color: Theme.of(context).focusColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoUsuarios(BuildContext context) {
    return SizedBox(height: 0);
  }

  Widget _userProfile(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).hintColor.withOpacity(0.15),
              offset: Offset(0, 3),
              blurRadius: 10)
        ],
      ),
      child: ListView(
        shrinkWrap: true,
        primary: false,
        children: <Widget>[
          ListTile(
            leading: new Icon(Icons.person_outline_outlined),
            title: Text(
              'Configuración de perfil',
              style: Theme.of(context).textTheme.body2,
            ),
            trailing: ButtonTheme(
              padding: EdgeInsets.all(0),
              minWidth: 50.0,
              height: 25.0,
              child: ProfileSettingsDialog(
                user: this._user,
                onChanged: () {
                  setState(() {});
                },
              ),
            ),
          ),
          ListTile(
            onTap: () {},
            dense: true,
            title: Text(
              'Nombres',
              style: Theme.of(context).textTheme.body1,
            ),
            trailing: Text(
              _infoUsuarioBloc!.state.infoUsuarioModel!.nombres.toString(),
              style: TextStyle(color: Theme.of(context).focusColor),
            ),
          ),
          ListTile(
            onTap: () {},
            dense: true,
            title: Text(
              'Apellidos',
              style: Theme.of(context).textTheme.body1,
            ),
            trailing: Text(
              _infoUsuarioBloc!.state.infoUsuarioModel!.apellidos.toString(),
              style: TextStyle(color: Theme.of(context).focusColor),
            ),
          ),
          ListTile(
            onTap: () {},
            dense: true,
            title: Text(
              'Correo',
              style: Theme.of(context).textTheme.body1,
            ),
            trailing: Text(
              _infoUsuarioBloc!.state.infoUsuarioModel!.email.toString(),
              style: TextStyle(color: Theme.of(context).focusColor),
            ),
          ),
          ListTile(
            onTap: () {},
            dense: true,
            title: Text(
              'Dirección entregas',
              style: Theme.of(context).textTheme.body1,
            ),
            trailing: Text(
              _infoUsuarioBloc!.state.infoUsuarioModel!.direccion.toString(),
              style: TextStyle(color: Theme.of(context).focusColor),
            ),
          ),
          ListTile(
            onTap: () {},
            dense: true,
            title: Text(
              'Ciudad',
              style: Theme.of(context).textTheme.body1,
            ),
            trailing: Text(
              _infoUsuarioBloc!.state.infoUsuarioModel!.poblacion.toString(),
              style: TextStyle(color: Theme.of(context).focusColor),
            ),
          ),
          ListTile(
            onTap: () {},
            dense: true,
            title: Text(
              'Departamento',
              style: Theme.of(context).textTheme.body1,
            ),
            trailing: Text(
              _infoUsuarioBloc!.state.infoUsuarioModel!.estado.toString(),
              style: TextStyle(color: Theme.of(context).focusColor),
            ),
          )
        ],
      ),
    );
  }

  Widget _acountSettings(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).hintColor.withOpacity(0.15),
              offset: Offset(0, 3),
              blurRadius: 10)
        ],
      ),
      child: ListView(
        shrinkWrap: true,
        primary: false,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              'Configuración',
              style: Theme.of(context).textTheme.body2,
            ),
          ),
          // ListTile(
          //   onTap: () {
          //     Navigator.of(context).pushNamed('/Languages');
          //   },
          //   dense: true,
          //   title: Row(
          //     children: <Widget>[
          //       Icon(
          //         UiIcons.planet_earth,
          //         size: 22,
          //         color: Theme.of(context).focusColor,
          //       ),
          //       SizedBox(width: 10),
          //       Text(
          //         'Languages',
          //         style: Theme.of(context).textTheme.body1,
          //       ),
          //     ],
          //   ),
          //   trailing: Text(
          //     'English',
          //     style: TextStyle(color: Theme.of(context).focusColor),
          //   ),
          // ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Help');
            },
            dense: true,
            title: Row(
              children: <Widget>[
                Icon(
                  Icons.perm_device_information,
                  size: 22,
                  color: Theme.of(context).focusColor,
                ),
                SizedBox(width: 10),
                Text(
                  'Ayuda y Soporte',
                  style: Theme.of(context).textTheme.body1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

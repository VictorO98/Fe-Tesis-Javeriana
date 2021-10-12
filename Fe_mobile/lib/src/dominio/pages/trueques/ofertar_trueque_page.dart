import 'package:Fe_mobile/src/core/models/info_usuario_model.dart';
import 'package:Fe_mobile/src/core/models/respuesta_datos_model.dart';
import 'package:Fe_mobile/src/core/pages/usuario/bloc/info_perfil/info_usuario_bloc.dart';
import 'package:Fe_mobile/src/core/util/alert_util.dart';
import 'package:Fe_mobile/src/core/util/conf_api.dart';
import 'package:Fe_mobile/src/core/util/currency_util.dart';
import 'package:Fe_mobile/src/core/util/preferencias_util.dart';
import 'package:Fe_mobile/src/dominio/models/crear_trueque_model.dart';
import 'package:Fe_mobile/src/dominio/models/producto_servicio_model.dart';
import 'package:Fe_mobile/src/dominio/providers/contenido_provider.dart';
import 'package:Fe_mobile/src/dominio/providers/trueque_provider.dart';
import 'package:Fe_mobile/src/models/route_argument.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OfertarTruequePage extends StatefulWidget {
  int? currentTab;
  RouteArgument? routeArgument;
  ProductoServicioModel? _productoOferta;
  int? _cantidadOFertada;

  OfertarTruequePage({Key? key, this.currentTab, this.routeArgument}) {
    _cantidadOFertada = this.routeArgument!.argumentsList![0] as int?;
    _productoOferta =
        this.routeArgument!.argumentsList![1] as ProductoServicioModel?;
  }

  @override
  _OfertarTruequePageState createState() => _OfertarTruequePageState();
}

class _OfertarTruequePageState extends State<OfertarTruequePage>
    with SingleTickerProviderStateMixin {
  List<ProductoServicioModel> _productsList = [];
  ProductoServicioModel _productoInteresado = new ProductoServicioModel();

  final _prefs = new PreferenciasUtil();

  ContenidoProvider _contenidoProvider = new ContenidoProvider();
  CrearTruequeModel _crearTruequeModel = new CrearTruequeModel();
  TruequeProvider _truequeProvider = new TruequeProvider();

  InfoUsuarioBloc? _infoUsuarioBloc;

  String heroTag = 'trueque';

  int? _cantidadInteresada;

  bool isLoadingTrueque = false;

  @override
  void initState() {
    super.initState();
    _infoUsuarioBloc = BlocProvider.of<InfoUsuarioBloc>(context);
    _initialUserConfiguration();
    _initialConfiguration();
  }

  _initialUserConfiguration() async {
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
    }
  }

  _initialConfiguration() async {
    var lista = await _contenidoProvider.getPublicacionesPorIdDemografia(
        _infoUsuarioBloc!.state.infoUsuarioModel!.id!);

    for (var i = 0; i < lista.length; i++) {
      lista[i].urlimagenproductoservicio =
          "${ConfServer.SERVER}dominio/COContenido/GetImagenProdcuto?idPublicacion=${lista[i].id}";
      lista[i].cantidadOfertarTrueque = 0;
    }
    setState(() {
      _productsList = lista;
    });
  }

  @override
  Widget build(BuildContext context) {
    _productoInteresado = widget._productoOferta!;
    _productoInteresado.cantidadOfertarTrueque = widget._cantidadOFertada!;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Atrás',
          style: Theme.of(context).textTheme.headline4,
        ),
        actions: <Widget>[
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
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 150),
            padding: EdgeInsets.only(bottom: 15),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 10),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      leading: Icon(
                        Icons.change_circle_outlined,
                        color: Theme.of(context).hintColor,
                      ),
                      title: Text(
                        'Intercambio de productos',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      subtitle: Text(
                        'Selecciona los productos para realizar el cambio',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 10),
                    child: Text("Producto Interesado",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                  InkWell(
                    splashColor: Theme.of(context).accentColor,
                    focusColor: Theme.of(context).accentColor,
                    highlightColor: Theme.of(context).primaryColor,
                    onTap: () {},
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.9),
                        boxShadow: [
                          BoxShadow(
                              color:
                                  Theme.of(context).focusColor.withOpacity(0.1),
                              blurRadius: 5,
                              offset: Offset(0, 2)),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Hero(
                            tag: heroTag + _productoInteresado.id.toString(),
                            child: Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                image: DecorationImage(
                                  image: NetworkImage(_productoInteresado
                                      .urlimagenproductoservicio
                                      .toString()),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          Flexible(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        _productoInteresado.nombre!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text('Unidades: ' +
                                          _productoInteresado.cantidadtotal
                                              .toString()),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _productoInteresado
                                                  .cantidadOfertarTrueque =
                                              _productoInteresado
                                                      .cantidadOfertarTrueque! +
                                                  1;
                                        });
                                      },
                                      iconSize: 30,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      icon: Icon(Icons.add_circle_outline),
                                      color: Theme.of(context).hintColor,
                                    ),
                                    Text(
                                        _productoInteresado
                                            .cantidadOfertarTrueque
                                            .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (_productoInteresado
                                                      .cantidadOfertarTrueque! -
                                                  1 >=
                                              0)
                                            _productoInteresado
                                                    .cantidadOfertarTrueque =
                                                _productoInteresado
                                                        .cantidadOfertarTrueque! -
                                                    1;
                                        });
                                      },
                                      iconSize: 30,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      icon: Icon(Icons.remove_circle_outline),
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 10),
                    child: Text("Mis productos",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                  ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: _productsList.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 15);
                    },
                    itemBuilder: (context, index) {
                      var product = _productsList.elementAt(index);
                      // return TruequetemWidget(
                      //     product: _productsList.elementAt(index),
                      //     heroTag: 'cart');
                      return InkWell(
                        splashColor: Theme.of(context).accentColor,
                        focusColor: Theme.of(context).accentColor,
                        highlightColor: Theme.of(context).primaryColor,
                        onTap: () {},
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.9),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: Offset(0, 2)),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Hero(
                                tag: heroTag + product.id.toString(),
                                child: Container(
                                  height: 90,
                                  width: 90,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    image: DecorationImage(
                                      image: NetworkImage(product
                                          .urlimagenproductoservicio
                                          .toString()),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                              product.cantidadtotal != 0
                                  ? Flexible(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  product.nombre!,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text('Disponible: ' +
                                                    product.cantidadtotal
                                                        .toString()),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "${CurrencyUtil.convertFormatMoney('COP', product.preciounitario!)}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline4,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    product.cantidadOfertarTrueque =
                                                        product.cantidadOfertarTrueque! +
                                                            1;
                                                  });
                                                },
                                                iconSize: 30,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5),
                                                icon: Icon(
                                                    Icons.add_circle_outline),
                                                color:
                                                    Theme.of(context).hintColor,
                                              ),
                                              Text(
                                                  product.cantidadOfertarTrueque
                                                      .toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1),
                                              IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    if (product.cantidadOfertarTrueque! -
                                                            1 >=
                                                        0)
                                                      product.cantidadOfertarTrueque =
                                                          product.cantidadOfertarTrueque! -
                                                              1;
                                                  });
                                                },
                                                iconSize: 30,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5),
                                                icon: Icon(Icons
                                                    .remove_circle_outline),
                                                color:
                                                    Theme.of(context).hintColor,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  : Text(
                                      'No tienes disponibilidad del producto',
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 170,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).focusColor.withOpacity(0.15),
                        offset: Offset(0, -2),
                        blurRadius: 5.0)
                  ]),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(height: 10),
                    Stack(
                      fit: StackFit.loose,
                      alignment: AlignmentDirectional.centerEnd,
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 40,
                          child: FlatButton(
                            onPressed: () {
                              var cantidadProductosOfertados = 0;
                              var _ofertaUsuario;
                              for (int i = 0; i < _productsList.length; i++) {
                                if (_productsList[i].cantidadOfertarTrueque! >
                                    0) {
                                  cantidadProductosOfertados += 1;
                                  _ofertaUsuario = _productsList[i];
                                }
                              }
                              if (cantidadProductosOfertados == 1) {
                                AlertUtil.confirm(
                                    context,
                                    '¿Esta seguro de ofertar ' +
                                        _ofertaUsuario.cantidadOfertarTrueque
                                            .toString() +
                                        " " +
                                        _ofertaUsuario.nombre! +
                                        "?",
                                    () => _realizarTrueque(
                                        context, _ofertaUsuario),
                                    confirmBtnText: 'OFERTAR');
                              } else {
                                if (cantidadProductosOfertados == 0) {
                                  AlertUtil.error(
                                      context, '¡Debes ofertar un producto!');
                                } else {
                                  AlertUtil.error(context,
                                      '¡Solo puedes ofertar un producto!');
                                }
                              }
                            },
                            padding: EdgeInsets.symmetric(vertical: 14),
                            color: Theme.of(context).accentColor,
                            shape: StadiumBorder(),
                            child: Text(
                              'Realizar Oferta',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _realizarTrueque(
      BuildContext context, ProductoServicioModel _productoSeleccionado) {
    _crearTruequeModel.idproductoserviciocomprador = _productoSeleccionado.id;
    _crearTruequeModel.idproductoserviciovendedor = _productoInteresado.id;
    _crearTruequeModel.cantidadcomprador =
        _productoSeleccionado.cantidadOfertarTrueque;
    _crearTruequeModel.cantidadvendedor =
        _productoInteresado.cantidadOfertarTrueque;
    _truequeProvider.crearTrueque(_crearTruequeModel, context).then((value) {
      // TODO : CORREGIR LA CANTIDAD DE PRODUCTO DESEADO, CORREGIR EL MENSAJE DE SALIDA Y CORREGIR EL CAMBIO DE PANTALLA
      RespuestaDatosModel? respuesta = value;
      if (respuesta?.codigo == 10) {
        final funcionNavegar = () {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            Navigator.of(context).pushNamed('/MisPub');
          });
        };
        AlertUtil.success(context, respuesta!.mensaje!,
            respuesta: funcionNavegar, title: '¡Registro exitoso!');
      }
    }).whenComplete(() => setState(() => isLoadingTrueque = true));
  }
}

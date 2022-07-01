import 'package:Fe_mobile/src/core/models/respuesta_datos_model.dart';
import 'package:Fe_mobile/src/core/providers/general_provider.dart';
import 'package:Fe_mobile/src/core/util/alert_util.dart';
import 'package:Fe_mobile/src/core/util/currency_util.dart';
import 'package:Fe_mobile/src/core/util/helpers_util.dart';
import 'package:Fe_mobile/src/core/util/preferencias_util.dart';
import 'package:Fe_mobile/src/dominio/models/bancos_pse_model.dart';
import 'package:Fe_mobile/src/dominio/models/carrito_compras_model.dart';
import 'package:Fe_mobile/src/dominio/models/guardar_pedido_model.dart';
import 'package:Fe_mobile/src/dominio/models/guardar_producto_pedido_model.dart';
import 'package:Fe_mobile/src/dominio/models/pago_pse_model.dart';
import 'package:Fe_mobile/src/dominio/providers/factura_provider.dart';
import 'package:Fe_mobile/src/dominio/providers/pedidos_provider.dart';
import 'package:Fe_mobile/src/widgets/ShoppingCartButtonWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ListaBancosPage extends StatefulWidget {
  @override
  _ListaBancosPageWidgetState createState() => _ListaBancosPageWidgetState();
}

class _ListaBancosPageWidgetState extends State<ListaBancosPage> {
  final _prefs = new PreferenciasUtil();

  CarritoComprasModel _carrito = new CarritoComprasModel();
  GuardarPedidoModel _pedido = new GuardarPedidoModel();
  PagoPseModel _pagoPseModel = new PagoPseModel();

  GeneralProvider _generalProvider = new GeneralProvider();
  PedidoProvider _pedidoProvider = new PedidoProvider();
  FacturaProvider _facturaProvider = new FacturaProvider();

  List<BancosPseModel> _listaBancos = [];

  String? _bancoSeleccionado;

  bool cagrandoBancos = false;

  @override
  void initState() {
    super.initState();
    _getBancos();
  }

  _getBancos() async {
    setState(() {
      cagrandoBancos = false;
    });
    var lista = await _generalProvider.getBancos();
    setState(() {
      _listaBancos = lista;
      cagrandoBancos = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.keyboard_return_outlined,
              color: Theme.of(context).hintColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'PSE',
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
                          backgroundImage:
                              NetworkImage((Helpers.FOTO_USUARIO).toString()))
                      : CircleAvatar(
                          backgroundImage: AssetImage('img/user3.jpg'),
                        ))),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                leading: Icon(
                  Icons.corporate_fare_outlined,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  'Bancos disponibles',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline4,
                ),
                subtitle: Text(
                  'Seleccione su entidad bancaría',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
            ),
            cagrandoBancos
                ? Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _listaBancos.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _bancoSeleccionado = _listaBancos[index].nombre;

                                print("Banco seleccionado: " +
                                    _bancoSeleccionado!);
                              });
                            },
                            child: Container(
                              height: 50,
                              // color: Colors.amber[colorCodes[index]],
                              child: Center(
                                  child: Text('${_listaBancos[index].nombre}')),
                            ),
                          );
                        }))
                : CircularProgressIndicator(),
            SizedBox(height: 20),
            Positioned(
              bottom: 0,
              child: Container(
                height: 120,
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
                      _bancoSeleccionado != null
                          ? Text('Banco Seleccionado: ' + _bancoSeleccionado!)
                          : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),
                      Stack(
                        fit: StackFit.loose,
                        alignment: AlignmentDirectional.centerEnd,
                        children: <Widget>[
                          SizedBox(
                            width: 320,
                            child: FlatButton(
                              onPressed: () {
                                AlertUtil.confirm(
                                    context,
                                    '¿Desea confirmar compra?',
                                    () => _createLinkPse(),
                                    confirmBtnText: 'Confirmar');
                              },
                              padding: EdgeInsets.symmetric(vertical: 14),
                              color: Theme.of(context).accentColor,
                              shape: StadiumBorder(),
                              child: Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  'Confirmar Pago',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "${CurrencyUtil.convertFormatMoney('COP', _carrito.getTotalCheckOut())}",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .merge(TextStyle(
                                      color: Theme.of(context).primaryColor)),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createLinkPse() async {
    // Se crea la cabecera del pedido
    var idUsuario = await _prefs.getPrefStr("id");

    _pedido.id = 0;
    _pedido.idusuario = int.parse(idUsuario!);
    _pedido.estado = 'PEN';

    _pedidoProvider.crearPedido(_pedido, context).then((value) {
      var idPedido = value;
      var _productosAComprar = _carrito.returnCarrito();
      var _cantidadProductos = _carrito.returSizeCarrito();

      // Guardar Productos por pedido
      for (int i = 0; i < _cantidadProductos; i++) {
        var _productoPorPedido = new GuardarProductoPedidoModel();

        _productoPorPedido.id = 0;
        _productoPorPedido.idproductoservico = _productosAComprar[i].id;
        _productoPorPedido.idpedido = idPedido;
        _productoPorPedido.cantidadespedida =
            _productosAComprar[i].cantidadComprador;

        if (_productosAComprar[i].descuento! > 0.0) {
          _productoPorPedido.preciototal =
              ((_productosAComprar[i].preciounitario! -
                          ((_productosAComprar[i].descuento! / 100) *
                              _productosAComprar[i].preciounitario!)) *
                      _productosAComprar[i].cantidadComprador!)
                  .toInt();
        } else {
          _productoPorPedido.preciototal =
              _productosAComprar[i].preciounitario! *
                  _productosAComprar[i].cantidadComprador!;
        }
        print(_productoPorPedido.preciototal);

        _pedidoProvider
            .guardarProductoPedidoPorId(_productoPorPedido, context)
            .then((value) {
          RespuestaDatosModel? respuesta = value;
          print(respuesta!.mensaje);
        }).whenComplete(() => null);
      }

      if (_bancoSeleccionado != null) {
        _pagoPseModel.idDemografiaComprador = int.parse(idUsuario);
        _pagoPseModel.idPedido = idPedido;
        _pagoPseModel.banco = _bancoSeleccionado;

        _pagoPSE();
      } else {
        AlertUtil.error(context, "Seleccione un banco");
      }
    }).whenComplete(() => null);
  }

  void _pagoPSE() async {
    _facturaProvider.pagoConPSE(_pagoPseModel, context).then((value) {
      var respuesta = value;

      print(respuesta!.urlbanco!);
      // TODO queda pendiente darle permisos a IOS
      _launchURL(respuesta.urlbanco!);
    }).whenComplete(() => null);
  }

  void _launchURL(String url) async {
    await launch(url);
  }
}

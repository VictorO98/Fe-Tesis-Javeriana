import 'package:Fe_mobile/src/core/util/alert_util.dart';
import 'package:Fe_mobile/src/core/util/helpers_util.dart';
import 'package:Fe_mobile/src/core/util/preferencias_util.dart';
import 'package:Fe_mobile/src/dominio/models/carrito_compras_model.dart';
import 'package:Fe_mobile/src/dominio/models/guardar_favorito_model.dart';
import 'package:Fe_mobile/src/dominio/models/producto_servicio_model.dart';
import 'package:Fe_mobile/src/dominio/providers/contenido_provider.dart';
import 'package:Fe_mobile/src/models/route_argument.dart';
import 'package:Fe_mobile/src/widgets/DrawerWidget.dart';
import 'package:Fe_mobile/src/widgets/ProductDetailsTabWidget.dart';
import 'package:Fe_mobile/src/widgets/ProductHomeTabWidget.dart';
import 'package:Fe_mobile/src/widgets/ReviewsListWidget.dart';
import 'package:Fe_mobile/src/widgets/ShoppingCartButtonWidget.dart';
import 'package:flutter/material.dart';

class ProductoDetallePage extends StatefulWidget {
  RouteArgument? routeArgument;
  ProductoServicioModel? _product;
  String? _heroTag;

  ProductoDetallePage({Key? key, this.routeArgument}) {
    _product = this.routeArgument!.argumentsList![0] as ProductoServicioModel?;
    _heroTag = this.routeArgument!.argumentsList![1] as String?;
  }

  @override
  _ProductoDetallePageState createState() => _ProductoDetallePageState();
}

class _ProductoDetallePageState extends State<ProductoDetallePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  ContenidoProvider _contenidoProvider = new ContenidoProvider();

  GuardarPublicacionFavoritaModel guardarPublicacionFavorita =
      new GuardarPublicacionFavoritaModel();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _prefs = new PreferenciasUtil();
  final _carrito = CarritoComprasModel();

  int _tabIndex = 0;
  int _cantidadSeleccionada = 1;
  String? idUsuario;
  String? idRoleUsuario;

  bool _guardadoFavorito = false;

  @override
  void initState() {
    _tabController =
        TabController(length: 3, initialIndex: _tabIndex, vsync: this);
    _tabController!.addListener(_handleTabSelection);
    super.initState();
    _initialConfiguration();
  }

  _initialConfiguration() async {
    var idU = await _prefs.getPrefStr("id");
    var id = await _prefs.getPrefStr("roles");
    setState(() {
      idRoleUsuario = id!;
      idUsuario = idU!;
    });
  }

  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  _handleTabSelection() {
    if (_tabController!.indexIsChanging) {
      setState(() {
        _tabIndex = _tabController!.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).focusColor.withOpacity(0.15),
                blurRadius: 5,
                offset: Offset(0, -2)),
          ],
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: FlatButton(
                  onPressed: () {
                    // TODO: Falta quitar la repetidera de agregar multiples favoritos
                    guardarPublicacionFavorita.iddemografia =
                        int.parse(idUsuario!);
                    guardarPublicacionFavorita.idproductoservicio =
                        widget._product!.id!;
                    if (!_guardadoFavorito)
                      _guardarPublicacionFavorita(context);
                  },
                  padding: EdgeInsets.symmetric(vertical: 14),
                  color: Theme.of(context).accentColor,
                  shape: StadiumBorder(),
                  child: !_guardadoFavorito
                      ? Icon(
                          Icons.favorite_border_outlined,
                          color: Theme.of(context).primaryColor,
                        )
                      : Icon(
                          Icons.favorite,
                          color: Theme.of(context).primaryColor,
                        )),
            ),
            SizedBox(width: 10),
            FlatButton(
              onPressed: () {
                AlertUtil.success(context, 'Publicación añadida al carrito',
                    title: 'Felicidades!');
                setState(() {
                  _carrito.addElementCarrito(
                      widget._product!, _cantidadSeleccionada);
                  _carrito.printCarrito();
                });
              },
              color: Theme.of(context).accentColor,
              shape: StadiumBorder(),
              child: Container(
                width: 240,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Añadir al carrito',
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
//                          this.quantity = this.decrementQuantity(this.quantity);
                          if (_cantidadSeleccionada - 1 != 0)
                            _cantidadSeleccionada -= 1;
                        });
                      },
                      iconSize: 30,
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      icon: Icon(Icons.remove_circle_outline),
                      color: Theme.of(context).primaryColor,
                    ),
                    Text(_cantidadSeleccionada.toString(),
                        style: Theme.of(context).textTheme.subtitle1!.merge(
                            TextStyle(color: Theme.of(context).primaryColor))),
                    IconButton(
                      onPressed: () {
                        setState(() {
//                          this.quantity = this.incrementQuantity(this.quantity);
                          _cantidadSeleccionada += 1;
                        });
                      },
                      iconSize: 30,
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      icon: Icon(Icons.add_circle_outline),
                      color: Theme.of(context).primaryColor,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
//          snap: true,
          floating: true,
//          pinned: true,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon:
                new Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
            onPressed: () => Navigator.of(context).pop(),
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
          backgroundColor: Theme.of(context).primaryColor,
          expandedHeight: 350,
          elevation: 0,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: Hero(
              tag: widget._heroTag! + widget.routeArgument!.id.toString(),
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      image: DecorationImage(
                        image: NetworkImage(widget
                            ._product!.urlimagenproductoservicio
                            .toString()),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                          Theme.of(context).primaryColor,
                          Colors.white.withOpacity(0),
                          Colors.white.withOpacity(0),
                          Theme.of(context).scaffoldBackgroundColor
                        ],
                            stops: [
                          0,
                          0.4,
                          0.6,
                          1
                        ])),
                  ),
                ],
              ),
            ),
          ),
          bottom: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.label,
              labelPadding: EdgeInsets.symmetric(horizontal: 10),
              unselectedLabelColor: Theme.of(context).accentColor,
              labelColor: Theme.of(context).primaryColor,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Theme.of(context).accentColor),
              tabs: [
                Tab(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                            color:
                                Theme.of(context).accentColor.withOpacity(0.2),
                            width: 1)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Producto"),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                            color:
                                Theme.of(context).accentColor.withOpacity(0.2),
                            width: 1)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Detalle"),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                            color:
                                Theme.of(context).accentColor.withOpacity(0.2),
                            width: 1)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Reseñas"),
                    ),
                  ),
                ),
              ]),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Offstage(
              offstage: 0 != _tabIndex,
              child: Column(
                children: <Widget>[
                  ProductHomeTabWidget(product: widget._product),
                ],
              ),
            ),
            Offstage(
              offstage: 1 != _tabIndex,
              child: Column(
                children: <Widget>[
                  ProductDetailsTabWidget(
                    product: widget._product,
                  )
                ],
              ),
            ),
            Offstage(
              offstage: 2 != _tabIndex,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      leading: Icon(
                        Icons.message_outlined,
                        color: Theme.of(context).hintColor,
                      ),
                      title: Text(
                        'Reseñas del producto',
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                  ),
                  ReviewsListWidget()
                ],
              ),
            )
          ]),
        )
      ]),
    );
  }

  void _guardarPublicacionFavorita(BuildContext context) async {
    await _contenidoProvider
        .guardarPublicacionFavorita(guardarPublicacionFavorita, context)
        .then((value) {
      setState(() {
        _guardadoFavorito = true;
      });
    }).whenComplete(() => null);
  }
}

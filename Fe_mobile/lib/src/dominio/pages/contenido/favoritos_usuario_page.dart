import 'package:Fe_mobile/config/ui_icons.dart';
import 'package:Fe_mobile/src/core/models/info_usuario_model.dart';
import 'package:Fe_mobile/src/core/pages/usuario/bloc/info_perfil/info_usuario_bloc.dart';
import 'package:Fe_mobile/src/core/util/conf_api.dart';
import 'package:Fe_mobile/src/core/util/preferencias_util.dart';
import 'package:Fe_mobile/src/dominio/models/producto_servicio_model.dart';
import 'package:Fe_mobile/src/dominio/providers/contenido_provider.dart';
import 'package:Fe_mobile/src/models/product.dart';
import 'package:Fe_mobile/src/widgets/EmptyFavoritesWidget.dart';
import 'package:Fe_mobile/src/widgets/FavoriteListItemWidget.dart';
import 'package:Fe_mobile/src/widgets/ProductGridItemWidget.dart';
import 'package:Fe_mobile/src/widgets/SearchBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class FavoritosUsuarioPage extends StatefulWidget {
  @override
  _FavoritosUsuarioPageState createState() => _FavoritosUsuarioPageState();
}

class _FavoritosUsuarioPageState extends State<FavoritosUsuarioPage> {
  final _prefs = new PreferenciasUtil();
  String layout = 'list';

  List<ProductoServicioModel>? _productsList;

  InfoUsuarioBloc? _infoUsuarioBloc;
  ContenidoProvider _contenidoProvider = new ContenidoProvider();

  bool _cargandoUsuario = false;
  bool _cargandoProductosFavoritos = false;

  @override
  void initState() {
    super.initState();
    _infoUsuarioBloc = BlocProvider.of<InfoUsuarioBloc>(context);
    _cargarInfoUsuario();
    _productosFavoritos();
  }

  _productosFavoritos() async {
    _productsList = await _contenidoProvider.getPublicacionesFavoritas(
        _infoUsuarioBloc!.state.infoUsuarioModel!.id!);
    if (_productsList != null) {
      for (var i = 0; i < _productsList!.length; i++) {
        _productsList![i].urlimagenproductoservicio =
            "${ConfServer.SERVER}dominio/COContenido/GetImagenProdcuto?idPublicacion=${_productsList![i].id}";
      }
      setState(() {
        _cargandoProductosFavoritos = true;
      });
    }
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
      padding: EdgeInsets.symmetric(vertical: 10),
      child: _cargandoProductosFavoritos
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SearchBarWidget(),
                ),
                SizedBox(height: 10),
                Offstage(
                  offstage: _productsList!.isEmpty,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 10),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      leading: Icon(
                        Icons.favorite_border_outlined,
                        color: Theme.of(context).hintColor,
                      ),
                      title: Text(
                        'Lista de deseos',
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: Theme.of(context).textTheme.display1,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              setState(() {
                                this.layout = 'list';
                              });
                            },
                            icon: Icon(
                              Icons.format_list_bulleted,
                              color: this.layout == 'list'
                                  ? Theme.of(context).accentColor
                                  : Theme.of(context).focusColor,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                this.layout = 'grid';
                              });
                            },
                            icon: Icon(
                              Icons.apps,
                              color: this.layout == 'grid'
                                  ? Theme.of(context).accentColor
                                  : Theme.of(context).focusColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Offstage(
                  offstage: this.layout != 'list' || _productsList!.isEmpty,
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: _productsList!.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 10);
                    },
                    itemBuilder: (context, index) {
                      return FavoriteListItemWidget(
                        heroTag: 'favorites_list',
                        product: _productsList!.elementAt(index),
                        onDismissed: () {
                          setState(() {
                            _productsList!.removeAt(index);
                          });
                        },
                      );
                    },
                  ),
                ),
//                 Offstage(
//                   offstage: this.layout != 'grid' || _productsList!.isEmpty,
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 20),
//                     child: new StaggeredGridView.countBuilder(
//                       primary: false,
//                       shrinkWrap: true,
//                       crossAxisCount: 4,
//                       itemCount: _productsList!.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         ProductoServicioModel product =
//                             _productsList!.elementAt(index);
//                         return ProductGridItemWidget(
//                           product: product,
//                           heroTag: 'favorites_grid',
//                         );
//                       },
// //                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(index % 2 == 0 ? 1 : 2),
//                       staggeredTileBuilder: (int index) =>
//                           new StaggeredTile.fit(2),
//                       mainAxisSpacing: 15.0,
//                       crossAxisSpacing: 15.0,
//                     ),
//                   ),
//                 ),
                Offstage(
                  offstage: _productsList!.isNotEmpty,
                  child: EmptyFavoritesWidget(),
                )
              ],
            )
          : Container(
              alignment: Alignment.center, child: CircularProgressIndicator()),
    );
  }
}

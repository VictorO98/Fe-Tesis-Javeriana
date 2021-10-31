import 'package:Fe_mobile/config/ui_icons.dart';
import 'package:Fe_mobile/src/core/models/info_usuario_model.dart';
import 'package:Fe_mobile/src/core/pages/usuario/bloc/info_perfil/info_usuario_bloc.dart';
import 'package:Fe_mobile/src/core/util/conf_api.dart';
import 'package:Fe_mobile/src/core/util/preferencias_util.dart';
import 'package:Fe_mobile/src/dominio/models/producto_servicio_model.dart';
import 'package:Fe_mobile/src/dominio/providers/contenido_provider.dart';
import 'package:Fe_mobile/src/models/route_argument.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  SearchBarWidget({
    Key? key,
  }) : super(key: key);

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final globalKey = new GlobalKey<ScaffoldState>();

  List<ProductoServicioModel>? _listaFiltro;
  final _prefs = new PreferenciasUtil();
  InfoUsuarioBloc? _infoUsuarioBloc;

  TextEditingController busqueda = TextEditingController();
  ContenidoProvider _contenidoProvider = new ContenidoProvider();

  List<dynamic>? _list;
  bool? _isSearching;
  String _searchText = "";
  List searchresult = [];

  _SearchBarWidgetState() {
    busqueda.addListener(() {
      if (busqueda.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = busqueda.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _isSearching = false;
  }

  void values() async {
    var idUsuario = await _prefs.getPrefStr("id");
    _listaFiltro = await _contenidoProvider.busquedaProductosPorNombre(
        context, _searchText, idUsuario!);
    for (var i = 0; i < _listaFiltro!.length; i++) {
      _listaFiltro![i].urlimagenproductoservicio =
          "${ConfServer.SERVER}dominio/COContenido/GetImagenProdcuto?idPublicacion=${_listaFiltro![i].id}";
    }
    Navigator.of(context).pushNamed('/Busqueda',
        arguments: new RouteArgument(argumentsList: ['', _listaFiltro]));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).hintColor.withOpacity(0.10),
              offset: Offset(0, 4),
              blurRadius: 10)
        ],
      ),
      child: Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          TextField(
            controller: busqueda,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(12),
              hintText: 'Buscar',
              hintStyle: TextStyle(
                  color: Theme.of(context).focusColor.withOpacity(0.8)),
              prefixIcon: Icon(Icons.find_in_page_outlined,
                  size: 20, color: Theme.of(context).hintColor),
              border: UnderlineInputBorder(borderSide: BorderSide.none),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
          IconButton(
              onPressed: () {
                // Scaffold.of(context).openEndDrawer();
                values();
              },
              icon: _isSearching!
                  ? Icon(Icons.search,
                      size: 25,
                      color: Theme.of(context).hintColor.withOpacity(0.5))
                  : Icon(Icons.search_off,
                      size: 25,
                      color: Theme.of(context).hintColor.withOpacity(0.5))),
        ],
      ),
    );
  }
}

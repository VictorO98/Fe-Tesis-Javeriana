import 'package:Fe_mobile/config/ui_icons.dart';
import 'package:Fe_mobile/src/core/models/info_usuario_model.dart';
import 'package:Fe_mobile/src/core/pages/usuario/bloc/info_perfil/info_usuario_bloc.dart';
import 'package:Fe_mobile/src/core/util/conf_api.dart';
import 'package:Fe_mobile/src/core/util/estados_trueque_util.dart';
import 'package:Fe_mobile/src/core/util/preferencias_util.dart';
import 'package:Fe_mobile/src/dominio/models/info_trueques_model.dart';
import 'package:Fe_mobile/src/dominio/models/producto_servicio_model.dart';
import 'package:Fe_mobile/src/dominio/providers/contenido_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class SolicitudTruequeListaWidget extends StatefulWidget {
  String? heroTag;
  InfoTruequesModel? trueque;
  ProdSerTruequeTrue? detalle;
  VoidCallback? onDismissed;

  SolicitudTruequeListaWidget(
      {Key? key, this.heroTag, this.trueque, this.detalle, this.onDismissed})
      : super(key: key);

  @override
  _SolicitudTruequeListaState createState() => _SolicitudTruequeListaState();
}

class _SolicitudTruequeListaState extends State<SolicitudTruequeListaWidget> {
  final _prefs = new PreferenciasUtil();
  ContenidoProvider _contenidoProvider = new ContenidoProvider();

  ProductoServicioModel? _productoOfertado = new ProductoServicioModel();
  ProductoServicioModel? _productoDeseado = new ProductoServicioModel();

  InfoUsuarioBloc? _infoUsuarioBloc;

  String? _fechaOfertaTrueque;

  bool _cargandoUsuario = false;
  bool _cargandoInfo = false;

  @override
  void initState() {
    super.initState();
    _infoUsuarioBloc = BlocProvider.of<InfoUsuarioBloc>(context);
    _initialConfigurationUser();
    _initialConfiguration();
  }

  void _initialConfigurationUser() async {
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

  _initialConfiguration() async {
    var productoComprador =
        await _contenidoProvider.getPublicacionesPorIdPublicacion(
            widget.detalle!.idproductoserviciocomprador.toString());
    var productoVendedor =
        await _contenidoProvider.getPublicacionesPorIdPublicacion(
            widget.detalle!.idproductoserviciovendedor.toString());
    var fecha = DateTime(widget.trueque!.fechatrueque!.year,
        widget.trueque!.fechatrueque!.month, widget.trueque!.fechatrueque!.day);

    productoComprador!.urlimagenproductoservicio =
        "${ConfServer.SERVER}dominio/COContenido/GetImagenProdcuto?idPublicacion=${productoComprador.id}";

    productoVendedor!.urlimagenproductoservicio =
        "${ConfServer.SERVER}dominio/COContenido/GetImagenProdcuto?idPublicacion=${productoVendedor.id}";

    if (mounted)
      setState(() {
        _cargandoInfo = true;
        _fechaOfertaTrueque = fecha.toString();
        _productoOfertado = productoComprador;
        _productoDeseado = productoVendedor;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(this.widget.trueque.hashCode.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Icon(
              UiIcons.trash,
              color: Colors.white,
            ),
          ),
        ),
      ),
      onDismissed: (direction) {
        // Remove the item from the data source.
        setState(() {
          widget.onDismissed!();
        });

        // TODO: REVISAR ESTO PARA FUTURAS IMPLEMENTACIONES
        // Then show a snackbar.
        // Scaffold.of(context).showSnackBar(SnackBar(
        //     content: Text(
        //         "The ${widget.trueque!.product.name} order is removed from wish list")));
      },
      child: InkWell(
        splashColor: Theme.of(context).accentColor,
        focusColor: Theme.of(context).accentColor,
        highlightColor: Theme.of(context).primaryColor,
        child: _cargandoInfo
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.9),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).focusColor.withOpacity(0.1),
                        blurRadius: 5,
                        offset: Offset(0, 2)),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Hero(
                      tag: widget.heroTag! + widget.trueque!.id.toString(),
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          image: DecorationImage(
                            image: NetworkImage(_productoDeseado!
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  _productoDeseado!.nombre!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                SizedBox(height: 12),
                                Wrap(
                                  spacing: 10,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.date_range,
                                          color: Theme.of(context).focusColor,
                                          size: 20,
                                        ),
                                        SizedBox(width: 10),
                                        widget.trueque!.estado! ==
                                                EstadosTruequeUtil.ACEPTADO
                                            ? Text(
                                                'ACEPTADO',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2,
                                                overflow: TextOverflow.fade,
                                                softWrap: false,
                                              )
                                            : widget.trueque!.estado! ==
                                                    EstadosTruequeUtil.OFERTADO
                                                ? Text(
                                                    'OFERTADO',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2,
                                                    overflow: TextOverflow.fade,
                                                    softWrap: false,
                                                  )
                                                : widget.trueque!.estado! ==
                                                        EstadosTruequeUtil
                                                            .RECHAZADO
                                                    ? Text(
                                                        'RECHAZADO',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText2,
                                                        overflow:
                                                            TextOverflow.fade,
                                                        softWrap: false,
                                                      )
                                                    : Text(''),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.line_style,
                                          color: Theme.of(context).focusColor,
                                          size: 20,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Cantidad solicitada: ' +
                                              widget.detalle!.cantidadvendedor
                                                  .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                          overflow: TextOverflow.fade,
                                          softWrap: false,
                                        ),
                                      ],
                                    ),
                                  ],
//                            crossAxisAlignment: CrossAxisAlignment.center,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(_productoOfertado!.nombre!,
                                  style: Theme.of(context).textTheme.headline4),
                              SizedBox(height: 6),
                              Chip(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                backgroundColor: Colors.transparent,
                                shape: StadiumBorder(
                                    side: BorderSide(
                                        color: Theme.of(context).focusColor)),
                                label: Text(
                                  'x ${widget.detalle!.cantidadcomprador}',
                                  style: TextStyle(
                                      color: Theme.of(context).focusColor),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            : Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator()),
      ),
    );
  }
}

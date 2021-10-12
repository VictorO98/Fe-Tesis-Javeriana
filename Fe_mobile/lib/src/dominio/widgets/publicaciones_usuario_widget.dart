import 'package:Fe_mobile/config/ui_icons.dart';
import 'package:Fe_mobile/src/dominio/models/producto_servicio_model.dart';
import 'package:Fe_mobile/src/dominio/widgets/productos_usuario_widget.dart';
import 'package:Fe_mobile/src/models/order.dart';
import 'package:Fe_mobile/src/widgets/EmptyOrdersProductsWidget.dart';
import 'package:Fe_mobile/src/widgets/OrderGridItemWidget.dart';
import 'package:Fe_mobile/src/widgets/OrderListItemWidget.dart';
import 'package:Fe_mobile/src/widgets/ProductGridItemWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class PublicacionesUsuarioWidget extends StatefulWidget {
  List<ProductoServicioModel>? publicaciones;
  String? tipoPublicacion;

  @override
  _PublicacionesUsuarioWidgetState createState() =>
      _PublicacionesUsuarioWidgetState();

  PublicacionesUsuarioWidget(
      {Key? key, this.publicaciones, this.tipoPublicacion})
      : super(key: key);
}

class _PublicacionesUsuarioWidgetState
    extends State<PublicacionesUsuarioWidget> {
  String layout = 'list';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Offstage(
            offstage: widget.publicaciones!.isEmpty,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                leading: Icon(
                  Icons.all_inbox_outlined,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  widget.tipoPublicacion!,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: Theme.of(context).textTheme.headline4,
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
            offstage: this.layout != 'list' || widget.publicaciones!.isEmpty,
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemCount: widget.publicaciones!.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                return ProductoUsuarioListItemWidget(
                  heroTag: 'orders_list',
                  product: widget.publicaciones!.elementAt(index),
                  onDismissed: () {
                    setState(() {
                      widget.publicaciones!.removeAt(index);
                    });
                  },
                );
              },
            ),
          ),
          Offstage(
            offstage: this.layout != 'grid' || widget.publicaciones!.isEmpty,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: new StaggeredGridView.countBuilder(
                primary: false,
                shrinkWrap: true,
                crossAxisCount: 4,
                itemCount: widget.publicaciones!.length,
                itemBuilder: (BuildContext context, int index) {
                  ProductoServicioModel publicacion =
                      widget.publicaciones!.elementAt(index);
                  return ProductGridItemWidget(
                    product: publicacion,
                    heroTag: 'orders_grid',
                  );
                },
//                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(index % 2 == 0 ? 1 : 2),
                staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
                mainAxisSpacing: 15.0,
                crossAxisSpacing: 15.0,
              ),
            ),
          ),
          Offstage(
            offstage: widget.publicaciones!.isNotEmpty,
            child: EmptyOrdersProductsWidget(),
          )
        ],
      ),
    );
  }
}

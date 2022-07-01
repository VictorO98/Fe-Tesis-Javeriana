import 'package:Fe_mobile/config/ui_icons.dart';
import 'package:Fe_mobile/src/dominio/models/info_trueques_model.dart';
import 'package:Fe_mobile/src/dominio/widgets/solicitud_trueque_lista_widget.dart';
import 'package:Fe_mobile/src/dominio/widgets/trueque_grid_item_widget.dart';
import 'package:Fe_mobile/src/dominio/widgets/trueque_lista_item_widget.dart';
import 'package:Fe_mobile/src/dominio/widgets/vacio_trueque_widget.dart';
import 'package:Fe_mobile/src/models/order.dart';
import 'package:Fe_mobile/src/widgets/EmptyOrdersProductsWidget.dart';
import 'package:Fe_mobile/src/widgets/OrderGridItemWidget.dart';
import 'package:Fe_mobile/src/widgets/OrderListItemWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SolicitudTruequeDetalleWidget extends StatefulWidget {
  List<InfoTruequesModel>? infoTrueques;

  @override
  _SolicitudTruequeDetalleWidgetState createState() =>
      _SolicitudTruequeDetalleWidgetState();

  SolicitudTruequeDetalleWidget({Key? key, this.infoTrueques})
      : super(key: key);
}

class _SolicitudTruequeDetalleWidgetState
    extends State<SolicitudTruequeDetalleWidget> {
  String layout = 'list';

  @override
  void initState() {
    super.initState();
  }

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
            offstage: widget.infoTrueques!.isEmpty,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                leading: Icon(
                  Icons.inbox,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  'Mis intercambios',
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
            offstage: this.layout != 'list' || widget.infoTrueques!.isEmpty,
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemCount: widget.infoTrueques!.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                return SolicitudTruequeListaWidget(
                  heroTag: 'orders_list',
                  trueque: widget.infoTrueques!.elementAt(index),
                  detalle: widget.infoTrueques!
                      .elementAt(index)
                      .prodSerTruequeTrues!
                      .elementAt(0),
                  onDismissed: () {
                    setState(() {
                      widget.infoTrueques!.removeAt(index);
                    });
                  },
                );
              },
            ),
          ),
//           Offstage(
//             offstage: this.layout != 'grid' || widget.infoTrueques!.isEmpty,
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: new StaggeredGridView.countBuilder(
//                 primary: false,
//                 shrinkWrap: true,
//                 crossAxisCount: 4,
//                 itemCount: widget.infoTrueques!.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   InfoTruequesModel trueque =
//                       widget.infoTrueques!.elementAt(index);
//                   return TruequeGridItemWidget(
//                     trueque: trueque,
//                     heroTag: 'orders_grid',
//                   );
//                 },
// //                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(index % 2 == 0 ? 1 : 2),
//                 staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
//                 mainAxisSpacing: 15.0,
//                 crossAxisSpacing: 15.0,
//               ),
//             ),
//           ),
          Offstage(
            offstage: widget.infoTrueques!.isNotEmpty,
            child: VacioTruequesWidget(),
          )
        ],
      ),
    );
  }
}

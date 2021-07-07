import 'package:Fe_mobile/src/dominio/models/producto_servicio_model.dart';
import 'package:Fe_mobile/src/models/route_argument.dart';
import 'package:Fe_mobile/src/widgets/AvailableProgressBarWidget.dart';
import 'package:flutter/material.dart';

class FlashSalesCarouselItemWidget extends StatelessWidget {
  String? heroTag;
  double? marginLeft;
  ProductoServicioModel? product;

  FlashSalesCarouselItemWidget({
    Key? key,
    this.heroTag,
    this.marginLeft,
    this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/Product',
            arguments: new RouteArgument(
                id: product!.id, argumentsList: [product, heroTag]));
      },
      child: Container(
        margin: EdgeInsets.only(left: this.marginLeft!, right: 20),
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Hero(
              tag: heroTag! + product!.id.toString(),
              child: Container(
                width: 160,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  // image: DecorationImage(
                  //   fit: BoxFit.cover,
                  //   image: AssetImage(product!.urlimagenproductoservicio),
                  // ),
                ),
              ),
            ),
            Positioned(
              top: 6,
              right: 10,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: Theme.of(context).accentColor),
                alignment: AlignmentDirectional.topEnd,
                child: Text(
                  '${product!.descuento} %',
                  style: Theme.of(context)
                      .textTheme
                      .body2!
                      .merge(TextStyle(color: Theme.of(context).primaryColor)),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 170),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              width: 140,
              height: 113,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).hintColor.withOpacity(0.15),
                        offset: Offset(0, 3),
                        blurRadius: 10)
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    product!.nombre.toString(),
                    style: Theme.of(context).textTheme.body2,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                  Row(
                    children: <Widget>[
                      // The title of the product
                      Expanded(
                        child: Text(
                          '${product!.descuento} Sales',
                          style: Theme.of(context).textTheme.body1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 18,
                      ),
                      Text(
                        product!.calificacionpromedio.toString(),
                        style: Theme.of(context).textTheme.body2,
                      )
                    ],
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                  SizedBox(height: 7),
                  Text(
                    '${product!.cantidadtotal} Available',
                    style: Theme.of(context).textTheme.body1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AvailableProgressBarWidget(
                      available: product!.cantidadtotal!.toDouble())
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

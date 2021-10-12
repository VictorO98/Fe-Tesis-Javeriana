import 'package:Fe_mobile/src/core/util/currency_util.dart';
import 'package:Fe_mobile/src/dominio/models/producto_servicio_model.dart';
import 'package:Fe_mobile/src/models/product.dart';
import 'package:Fe_mobile/src/models/route_argument.dart';
import 'package:flutter/material.dart';

class ProductGridItemWidget extends StatelessWidget {
  const ProductGridItemWidget({
    Key? key,
    required this.product,
    required this.heroTag,
  }) : super(key: key);

  final ProductoServicioModel product;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      onTap: () {
        Navigator.of(context).pushNamed('/Product',
            arguments: new RouteArgument(
                argumentsList: [this.product, this.heroTag],
                id: this.product.id));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).hintColor.withOpacity(0.10),
                offset: Offset(0, 4),
                blurRadius: 10)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: this.heroTag + product.id.toString(),
              child: Container(
                height: height / 5,
                width: width / 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  image: DecorationImage(
                    image: NetworkImage(
                        product.urlimagenproductoservicio.toString()),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Text(
                product.nombre!,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                  "${CurrencyUtil.convertFormatMoney('COP', product.preciounitario!.round())}",
                  style: Theme.of(context).textTheme.headline4),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: <Widget>[
                  // The title of the product

                  Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 18,
                  ),
                  Text(
                    (product.calificacionpromedio! * 10).toString(),
                    style: Theme.of(context).textTheme.bodyText1,
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.center,
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}

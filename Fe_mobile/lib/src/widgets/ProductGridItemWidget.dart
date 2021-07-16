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
              child: Image.asset(product.urlimagenproductoservicio.toString()),
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Text(
                product.nombre!,
                style: Theme.of(context).textTheme.body2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                product.preciounitario.toString(),
                style: Theme.of(context).textTheme.title,
              ),
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
                    product.calificacionpromedio.toString(),
                    style: Theme.of(context).textTheme.body2,
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

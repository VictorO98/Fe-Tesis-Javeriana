import 'package:Fe_mobile/src/dominio/models/info_trueques_model.dart';
import 'package:Fe_mobile/src/models/order.dart';
import 'package:Fe_mobile/src/models/route_argument.dart';
import 'package:flutter/material.dart';

class TruequeGridItemWidget extends StatelessWidget {
  const TruequeGridItemWidget({
    Key? key,
    required this.trueque,
    required this.heroTag,
  }) : super(key: key);

  final InfoTruequesModel trueque;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      onTap: () {
        Navigator.of(context).pushNamed('/Order',
            arguments: new RouteArgument(
                argumentsList: [this.heroTag], id: this.trueque.id));
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
            // Hero(
            //   tag: this.heroTag + trueque.id,
            //   child: Image.asset(order.product.image),
            // ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Text(
                trueque.id.toString(),
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                trueque.id.toString(),
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: <Widget>[
                  // The title of the order
                  Expanded(
                    child: Text(
                      '${trueque.id.toString()} Sales',
                      style: Theme.of(context).textTheme.bodyText2,
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
                    trueque.id.toString(),
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

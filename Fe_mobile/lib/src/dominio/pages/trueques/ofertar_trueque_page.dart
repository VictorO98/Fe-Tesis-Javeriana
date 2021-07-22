import 'package:Fe_mobile/src/models/product.dart';
import 'package:Fe_mobile/src/widgets/CartItemWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OfertarTruequePage extends StatefulWidget {
  @override
  _OfertarTruequePageState createState() => _OfertarTruequePageState();
}

class _OfertarTruequePageState extends State<OfertarTruequePage>
    with SingleTickerProviderStateMixin {
  late ProductsList _productsList;

  @override
  void initState() {
    _productsList = new ProductsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Atrás',
          style: Theme.of(context).textTheme.display1,
        ),
        actions: <Widget>[
          Container(
              width: 30,
              height: 30,
              margin: EdgeInsets.only(top: 12.5, bottom: 12.5, right: 20),
              child: InkWell(
                borderRadius: BorderRadius.circular(300),
                onTap: () {
                  Navigator.of(context).pushNamed('/Tabs', arguments: 1);
                },
                child: CircleAvatar(
                  backgroundImage: AssetImage('img/user2.jpg'),
                ),
              )),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 150),
            padding: EdgeInsets.only(bottom: 15),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 10),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      leading: Icon(
                        Icons.change_circle_outlined,
                        color: Theme.of(context).hintColor,
                      ),
                      title: Text(
                        'Intercambio de productos',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.display1,
                      ),
                      subtitle: Text(
                        'Selecciona los productos para realizar el cambio',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 10),
                    child: Text("Mis productos",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                  ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: _productsList.cartList!.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 15);
                    },
                    itemBuilder: (context, index) {
                      return CartItemWidget(
                          product: _productsList.cartList!.elementAt(index),
                          heroTag: 'cart');
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 170,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).focusColor.withOpacity(0.15),
                        offset: Offset(0, -2),
                        blurRadius: 5.0)
                  ]),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(height: 10),
                    Stack(
                      fit: StackFit.loose,
                      alignment: AlignmentDirectional.centerEnd,
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 40,
                          child: FlatButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/Checkout');
                            },
                            padding: EdgeInsets.symmetric(vertical: 14),
                            color: Theme.of(context).accentColor,
                            shape: StadiumBorder(),
                            child: Text(
                              'Realizar Oferta',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

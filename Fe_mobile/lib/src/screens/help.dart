import 'package:Fe_mobile/src/widgets/DrawerWidget.dart';
import 'package:Fe_mobile/src/widgets/FaqItemWidget.dart';
import 'package:Fe_mobile/src/widgets/SearchBarWidget.dart';
import 'package:Fe_mobile/src/widgets/ShoppingCartButtonWidget.dart';
import 'package:flutter/material.dart';

class HelpWidget extends StatefulWidget {
  @override
  _HelpWidgetState createState() => _HelpWidgetState();
}

class _HelpWidgetState extends State<HelpWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: DrawerWidget(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
//        leading: new IconButton(
//          icon: new Icon(UiIcons.return_icon, color: Theme.of(context).hintColor),
//          onPressed: () => Navigator.of(context).pop(),
//        ),
          leading: new IconButton(
            icon: new Icon(Icons.sort, color: Theme.of(context).primaryColor),
            onPressed: () => _scaffoldKey.currentState!.openDrawer(),
          ),
          backgroundColor: Theme.of(context).accentColor,
          elevation: 0,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Productos'),
              Tab(text: 'Servicios'),
              Tab(text: 'Compras'),
              Tab(text: 'Devoluciones'),
            ],
            labelColor: Theme.of(context).primaryColor,
          ),
          title: Text(
            'Ayuda y Soporte',
            style: Theme.of(context)
                .textTheme
                .headline4!
                .merge(TextStyle(color: Theme.of(context).primaryColor)),
          ),
          actions: <Widget>[
            new ShoppingCartButtonWidget(
                iconColor: Theme.of(context).primaryColor,
                labelColor: Theme.of(context).hintColor),
          ],
        ),
        body: TabBarView(
          children: List.generate(4, (index) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    leading: Icon(
                      Icons.help,
                      color: Theme.of(context).hintColor,
                    ),
                    title: Text(
                      'Preguntas frecuentes',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: 1,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 15);
                    },
                    itemBuilder: (context, index) {
                      return FaqItemWidget(
                          index: index,
                          pregunta:
                              "¿Cómo puede subir mis productos o servicios?",
                          respuesta:
                              "Dirigite a la configuración de perfil y la sección de vender");
                    },
                  ),
                  ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: 1,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 15);
                    },
                    itemBuilder: (context, index) {
                      return FaqItemWidget(
                          index: index,
                          pregunta:
                              "¿ Que hago si no estoy de acuerdo con mi producto ?",
                          respuesta:
                              "Puedes realizar la devolución en tu sección de pedidos");
                    },
                  ),
                  ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: 1,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 15);
                    },
                    itemBuilder: (context, index) {
                      return FaqItemWidget(
                          index: index,
                          pregunta: "¿ Cómo reporto un producto ?",
                          respuesta:
                              "En la sección del producto lo puedes reportar");
                    },
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

import 'package:Fe_mobile/src/models/language.dart';
import 'package:Fe_mobile/src/widgets/DrawerWidget.dart';
import 'package:Fe_mobile/src/widgets/LanguageItemWidget.dart';
import 'package:Fe_mobile/src/widgets/SearchBarWidget.dart';
import 'package:Fe_mobile/src/widgets/ShoppingCartButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

class LanguagesWidget extends StatefulWidget {
  @override
  _LanguagesWidgetState createState() => _LanguagesWidgetState();
}

class _LanguagesWidgetState extends State<LanguagesWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late LanguagesList languagesList;
  @override
  void initState() {
    languagesList = new LanguagesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.keyboard_return,
              color: Theme.of(context).hintColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // leading: new IconButton(
        //   icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
        //   onPressed: () => _scaffoldKey.currentState.openDrawer(),
        // ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Languages',
          style: Theme.of(context).textTheme.display1,
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor),
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
                  backgroundImage: AssetImage('img/user3.jpg'),
                ),
              )),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: StickyHeader(
          header: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SearchBarWidget(),
          ),
          content: Column(
            children: <Widget>[
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(
                    Icons.translate,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    'App Language',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.display1,
                  ),
                ),
              ),
              SizedBox(height: 10),
              ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemCount: languagesList.languages!.length,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10);
                },
                itemBuilder: (context, index) {
                  return LanguageItemWidget(
                      language: languagesList.languages!.elementAt(index));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:Fe_mobile/src/dominio/models/producto_servicio_model.dart';
import 'package:Fe_mobile/src/models/category.dart';
import 'package:flutter/material.dart';

class CategoryIconWidget extends StatefulWidget {
  ProductoServicioModel? producto;
  String? heroTag;
  double? marginLeft;
  ValueChanged<String>? onPressed;

  CategoryIconWidget(
      {Key? key, this.producto, this.heroTag, this.marginLeft, this.onPressed})
      : super(key: key);

  @override
  _CategoryIconWidgetState createState() => _CategoryIconWidgetState();
}

class _CategoryIconWidgetState extends State<CategoryIconWidget>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0),
      margin: EdgeInsets.only(left: widget.marginLeft!, top: 10, bottom: 10),
      child: buildSelectedCategory(context),
    );
  }

  InkWell buildSelectedCategory(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).accentColor,
      onTap: () {
        // setState(() {
        //   widget.onPressed!(widget.producto!.id);
        // });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: true ? Theme.of(context).primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          children: <Widget>[
            Hero(
              tag: widget.heroTag! + widget.producto!.id.toString(),
              child: Icon(
                Icons.ac_unit,
                color: true
                    ? Theme.of(context).accentColor
                    : Theme.of(context).primaryColor,
                size: 32,
              ),
            ),
            SizedBox(width: 10),
            AnimatedSize(
              duration: Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              vsync: this,
              // child: Text(
              //   widget.producto!.selected ? widget.producto!.name : '',
              //   style: TextStyle(
              //       fontSize: 14, color: Theme.of(context).accentColor),
              // ),
            )
          ],
        ),
      ),
    );
  }
}

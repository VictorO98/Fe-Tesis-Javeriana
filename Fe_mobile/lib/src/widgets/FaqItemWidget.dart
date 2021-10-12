import 'package:flutter/material.dart';

class FaqItemWidget extends StatelessWidget {
  String? pregunta;
  String? respuesta;
  FaqItemWidget({Key? key, this.index = 1, this.pregunta, this.respuesta})
      : super(key: key);
  final index;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Theme.of(context).hintColor.withOpacity(0.1),
          offset: Offset(0, 5),
          blurRadius: 15,
        )
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5))),
            child: Text(
              pregunta!,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .merge(TextStyle(color: Theme.of(context).primaryColor)),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    bottomLeft: Radius.circular(5))),
            child: Text(
              respuesta!,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ],
      ),
    );
  }
}

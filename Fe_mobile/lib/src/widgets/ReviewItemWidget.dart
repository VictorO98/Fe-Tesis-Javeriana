import 'package:Fe_mobile/config/ui_icons.dart';
import 'package:Fe_mobile/src/models/review.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ReviewItemWidget extends StatelessWidget {
  Review? review;

  ReviewItemWidget({Key? key, this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      runSpacing: 10,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Container(
            //   height: 60,
            //   width: 60,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.all(Radius.circular(100)),
            //     image: DecorationImage(
            //         image: AssetImage(this.review!.user.avatar!),
            //         fit: BoxFit.cover),
            //   ),
            // ),
            SizedBox(width: 15),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              review!.user.name!,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              maxLines: 2,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .merge(TextStyle(
                                      color: Theme.of(context).hintColor)),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.calendar_today_outlined,
                                  color: Theme.of(context).focusColor,
                                  size: 20,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  '2021-07-15',
                                  style: Theme.of(context).textTheme.caption,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                ),
                              ],
                            ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                      Chip(
                        padding: EdgeInsets.all(0),
                        label: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(review!.rate.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .merge(TextStyle(
                                        color:
                                            Theme.of(context).primaryColor))),
                            Icon(
                              Icons.star_border,
                              color: Theme.of(context).primaryColor,
                              size: 16,
                            ),
                          ],
                        ),
                        backgroundColor:
                            Theme.of(context).accentColor.withOpacity(0.9),
                        shape: StadiumBorder(),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        Text(
          review!.review,
          style: Theme.of(context).textTheme.bodyText2,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          maxLines: 3,
        )
      ],
    );
  }
}

import 'package:Fe_mobile/src/models/conversation.dart' as model;
import 'package:Fe_mobile/src/widgets/EmptyMessagesWidget.dart';
import 'package:Fe_mobile/src/widgets/MessageItemWidget.dart';
import 'package:Fe_mobile/src/widgets/SearchBarWidget.dart';
import 'package:flutter/material.dart';

class MessagesWidget extends StatefulWidget {
  @override
  _MessagesWidgetState createState() => _MessagesWidgetState();
}

class _MessagesWidgetState extends State<MessagesWidget> {
  late model.ConversationsList _conversationList;
  @override
  void initState() {
    this._conversationList = new model.ConversationsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Estamos trabajando para mejorar tu experiencia',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22),
        ),
        Image(image: AssetImage('img/Trabajando.png'))
      ],
    );
    // return SingleChildScrollView(
    //   padding: EdgeInsets.symmetric(vertical: 7),
    //   child: Column(
    //     children: <Widget>[
    //       Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 20),
    //         child: SearchBarWidget(),
    //       ),
    //       Offstage(
    //         offstage: _conversationList.conversations!.isEmpty,
    //         child: ListView.separated(
    //           padding: EdgeInsets.symmetric(vertical: 15),
    //           shrinkWrap: true,
    //           primary: false,
    //           itemCount: _conversationList.conversations!.length,
    //           separatorBuilder: (context, index) {
    //             return SizedBox(height: 7);
    //           },
    //           itemBuilder: (context, index) {
    //             return MessageItemWidget(
    //               message: _conversationList.conversations!.elementAt(index),
    //               onDismissed: (conversation) {
    //                 setState(() {
    //                   _conversationList.conversations!.removeAt(index);
    //                 });
    //               },
    //             );
    //           },
    //         ),
    //       ),
    //       Offstage(
    //         offstage: _conversationList.conversations!.isNotEmpty,
    //         child: EmptyMessagesWidget(),
    //       )
    //     ],
    //   ),
    // );
  }
}

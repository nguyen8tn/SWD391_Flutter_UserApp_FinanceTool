import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swd/models/pushMessageItem.dart';
import 'package:swd/pages/bank_list_page.dart';
import 'package:swd/viewmodels/BankListViewModel.dart';

class MessagingWidget extends StatefulWidget {
  @override
  _MessagingWidgetState createState() => _MessagingWidgetState();
}

class _MessagingWidgetState extends State<MessagingWidget> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<PushMessageItem> messages = [];

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];
        setState(() {
          messages.add(PushMessageItem(
              title: notification['title'], body: notification['body']));
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        final notification = message['data'];
        setState(() {
          messages.add(PushMessageItem(
            title: '${notification['title']}',
            body: '${notification['body']}',
          ));
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: messages.map(buildMessage).toList(),
            ),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return ChangeNotifierProvider(
                  create: (context) => BankListViewModel(),
                  child: BankListPage(),
                );
                },
              ));
            },
            padding: EdgeInsets.all(20.0),
            child: Text('Go to Bank List'),
          )
        ],
      ),
    );
  }

  Widget buildMessage(PushMessageItem message) => ListTile(
        title: Text(message.title),
        subtitle: Text(message.body),
      );
}

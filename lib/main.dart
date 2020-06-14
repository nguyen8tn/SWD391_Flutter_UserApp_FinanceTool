import 'package:flutter/material.dart';
import 'package:swd/pages/login_page.dart';
import 'package:swd/widgets/message_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "DEMO LOGIN Google",
      home: LoginPage(),
    );
  }

}

class MainPage extends StatelessWidget {
  final String appTitle;

  const MainPage({this.appTitle});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: MessagingWidget(),
      );
}


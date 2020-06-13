import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:swd/widgets/message_widget.dart';
import 'login_page.dart';

void main() => runApp(MyApp());

//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: "Tile",
//      home: Scaffold(
//        appBar: AppBar(
//          title: Text("Welcome"),
//        ),
//        body: Center(
//          child: Text("Hello"),
//        ),
//      ),
//    );
//  }
//}
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


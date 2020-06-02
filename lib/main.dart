import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
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

class RandomState extends State<Random> {
  @override
  Widget build(BuildContext context) {
    final rd = WordPair.random();
    return MaterialApp (
      title: "TXT",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Welcome"),
        ),
        body: Center(
          child: Text(rd.asPascalCase),
        ),
      ),
    );
  }
}
class Random extends StatefulWidget {
  @override
  State createState() {
    return RandomState();
  }
}

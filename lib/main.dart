import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swd/pages/gross_net_page.dart';
import 'viewmodels/GrossNetCalculationViewModel.dart';
import 'package:swd/widgets/message_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Financial Service",
      home: ChangeNotifierProvider(
        create: (context) => GrossNetCalculationViewModel(),
        child: GrossNetConvertionPage(),
      ),
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

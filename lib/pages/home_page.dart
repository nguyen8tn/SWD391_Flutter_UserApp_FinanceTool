import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swd/pages/account_page.dart';
import 'package:swd/pages/calculator_menu.dart';
import 'package:swd/pages/gross_net_page.dart';
import 'package:swd/pages/saving_account_page.dart';
import 'package:swd/viewmodels/AccountDetailViewModel.dart';
import 'package:swd/viewmodels/AccountListViewModel.dart';
import 'package:swd/viewmodels/CalculationViewModel.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => _HomePageSate();
}

class _HomePageSate extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    ChangeNotifierProvider(
      create: (context) => AccountListViewModel(),
      child: AccountPage(),
    ),
    CalculatorMenuPage(),
    ChangeNotifierProvider(
      create: (context) => CalculationViewModel(),
      child: GrossNetConvertionPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Color(0xFF1BC0C5),
          selectedFontSize: 15,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box),
              title: Text('Account'),
              backgroundColor: Color(0xFF1BC0C5),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.border_color),
              title: Text('Caculator'),
              backgroundColor: Color(0xFF1BC0C5),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box),
              title: Text('User'),
              backgroundColor: Color(0xFF1BC0C5),
            )
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}

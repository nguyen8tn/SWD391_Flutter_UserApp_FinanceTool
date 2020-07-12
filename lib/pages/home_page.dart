import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swd/pages/account_page.dart';
import 'package:swd/pages/saving_account_page.dart';

import 'calculator_menu.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => _HomePageSate();
}

class _HomePageSate extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    AccountPage(),
    SavingAccountPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 15,
        unselectedFontSize: 11,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            title: Text('Account'),
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.border_color),
            title: Text('Caculator'),
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            title: Text('User'),
            backgroundColor: Colors.blue,
          )
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

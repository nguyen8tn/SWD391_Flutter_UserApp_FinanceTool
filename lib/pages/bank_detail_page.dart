import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BankDetailPage extends StatefulWidget {
  @override
  _BankDetailPageState createState() => _BankDetailPageState();
}

class _BankDetailPageState extends State<BankDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 2,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.attach_money),
                    title: TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Nhập số';
                          }
                          return null;
                        },
                        decoration: InputDecoration(hintText: 'VNĐ')),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

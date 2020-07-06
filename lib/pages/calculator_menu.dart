import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swd/models/caculation.dart';

class CalculatorMenuPage extends StatefulWidget {
  @override
  State createState() => _CalculatorMenuPageState();
}

class _CalculatorMenuPageState extends State<CalculatorMenuPage> {
  final List<BaseFormula> items = List<BaseFormula>.generate(
      5, (index) => (new BaseFormula(id: 1, name: '123', formula: 'asd')));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Center(
          child: Text('Caculator'),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return optionBtn(index);
                })
          ],
        ),
      ),
    );
  }

  Widget optionBtn(int index) {
    return OutlineButton(
        //onPressed: ,
        child: Text(items[index].formula));
  }
}

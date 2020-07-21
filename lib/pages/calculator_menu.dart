import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swd/models/Caculation.dart';

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
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.all(15),
              sliver: SliverGrid.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: List.generate(items.length, (index) {
                  return formulaItem(index);
                }),
              ),
            )
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

  Widget formulaItem(int index) {
    return Container(
      child: Column(
        children: [
            Icon(Icons.account_balance_wallet),
            Text(items[index].name)
        ],
      ),
    );
  }
}

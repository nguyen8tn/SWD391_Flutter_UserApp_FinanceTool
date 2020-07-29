import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swd/models/Caculation.dart';
import 'package:swd/pages/base_formula_details.dart';
import 'package:swd/services/calculation_http_request.dart';
import 'package:swd/viewmodels/CalculationViewModel.dart';
import 'package:toast/toast.dart';

class CalculatorMenuPage extends StatefulWidget {
  @override
  State createState() => _CalculatorMenuPageState();
}

class _CalculatorMenuPageState extends State<CalculatorMenuPage> {
  List<BaseFormula> _items;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh Sách Công Thức"),
      ),
      body: FutureBuilder<List<BaseFormula>>(
        future: HttpRequestC().getAllBaseFormula(),
        builder: (context, AsyncSnapshot<List<BaseFormula>> snapshot) {
          if (snapshot.hasData) {
            _items = snapshot.data;
            return Container(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverPadding(
                    padding: const EdgeInsets.all(15),
                    sliver: SliverGrid.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: List.generate(_items.length, (index) {
                        return formulaItem(index);
                      }),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Padding(
              padding: EdgeInsets.all(100),
              child: Container(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget formulaItem(int index) {
    return Container(
      child: InkWell(
        onTap: () async {
          HttpRequestC().pushOperand(_items[index].id).then((value) {
            if (value != null) {
              print(value);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                        create: (context) => CalculationViewModel(),
                        child: BaseFormulaDetails(
                            baseID: _items[index].id, listInputOperand: value),
                      )));
            }
          }).catchError((e) {
            Toast.show("Lỗi khi thực hiện yêu cầu", context);
          });
        },
        child: Column(
          children: [
            Icon(Icons.account_balance_wallet),
            Text(_items[index].name)
          ],
        ),
      ),
    );
  }
}

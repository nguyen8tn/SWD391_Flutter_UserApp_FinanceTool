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
        leading: Container(),
        backgroundColor: Color(0xFF1BC0C5),
        title: Text("Danh Sách Công Thức"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<BaseFormula>>(
        future: HttpRequestC().getAllBaseFormula(),
        builder: (context, AsyncSnapshot<List<BaseFormula>> snapshot) {
          if (snapshot.hasData) {
            _items = snapshot.data;
            return Container(
                child: GridView.builder(
              itemCount: 3,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, index) {
                return formulaItem(index);
              },
            ));
          } else {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                  40, (MediaQuery.of(context).size.height - 500) / 2, 20, 20),
              child: Center(
                child: Container(
                  child: CircularProgressIndicator(
                      strokeWidth: 5,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF1BC0C5))),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget formulaItem(int index) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Card(
        color: Colors.transparent,
        shadowColor: Colors.grey,
        elevation: 10,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xFF1BC0C5).withOpacity(0.7),
          ),
          child: InkWell(
            onTap: () async {
              HttpRequestC().pushOperand(_items[index].id).then((value) {
                if (value != null) {
                  print(value);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                            create: (context) => CalculationViewModel(),
                            child: BaseFormulaDetails(
                                baseID: _items[index].id,
                                listInputOperand: value),
                          )));
                }
              }).catchError((e) {
                Toast.show("Lỗi khi thực hiện yêu cầu", context);
              });
            },
            child: GridTile(
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Center(
                      child: Icon(
                        Icons.account_balance_wallet,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Text(
                        _items[index].name,
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

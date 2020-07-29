import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swd/models/Operand.dart';
import 'package:swd/viewmodels/CalculationViewModel.dart';
import 'package:toast/toast.dart';

class BaseFormulaDetails extends StatefulWidget {
  final List<Operand> listInputOperand;
  final int baseID;
  BaseFormulaDetails(
      {Key key, @required this.listInputOperand, @required this.baseID})
      : super(key: key);
  @override
  _BaseFormulaDetailsState createState() => _BaseFormulaDetailsState();
}

class _BaseFormulaDetailsState extends State<BaseFormulaDetails> {
  List<Operand> listInputOperand;
  int baseID;
  List<Operand> listResult;
  TextEditingController txtResult = TextEditingController();
  bool hasData = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    baseID = widget.baseID;
    listInputOperand = widget.listInputOperand;
  }

  @override
  Widget build(BuildContext context) {
    List<TextEditingController> _controllers = new List();
    final vm = Provider.of<CalculationViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Chi Tiết Công Thức"),
        centerTitle: true,
      ),
      body: FutureBuilder<bool>(
        future: vm.getAllOperantByFormulaID(baseID),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: getListTiles(_controllers, vm),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(flex: 2, child: Text("Kết Quả: ")),
                              Expanded(
                                flex: 8,
                                child: AbsorbPointer(
                                  child: TextField(
                                    controller: txtResult,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ),
                              Text(" ")
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          RaisedButton(
                              onPressed: () async {
                                for (var i = 0;
                                    i < listInputOperand.length;
                                    i++) {
                                  listInputOperand.elementAt(i).value =
                                      double.parse(
                                          _controllers.elementAt(i).text);
                                }
                                var t = await vm.calculateFormula(
                                    listInputOperand, baseID);
                                if (t) {
                                  setState(() {
                                    listResult = vm.result.values.elementAt(0);
                                    hasData = true;
                                    txtResult.text =
                                        vm.result.keys.elementAt(0).toString();
                                  });
                                } else {
                                  setState(() {
                                    Toast.show("Không Thực Hiện Được", context);
                                  });
                                }
                              },
                              child: Container(
                                width: 100,
                                height: 20,
                                child: Center(
                                    child: Text(
                                  "Tính Toán",
                                  style: TextStyle(fontSize: 20),
                                )),
                              )),
                        ],
                      ),
                    ),
                  ),
                  //if is finish calculated
                  hasData == true
                      ? Expanded(
                          child: Flexible(
                          child: SingleChildScrollView(
                            child: DataTable(
                              rows: listResult
                                  .map((operand) => DataRow(cells: <DataCell>[
                                        DataCell(Text(operand.desc)),
                                        DataCell(Text(operand.value.toString()))
                                      ]))
                                  .toList(),
                              columns: [
                                DataColumn(label: Text('Giá Trị')),
                                DataColumn(label: Text('Kết Quả'))
                              ],
                            ),
                          ),
                        ))
                      : Container()
                ],
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget getListTiles(
      List<TextEditingController> _controllers, CalculationViewModel vm) {
    return ListView.builder(
      itemCount: vm.operants.length,
      itemBuilder: (context, index) {
        _controllers.add(new TextEditingController());
        return Card(
          child: ListTile(
            leading: Icon(Icons.mode_edit),
            //leading: Icon(Icons.monetization_on),
            title: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controllers[index],
                    decoration: InputDecoration(
                        hintText: vm.operants.elementAt(index).desc),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swd/viewmodels/CalculationViewModel.dart';

class GrossNetConvertionPage extends StatefulWidget {
  @override
  _GrossNetConvertionState createState() => _GrossNetConvertionState();
}

class _GrossNetConvertionState extends State<GrossNetConvertionPage> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CalculationViewModel>(context, listen: false);

    List<TextEditingController> _controllers = new List();
    TextEditingController txtResult = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("GROSS TO NET CALCULATOR"),
        centerTitle: true,
      ),
      body: FutureBuilder<bool>(
        future: vm.getAllOperantByFormulaID(1),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            //var title = vm.baseFormulas.first.formula.split("-");
            return Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: getListTiles(_controllers, vm),
                    flex: 8,
                  ),
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(flex: 2, child: Text("Salary: ")),
                              Expanded(
                                flex: 8,
                                child: TextField(
                                  controller: txtResult,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Text("VND")
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          RaisedButton(
                              onPressed: () {},
                              child: Container(
                                width: 200,
                                height: 48,
                                child: Center(
                                    child: Text(
                                  "Submit",
                                  style: TextStyle(fontSize: 20),
                                )),
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
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
        if (index == 0) {
          return Card(
            child: ListTile(
              //leading: Icon(Icons.monetization_on),
              title: Row(
                children: <Widget>[
                  Expanded(flex: 2, child: Text("Lương: ")),
                  Expanded(
                    flex: 8,
                    child: TextField(
                      controller: _controllers[index],
                      decoration: InputDecoration(hintText: 'Lương Trước Thuế'),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              trailing: Text("VNĐ"),
            ),
          );
        } else {
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
        }
      },
    );
  }
}

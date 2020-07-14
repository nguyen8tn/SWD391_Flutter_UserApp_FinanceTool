import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swd/viewmodels/GrossNetCalculationViewModel.dart';

class GrossNetConvertionPage extends StatefulWidget {
  @override
  _GrossNetConvertionState createState() => _GrossNetConvertionState();
}

class _GrossNetConvertionState extends State<GrossNetConvertionPage> {
  @override
  Widget build(BuildContext context) {
    final vm =
        Provider.of<GrossNetCalculationViewModel>(context, listen: false);

    List<TextEditingController> _controllers = new List();
    TextEditingController txtResult = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("GROSS TO NET CALCULATOR"),
        centerTitle: true,
      ),
      body: FutureBuilder<bool>(
        future: vm.getAllFormulas(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            var title = vm.baseFormulas.first.formula.split("-");
            return Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: getListTiles(_controllers, []),
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
      List<TextEditingController> _controllers, List<String> titles) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        _controllers.add(new TextEditingController());
        if (index == 0) {
          return Card(
            child: ListTile(
              //leading: Icon(Icons.monetization_on),
              title: Row(
                children: <Widget>[
                  Expanded(flex: 2, child: Text("Salary: ")),
                  Expanded(
                    flex: 8,
                    child: TextField(
                      controller: _controllers[index],
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              trailing: Text("VND"),
            ),
          );
        } else {
          return Card(
            child: ListTile(
              //leading: Icon(Icons.monetization_on),
              title: Row(
                children: <Widget>[
                  Expanded(flex: 2, child: Text("Salary: ")),
                  Expanded(
                    flex: 8,
                    child: TextField(
                      controller: _controllers[index],
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

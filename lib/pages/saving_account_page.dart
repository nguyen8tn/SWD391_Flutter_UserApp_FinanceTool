import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swd/models/SavingAccount.dart';
import 'package:swd/services/calculation_http_request.dart';
import 'package:toast/toast.dart';

class SavingAccountPage extends StatefulWidget {
  @override
  _SavingAccountPageState createState() => _SavingAccountPageState();
}

class _SavingAccountPageState extends State<SavingAccountPage> {
  String _account;
  double _interestRate, _freeRate, _amount;
  DateTime _startDate;
  int _term, _calculateDate, _bankID;

  String title = "Create Saving Account";
  TextEditingController _accountController = new TextEditingController();
  TextEditingController _amountController = new TextEditingController();
  TextEditingController _startDateController = new TextEditingController();
  TextEditingController _endDateController = new TextEditingController();
  TextEditingController _termController = new TextEditingController();
  TextEditingController _interestRateController =
      new TextEditingController(text: '0.0');
  TextEditingController _freeInterestRateController =
      new TextEditingController(text: '0.0');
  TextEditingController _numberDateController =
      new TextEditingController(text: '365');
  int termDate;
  DateTime _dateTime = DateTime.now();

  _selectStartDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (_pickedDate != null) {
      setState(() {
        _dateTime = _pickedDate;
        _startDateController.text = DateFormat("dd/MM/yyyy").format(_dateTime);
      });
    }
  }

  void saveData() {
    SavingAccount account = SavingAccount.sa(0, _bankID, "", _account, _amount,
        _startDate, _term, _interestRate, _freeRate, _calculateDate);
    HttpRequestC().addSavingAccount(account);
  }

  _calculateEndDate(BuildContext context) async {}

  _selectTerm(BuildContext context) {}

  @override
  void initState() {
    super.initState();
    _accountController.addListener(() {
      Toast.show(_accountController.text, context);
      _account = _accountController.text;
    });

    _amountController.addListener(() {
      Toast.show(_accountController.text, context);
      _amount = double.parse(_amountController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        title: Text(title ?? 'Create Saving Account'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 2,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.attach_money),
                      title: TextField(
                          controller: _amountController,
                          decoration: InputDecoration(hintText: 'Amount')),
                    )
                  ],
                ),
              ),
              Card(
                elevation: 2,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.account_balance_wallet),
                      title: TextField(
                        controller: _accountController,
                        decoration: InputDecoration(hintText: 'Account name'),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.title),
                      title: TextField(
                        decoration: InputDecoration(
                            hintText: 'Bank', border: InputBorder.none),
                      ),
                      trailing: Icon(Icons.arrow_forward),
                    )
                  ],
                ),
              ),
              Card(
                elevation: 2,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.calendar_today),
                      title: TextField(
                        controller: _startDateController,
                        onTap: () {
                          _selectStartDate(context);
                        },
                        decoration: InputDecoration(
                          labelText: 'Start date',
                          hintText: 'dd/MM/yyyy',
                        ),
                        readOnly: true,
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.date_range),
                      title: TextField(
                        controller: _termController,
                        decoration: InputDecoration(
                            labelText: 'Term', hintText: 'month'),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.calendar_today),
                      title: TextField(
                        controller: _endDateController,
                        decoration: InputDecoration(
                          labelText: 'End date',
                          hintText: 'dd/MM/yyyy',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Text(" Interest reate: "),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: _interestRateController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: '0.0',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 20)),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(' %'),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Text(" Free interrest rate: "),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: _freeInterestRateController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: '0.0',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 20)),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(' %'),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Text(" Number for calculate: "),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: _numberDateController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: '365',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 18)),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(' days'),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  const SizedBox(height: 30),
                  RaisedButton(
                    onPressed: () {
                      saveData();
                    },
                    child: Text('Save'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

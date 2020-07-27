import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swd/models/Bank.dart';
import 'package:swd/models/SavingAccount.dart';
import 'package:swd/services/calculation_http_request.dart';

import 'package:swd/viewmodels/SavingAccountViewModel.dart';
import 'package:toast/toast.dart';

class SavingAccountPage extends StatefulWidget {
  List<Bank> banks = [];
  bool isUpdate;
  int id;
  SavingAccountPage({@required this.isUpdate, int id});

  @override
  _SavingAccountPageState createState() => _SavingAccountPageState();
}

class _SavingAccountPageState extends State<SavingAccountPage> {
  List<String> bankNames = <String>[];
  DateTime _startDate = DateTime.now();
  BankDetail selectedBank;
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  String title = "Create Saving Account";
  TextEditingController _bankController = new TextEditingController();
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
  DateFormat _dateFormat = DateFormat('dd-MM-yyyy');

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SavingAccountViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        title: Text(title ?? 'Create Saving Account'),
      ),
      body: ProgressHUD(
        child: Builder(builder: (context) {
          final progress = ProgressHUD.of(context);
          void saveData() async {
            progress.show();
            final prefs = await SharedPreferences.getInstance();
            if (_formKey.currentState.validate()) {
              SavingAccount account = SavingAccount.sa(
                  0,
                  int.parse(_bankController.text.split(' - ').elementAt(0)),
                  prefs.getString('UID'),
                  _accountController.text,
                  double.parse(_amountController.text),
                  DateTime.parse(_startDate.toIso8601String()),
                  int.parse(_termController.text),
                  double.parse(_interestRateController.text),
                  double.parse(_freeInterestRateController.text),
                  int.parse(_numberDateController.text));
              var resutl = await HttpRequestC().addSavingAccount(account);
              if (resutl != null) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Add Success'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Close'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  },
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Add Failed'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Close'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  },
                );
              }
            }
            progress.dismiss();
          }

          return Form(
            autovalidate: _autoValidate,
            key: _formKey,
            child: Container(
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
                                    return 'Enter a number';
                                  }
                                  return '';
                                },
                                controller: _amountController,
                                decoration:
                                    InputDecoration(hintText: 'Amount')),
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
                            title: TextFormField(
                              controller: _accountController,
                              decoration:
                                  InputDecoration(hintText: 'Account name'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Name must not be blanked';
                                }
                                return '';
                              },
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              progress.show();
                              await vm.fetchBanks();
                              bankNames.clear();
                              for (var item in vm.banks) {
                                bankNames.add(item.bankID.toString() +
                                    " - " +
                                    item.bankName);
                              }
                              showMaterialSelectionPicker(
                                context: context,
                                title: "Bank Select",
                                items: bankNames,
                                selectedItem: bankNames.first,
                                onChanged: (value) => setState(() {
                                  var id = value.split(' - ').elementAt(0);
                                  selectedBank = vm.banks.firstWhere(
                                      (element) =>
                                          element.bankID == int.parse(id));

                                  _bankController.text = value;
                                }),
                              );
                              progress.dismiss();
                            },
                            child: ListTile(
                              leading: Icon(Icons.title),
                              title: AbsorbPointer(
                                child: TextFormField(
                                  readOnly: true,
                                  controller: _bankController,
                                  decoration: InputDecoration(
                                      hintText: 'Bank',
                                      border: InputBorder.none),
                                ),
                              ),
                              trailing: Icon(Icons.arrow_forward),
                            ),
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
                            title: GestureDetector(
                              onTap: () {
                                showMaterialDatePicker(
                                    context: context,
                                    selectedDate: DateTime.now(),
                                    onChanged: (value) => setState(() {
                                          _startDateController.text =
                                              _dateFormat.format(value);
                                          _startDate = value;
                                        }));
                              },
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: _startDateController,
                                  decoration: InputDecoration(
                                    labelText: 'Start date',
                                    hintText: 'dd/MM/yyyy',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.date_range),
                            title: TextFormField(
                              controller: _termController,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  var rate;
                                  var month = 1;
                                  try {
                                    month = int.parse(value);
                                  } catch (e) {
                                    return;
                                  }
                                  if (month <= 12) {
                                    rate = selectedBank.savingRateSix;
                                  } else if (month > 12 && month <= 24) {
                                    rate = selectedBank.savingRateTwelve;
                                  } else {
                                    rate = selectedBank.savingRateTwentyFour;
                                  }
                                  _endDateController.text = _dateFormat.format(
                                      _startDate
                                          .add(Duration(days: month * 30)));
                                  _interestRateController.text =
                                      rate.toString();
                                });
                              },
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
                                      contentPadding:
                                          EdgeInsets.only(left: 20)),
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
                                      contentPadding:
                                          EdgeInsets.only(left: 20)),
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
                                      contentPadding:
                                          EdgeInsets.only(left: 18)),
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
        }),
      ),
    );
  }
}

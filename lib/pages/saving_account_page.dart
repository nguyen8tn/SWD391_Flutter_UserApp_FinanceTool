import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swd/models/Bank.dart';
import 'package:swd/models/SavingAccount.dart';
import 'package:swd/services/calculation_http_request.dart';
import 'package:swd/viewmodels/AddSavingAccountViewModel.dart';
import 'package:toast/toast.dart';

class SavingAccountPage extends StatefulWidget {
  String _account;
  double _interestRate, _freeRate, _amount;
  DateTime _startDate;
  int _term, _calculateDate, _bankID;
  List<Bank> banks = [];
  @override
  _SavingAccountPageState createState() => _SavingAccountPageState();
}

class _SavingAccountPageState extends State<SavingAccountPage> {
  List<String> bankNames = <String>[
    'TP Bank',
    'Vietcombank',
    'Techcombank',
    'VP Bank',
  ];
  String speed = 'Ludicrous';

  List<Icon> bankIcons = <Icon>[
    Icon(Icons.sort),
    Icon(Icons.clear_all),
    Icon(Icons.swap_calls),
    Icon(Icons.select_all),
  ];

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

  void saveData() async {
    final prefs = await SharedPreferences.getInstance();
    SavingAccount account = SavingAccount.sa(
        0,
        widget._bankID,
        prefs.getString('UID'),
        widget._account,
        widget._amount,
        widget._startDate,
        widget._term,
        widget._interestRate,
        widget._freeRate,
        widget._calculateDate);
    await HttpRequestC().addSavingAccount(account);
  }

  _calculateEndDate(BuildContext context) async {}

  _selectTerm(BuildContext context) {}

  @override
  void initState() {
    super.initState();
    _accountController.addListener(() {
      Toast.show(_accountController.text, context);
      widget._account = _accountController.text;
    });

    _amountController.addListener(() {
      Toast.show(_accountController.text, context);
      widget._amount = double.parse(_amountController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AddSavingAccountViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        title: Text(title ?? 'Create Saving Account'),
      ),
      body: ProgressHUD(
        child: Builder(builder: (context) {
          final progress = ProgressHUD.of(context);
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
                            decoration:
                                InputDecoration(hintText: 'Account name'),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.title),
                          title: TextField(
                            readOnly: true,
                            controller: _bankController,
                            decoration: InputDecoration(
                                hintText: 'Bank', border: InputBorder.none),
                          ),
                          trailing: InkResponse(
                            child: Icon(Icons.arrow_forward),
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
                                icons: bankIcons,
                                onChanged: (value) => setState(
                                    () => _bankController.text = value),
                              );
                              progress.dismiss();
                            },
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
                                  onChanged: (value) => setState(
                                        () => _startDateController.text =
                                            value.toString(),
                                      ));
                            },
                            child: AbsorbPointer(
                              child: TextField(
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
          );
        }),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swd/models/Bank.dart';
import 'package:swd/models/LoanAccount.dart';
import 'package:swd/models/SavingAccount.dart';
import 'package:swd/pages/account_page.dart';
import 'package:swd/services/calculation_http_request.dart';
import 'package:swd/services/httprequest.dart';
import 'package:swd/viewmodels/AccountDetailViewModel.dart';
import 'package:swd/viewmodels/AccountListViewModel.dart';

import 'package:toast/toast.dart';

class LoanAccountPage extends StatefulWidget {
  List<BankDetail> banks = [];
  bool isUpdate;
  LoanAccount account;
  LoanAccountPage({@required this.isUpdate, this.account});

  @override
  _LoanAccountPageState createState() => _LoanAccountPageState();
}

class _LoanAccountPageState extends State<LoanAccountPage> {
  List<String> bankNames = <String>[];
  DateTime _startDate = DateTime.now();
  BankDetail selectedBank;
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  String title = "Tạo Tài Khoản Vay";
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
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  @override
  void initState() {
    super.initState();
    isUpdating();
  }

  void isUpdating() async {
    widget.banks = await HttpRequest().fetchBanks();
    if (widget.isUpdate) {
      setState(() {
        selectedBank = widget.banks
            .singleWhere((element) => element.bankID == widget.account.bankID);
        var bankName =
            widget.account.bankID.toString() + ' - ' + selectedBank.bankName;
        _accountController.text = widget.account.name;
        _amountController.text = widget.account.amount.toString();
        _bankController.text = bankName;
        _termController.text = widget.account.term.toString();
        _startDateController.text =
            _dateFormat.format(widget.account.startDate);
        _numberDateController.text = widget.account.calculationDay.toString();
        _interestRateController.text = widget.account.interestRate.toString();
        _freeInterestRateController.text =
            widget.account.freeInterestRate.toString();
        _endDateController.text = _dateFormat.format(widget.account.startDate
            .add(Duration(days: widget.account.term * 30)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AccountDetailViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1BC0C5),
        centerTitle: true,
        title: Text(widget.isUpdate
            ? 'Cập Nhật Tài Khoản Vay'
            : 'Thêm Mới Tài Khoản Vay'),
      ),
      body: ProgressHUD(
        child: Builder(builder: (context) {
          final progress = ProgressHUD.of(context);
          void saveData() async {
            progress.show();
            final prefs = await SharedPreferences.getInstance();
            if (_formKey.currentState.validate()) {
              LoanAccount account = LoanAccount.sa(
                  widget.isUpdate ? widget.account.id : 0,
                  int.parse(_bankController.text.split(' - ').elementAt(0)),
                  prefs.getString('UID'),
                  _accountController.text,
                  double.parse(_amountController.text),
                  DateTime.parse(_startDate.toIso8601String()),
                  int.parse(_termController.text),
                  double.parse(_interestRateController.text),
                  double.parse(_freeInterestRateController.text),
                  int.parse(_numberDateController.text),
                  2,
                  DateTime.now());
              var resutl = widget.isUpdate
                  ? await vm.updateLoanAccount(account)
                  : await vm.addLoanAccount(account);
              if (resutl != null) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(widget.isUpdate
                          ? 'Cập Nhật Thành Công'
                          : 'Thêm Mới Thành Công'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Close'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChangeNotifierProvider(
                                    create: (context) => AccountListViewModel(),
                                    child: AccountPage(),
                                  ),
                                ));
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
                      title: Text(widget.isUpdate
                          ? 'Cập Nhật Thât Bại'
                          : 'Thêm Mới Thất Bại'),
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
            } else {
              _autoValidate = true;
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
                                    return 'Nhập số';
                                  }
                                  return null;
                                },
                                controller: _amountController,
                                decoration: InputDecoration(hintText: 'VNĐ')),
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
                                  InputDecoration(hintText: 'Tên Tài Khoản'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Không được rỗng';
                                }
                                return null;
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
                                title: "Chọn Ngân Hàng",
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
                                      hintText: 'Ngân Hàng',
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
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Chọn Ngày';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Ngày Bắt Đầu',
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
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Nhập 1 số';
                                }
                                return null;
                              },
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
                                  labelText: 'Kéo Dài (tháng)',
                                  hintText: 'Tháng'),
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.calendar_today),
                            title: TextField(
                              controller: _endDateController,
                              decoration: InputDecoration(
                                labelText: 'Ngày Kết Thúc',
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
                                child: Text(" Lãi Suất: "),
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
                                child: Text(" Lãi Suất Phi Rủi Ro: "),
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
                                child: Text(" Số Ngày Trong Năm: "),
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
                                child: Text(' ngày'),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        const SizedBox(height: 10),
                        RaisedButton(
                          onPressed: () {
                            saveData();
                          },
                          child: Text(widget.isUpdate
                              ? 'Cập Nhật Tài Khoản'
                              : 'Thêm Mới'),
                        ),
                        SizedBox(height: 15)
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

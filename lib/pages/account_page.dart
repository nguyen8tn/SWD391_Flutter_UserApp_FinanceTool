import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swd/models/LoanAccount.dart';
import 'package:swd/models/SavingAccount.dart';
import 'package:swd/pages/loan_account_page.dart';
import 'package:swd/pages/login_page.dart';
import 'package:swd/pages/saving_account_page.dart';
import 'package:swd/viewmodels/AccountDetailViewModel.dart';
import 'package:swd/viewmodels/AccountListViewModel.dart';
import 'dart:math' as math;

class AccountPage extends StatefulWidget {
  @override
  State createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  int tabIndex = 0;
  List<SavingAccount> listSaving = [
    SavingAccount.smp("TPBANK", 0.063, DateTime.now(), 1234),
    SavingAccount.smp("TPBANK", 0.067, DateTime.now(), 5000),
    SavingAccount.smp("Vietcombank", 0.023, DateTime.now(), 7500),
  ];
  List<LoanAccount> listLoan = [];
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  double money = 0;
  double moneyRisk = 0;
  List<Widget> getListTab(AccountListViewModel vm, BuildContext context) {
    final progress = ProgressHUD.of(context);
    List<Widget> listTab = [
      FutureBuilder<bool>(
        future: vm.getListAccountSavingByUserID(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          tabIndex = 0;
          if (snapshot.hasData) {
            progress.dismiss();
            return Container(
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 40,
                    child: Card(
                      elevation: 3,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('Tổng Cộng: ' +
                            oCcy.format(vm.totalSaving) +
                            ' VND (' +
                            vm.listSaving.length.toString() +
                            ' tài khoản)'),
                      ),
                    ),
                  ),
                  Expanded(child: _listUserSaving(vm))
                ],
              ),
            );
          } else {
            progress.show();
            return Padding(
              padding: EdgeInsets.fromLTRB(40, 80, 40, 40),
              child: Container(),
            );
          }
        },
      ),
      FutureBuilder<bool>(
        future: vm.getListAccountLoanByUserID(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          tabIndex = 1;
          if (snapshot.hasData) {
            progress.dismiss();
            return Container(
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 40,
                    child: Card(
                      elevation: 3,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('Tổng Cộng: ' +
                            oCcy.format(vm.totalLoan) +
                            ' (' +
                            vm.listLoans.length.toString() +
                            ' tài khoản)'),
                      ),
                    ),
                  ),
                  Expanded(child: _listUserLoan(vm))
                ],
              ),
            );
          } else {
            progress.show();
            return Padding(
              padding: EdgeInsets.fromLTRB(40, 80, 40, 40),
              child: Container(),
            );
          }
        },
      ),
    ];
    return listTab;
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AccountListViewModel>(context, listen: false);
    return DefaultTabController(
      length: 2,
      child: ProgressHUD(
        child: Scaffold(
          appBar: AppBar(
            leading: Container(
              child: Transform.rotate(
                angle: 180 * math.pi / 180,
                child: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Do you want to log out?'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text('Log Out'),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ));
                            },
                          )
                        ],
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.exit_to_app,
                  ),
                ),
              ),
            ),
            backgroundColor: Color(0xFF1BC0C5),
            title: Text('Tài Khoản Ngân Hàng'),
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  text: "Sổ Tiết Kiệm",
                ),
                Tab(
                  text: "Sổ Vay Ngân Hàng",
                )
              ],
            ),
          ),
          body: Builder(builder: (context) {
            return TabBarView(
              children: getListTab(vm, context),
            );
          }),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              if (tabIndex == 0) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                        create: (context) => AccountDetailViewModel(),
                        child: SavingAccountPage(
                          isUpdate: false,
                        ),
                      ),
                    ));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                        create: (context) => AccountDetailViewModel(),
                        child: LoanAccountPage(
                          isUpdate: false,
                        ),
                      ),
                    ));
              }
            },
            label: Text('Add'),
            icon: Icon(Icons.add_circle),
            backgroundColor: Color(0xFF1BC0C5),
          ),
        ),
      ),
    );
  }

  //list card
  Widget _listUserSaving(AccountListViewModel vm) {
    return RefreshIndicator(
      onRefresh: () async {
        await vm.getListAccountSavingByUserID();
        setState(() {
          listSaving = vm.listSaving;
        });
      },
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: vm.listSaving.length,
        itemBuilder: (context, index) {
          return cardDetails(vm, context, index, 0);
        },
      ),
    );
  }

  Widget _listUserLoan(AccountListViewModel vm) {
    return RefreshIndicator(
      onRefresh: () async {
        await vm.getListAccountLoanByUserID();
        setState(() {
          listLoan = vm.listLoans;
        });
      },
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: vm.listLoans.length,
        itemBuilder: (context, index) {
          return cardDetails(vm, context, index, 1);
        },
      ),
    );
  }

  //card details
  Widget cardDetails(
      AccountListViewModel vm, BuildContext context, int index, int type) {
    final oCcy = new NumberFormat("#,##0.00", "en_US");
    return new InkWell(
      onTap: () {
        if (type == 0) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                  create: (context) => AccountDetailViewModel(),
                  child: SavingAccountPage(
                    isUpdate: true,
                    account: vm.listSaving[index],
                  ),
                ),
              ));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                  create: (context) => AccountDetailViewModel(),
                  child: LoanAccountPage(
                    isUpdate: true,
                    account: vm.listLoans[index],
                  ),
                ),
              ));
        }
      },
      child: Container(
        padding: EdgeInsets.all(2),
        child: Card(
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(2),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Icon(Icons.monetization_on),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                type == 0
                                    ? vm.listSaving[index].name
                                    : vm.listLoans[index].name + "  ",
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                ((type == 0
                                            ? vm.listSaving[index].interestRate
                                            : vm.listLoans[index].interestRate))
                                        .toString() +
                                    '%',
                                style: TextStyle(
                                    color:
                                        type == 0 ? Colors.green : Colors.red),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                oCcy.format(vm.listSaving[index].amount),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 30,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Container(
                        color: Colors.white,
                        child: Stack(
                          fit: StackFit.loose,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: popupOption(vm, index, type),
                            ),
                            Align(
                              child: Text(DateFormat('dd/MM/yyyy')
                                  .format(type == 0
                                      ? vm.listSaving[index].startDate
                                      : vm.listLoans[index].startDate)
                                  .toString()),
                              alignment: Alignment.topLeft,
                            )
                          ],
                        ),
                      )),
                ],
              ),
            )),
      ),
    );
  }

  //popup option button
  Widget popupOption(AccountListViewModel vm, int index, int type) {
    List<String> choices = ['Xóa', 'Xem Thống Kê'];
    return PopupMenuButton(
      elevation: 3.2,
      itemBuilder: (BuildContext context) {
        return choices.map((String choice) {
          return PopupMenuItem(
            value: choice,
            child: ListTile(
              onTap: () async {
                Navigator.pop(context, choice);
                print(choice);
                switch (choice) {
                  case 'Xóa':
                    var result = type == 0
                        ? await vm
                            .deleteSavingAccountByID(vm.listSaving[index].id)
                        : await vm
                            .deleteLoanAccountByID(vm.listLoans[index].id);
                    if (result) {
                      setState(() {
                        type == 0
                            ? listSaving = vm.listSaving
                            : listLoan = vm.listLoans;
                      });
                    }
                    break;
                  case 'Xem Thống Kê':
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return customDialog(context, vm, index, type);
                        });
                    break;
                  default:
                    break;
                }
              },
              leading: Icon(Icons.menu),
              title: Text(choice),
            ),
          );
        }).toList();
      },
    );
  }

  List<DataRow> getListDataCell(AccountListViewModel vm, int index, int type) {
    List<DataRow> result = [];
    bool isSaving = type == 0;

    SavingAccount savingAccount =
        isSaving ? vm.listSaving[index] : SavingAccount();
    LoanAccount loanAccount = isSaving ? LoanAccount() : vm.listLoans[index];

    var term = isSaving ? vm.listSaving[index].term : vm.listLoans[index].term;
    money = isSaving ? vm.listSaving[index].amount : vm.listLoans[index].amount;
    moneyRisk = money;

    for (var i = 1; i <= term; i++) {
      var row = DataRow(cells: [
        DataCell(Text(isSaving
            ? getAddedDateString(savingAccount.startDate, i * 30)
            : getAddedDateString(loanAccount.startDate, i * 30))),
        DataCell(Text(isSaving
            ? oCcy.format(getInterestMoneyPerMonth(
                savingAccount.amount, savingAccount.interestRate))
            : oCcy.format(getInterestMoneyPerMonth(
                loanAccount.amount, loanAccount.interestRate)))),
        DataCell(Text(isSaving
            ? oCcy.format(getTotalMoneyAfterAMonth(savingAccount.interestRate))
            : oCcy.format(getTotalMoneyAfterAMonth(loanAccount.interestRate)))),
        DataCell(Text(isSaving
            ? oCcy.format(
                getTotalMoneyBeforeAnnual(savingAccount.freeInterestRate, i))
            : oCcy.format(
                getTotalMoneyBeforeAnnual(loanAccount.freeInterestRate, i))))
      ]);
      result.add(row);
    }
    money = 0;
    moneyRisk = 0;
    return result;
  }

  String getAddedDateString(DateTime time, int day) {
    return DateFormat('dd/MM/yyyy').format(time.add(Duration(days: day)));
  }

  double getInterestMoneyPerMonth(double money, double interestRate) {
    return money * ((interestRate / 12) / 100);
  }

  double getTotalMoneyAfterAMonth(double interestRate) {
    money += getInterestMoneyPerMonth(money, interestRate);
    return money;
  }

  double getTotalMoneyBeforeAnnual(double freeInterestRate, int month) {
    if ((month % 12) == 0) {
      moneyRisk = money;
    } else {
      moneyRisk += getInterestMoneyPerMonth(moneyRisk, freeInterestRate);
    }
    return moneyRisk;
  }

  Dialog customDialog(
      BuildContext context, AccountListViewModel vm, int index, int type) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        height: 500,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Flexible(
            child: Container(
                child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Thông Tin Lãi',
                      textAlign: TextAlign.right,
                    ),
                    DataTable(columns: [
                      DataColumn(label: Text('Ngày Đáo Hạn')),
                      DataColumn(
                          label: Text('Số Lãi Thường Niên'), numeric: true),
                      DataColumn(
                          label: Text('Tất Toán Trong Kỳ'), numeric: true),
                      DataColumn(
                          label: Text('Tất Toán Trước Thời Hạn'),
                          numeric: true),
                    ], rows: getListDataCell(vm, index, type)),
                  ],
                ),
              ),
            )),
          ),
        ),
      ),
    );
  }
}

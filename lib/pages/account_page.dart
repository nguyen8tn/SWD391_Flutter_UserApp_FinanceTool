import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:swd/models/LoanAccount.dart';
import 'package:swd/models/SavingAccount.dart';
import 'package:swd/viewmodels/AccountListViewModel.dart';

class AccountPage extends StatefulWidget {
  @override
  State createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  int money = 123;
  List<SavingAccount> list = [
    SavingAccount.smp("TPBANK", 0.063, DateTime.now(), 1234),
    SavingAccount.smp("TPBANK", 0.067, DateTime.now(), 5000),
    SavingAccount.smp("Vietcombank", 0.023, DateTime.now(), 7500),
  ];
  List<LoanAccount> loanList = [];

  List<Widget> getListTab(AccountListViewModel vm, BuildContext context) {
    final progress = ProgressHUD.of(context);
    List<Widget> listTab = [
      FutureBuilder<bool>(
        future: vm.getListAccountSavingByUserID(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
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
                        child: Text('Total: ' +
                            vm.totalSaving.toString() +
                            ' (' +
                            vm.listSaving.length.toString() +
                            ' accounts)'),
                      ),
                    ),
                  ),
                  _listUserSaving(vm)
                ],
              ),
              color: Colors.black12,
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
      Container(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 40,
              child: Card(
                elevation: 3,
                child: Align(
                  alignment: Alignment.center,
                  child: Text('Total: ' +
                      1213.toString() +
                      ' (' +
                      list.length.toString() +
                      ' accounts)'),
                ),
              ),
            ),
            _listUserLoan(vm)
          ],
        ),
        color: Colors.black12,
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
            title: Text('Tài Khoản Ngân Hàng'),
            centerTitle: true,
            bottom: TabBar(
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
        ),
      ),
    );
  }

  //list card
  Widget _listUserSaving(AccountListViewModel vm) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: vm.listSaving.length,
      itemBuilder: (context, index) {
        return cardDetails(vm, context, index, 0);
      },
    );
  }

  Widget _listUserLoan(AccountListViewModel vm) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (context, index) {
        return cardDetails(vm, context, index, 1);
      },
    );
  }

  //card details
  Widget cardDetails(
      AccountListViewModel vm, BuildContext context, int index, int type) {
    return new InkWell(
      onTap: () {},
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
                            Text(
                              vm.listSaving[index].name + "  ",
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              (vm.listSaving[index].interestRate * 100)
                                  .toString(),
                              style: TextStyle(
                                  color: type == 0 ? Colors.green : Colors.red),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              vm.listSaving[index].amount.toString(),
                              style: TextStyle(
                                fontSize: 30,
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
                              child: popupOption(),
                            ),
                            Align(
                              child: Text(DateFormat('dd/MM/yyyy')
                                  .format(vm.listSaving[index].startDate)
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

  Widget cardDetailsx(context, index) {
    return ListTile(
      leading: Icon(Icons.monetization_on),
      title: Text('asdasasd'),
      trailing: Column(
        children: [
          Align(
            child: popupOption(),
            alignment: Alignment.topRight,
          ),
          Align(child: Text('asasd'), alignment: Alignment(0, 0))
        ],
      ),
    );
  }

  //popup option button
  Widget popupOption() {
    List<String> choices = ['Xóa', 'Tất Toán'];
    return PopupMenuButton(
      elevation: 3.2,
      itemBuilder: (BuildContext context) {
        return choices.map((String choice) {
          return PopupMenuItem(
            value: choice,
            child: ListTile(
              leading: Icon(Icons.map),
              title: Text(choice),
            ),
          );
        }).toList();
      },
    );
  }
}

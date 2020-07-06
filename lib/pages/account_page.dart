import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swd/models/SavingAccount.dart';

class AccountPage extends StatefulWidget {
  @override
  State createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  int money = 123;
  List<SavingAccount> list = [
    SavingAccount.smp("BT", 0.01, DateTime.now(), 5000),
    SavingAccount.smp("GT", 0.01, DateTime.now(), 5000),
    SavingAccount.smp("RT", 0.01, DateTime.now(), 5000),
  ];

  List<Widget> getListTab() {
    List<Widget> listTab = [
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
                  child: Text('Total: ' + 1213.toString() + ' ('+list.length.toString()+' accounts)'),
                ),
              ),
            ),
            _listUserSaving()
          ],
        ),
        color: Colors.black12,
      ),
      Container(
        color: Colors.black,
      )
    ];
    return listTab;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Account'),
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
        body: TabBarView(
          children: getListTab(),
        ),
      ),
    );
  }

  //list card
  Widget _listUserSaving() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (context, index) {
        return cardDetails(context, index);
      },
    );
  }

  //card details
  Widget cardDetails(BuildContext context, int index) {
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
                              list[index].name + "  ",
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              (list[index].interestRate * 100).toString(),
                              style: TextStyle(color: Colors.red),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              list[index].amount.toString(),
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
                        color: Colors.red,
                        child: Stack(
                          fit: StackFit.loose,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: popupOption(),
                            ),
                            Align(
                              child: Text(DateFormat('dd/MM/yyyy')
                                  .format(list[index].startDate)
                                  .toString()),
                              alignment: Alignment.bottomRight,
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
    List<String> choices = ['', 'Xoa', 'Tat Toan'];
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

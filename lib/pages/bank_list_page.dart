import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swd/models/Bank.dart';
import 'package:swd/viewmodels/BankListViewModel.dart';
import 'package:swd/widgets/bank_list.dart';

class BankListPage extends StatefulWidget {
  _BankListpageState createState() => _BankListpageState();
}

class _BankListpageState extends State<BankListPage> {
  final _controller = TextEditingController();
  List<BankDetail> banks;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Provider.of<BankListViewModel>(context, listen: false).fetchBanks('bank');
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<BankListViewModel>(context, listen: false);

    return Scaffold(
        body: FutureBuilder(
      builder: (context, snapshot) {
        return Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: _controller,
                  onSubmitted: (value) async {
                    await vm.getBankByID(value);
                    setState(() {
                      banks = vm.list;
                    });
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      hintText: "Search",
                      hintStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none),
                ),
              ),
              Expanded(child: BankList(banks: vm.list))
            ]));
      },
      future: vm.fetchBanks(),
    ));
  }
}

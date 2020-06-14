import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swd/viewmodels/BankViewModel.dart';


class BankList extends StatelessWidget {

  final List<BankViewModel> banks; 

 BankList({this.banks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: this.banks.length,
      itemBuilder: (context, index) {
        
        final bank = this.banks[index];

        return ListTile(
          contentPadding: EdgeInsets.all(10),
          leading: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(bank.bankIcon)
              ),
              borderRadius: BorderRadius.circular(6)
            ),
            width: 50, 
            height: 100,
            ),
          title: Text(bank.bankName),
        );
      },
    );
  }
}
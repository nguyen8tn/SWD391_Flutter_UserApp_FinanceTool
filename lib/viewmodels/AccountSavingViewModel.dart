import 'package:flutter/cupertino.dart';
import 'package:swd/models/SavingAccount.dart';

class AccountSavingViewModel extends ChangeNotifier {
  SavingAccount savingAccount;

  AccountSavingViewModel({this.savingAccount});

  int get id {
    return savingAccount.id;
  }

  int get bankID {
    return savingAccount.bankID;
  }

  String get uid {
    return savingAccount.uid;
  }

  DateTime get startDate {
    return savingAccount.startDate;
  }

  double get amount {
    return savingAccount.amount;
  }

  double get interestRate {
    return savingAccount.interestRate;
  }

  int get term {
    return savingAccount.term;
  }

  double get freeInterestRate {
    return savingAccount.freeInterestRate;
  }

  int get calculationDay {
    return savingAccount.calculationDay;
  }
}

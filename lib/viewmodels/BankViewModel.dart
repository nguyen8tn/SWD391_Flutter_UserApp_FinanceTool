import 'package:swd/models/bank.dart';

class BankViewModel {
  final Bank bank;  

  BankViewModel({this.bank});

  String get bankId {
    return bank.bankID;
  }

  String get bankName {
    return bank.bankName;
  }

  String get bankIcon {
    return bank.bankIcon;
  }
}
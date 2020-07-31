import 'package:swd/models/Bank.dart';

class BankViewModel {
  final BankDetail bank;

  BankViewModel({this.bank});

  int get bankId {
    return bank.bankID;
  }

  String get bankName {
    return bank.bankName;
  }

  String get bankIcon {
    return bank.bankIcon;
  }
}

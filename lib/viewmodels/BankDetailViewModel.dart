import 'dart:ffi';

import 'package:swd/models/Bank.dart';

class BankDetailViewModel {
  final BankDetail bank;

  BankDetailViewModel({this.bank});

  int get bankId {
    return bank.bankID;
  }

  String get bankName {
    return bank.bankName;
  }

  String get bankIcon {
    return bank.bankIcon;
  }

  double get loanRateSix {
    return bank.loanRateSix;
  }

  double get loanRateTwelve {
    return bank.loanRateTwelve;
  }

  double get loanRateTwentyFour {
    return bank.loanRateTwentyFour;
  }

  double get savingRateSix {
    return bank.savingRateSix;
  }

  double get savingRateTwelve {
    return bank.savingRateTwelve;
  }

  double get savingRateTwentyFour {
    return bank.savingRateTwentyFour;
  }
}

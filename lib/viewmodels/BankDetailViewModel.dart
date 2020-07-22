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

  Float get loanRateSix {
    return bank.loanRateSix;
  }

  Float get loanRateTwelve {
    return bank.loanRateTwelve;
  }

  Float get loanRateTwentyFour {
    return bank.loanRateTwentyFour;
  }

  Float get savingRateSix {
    return bank.savingRateSix;
  }

  Float get savingRateTwelve {
    return bank.savingRateTwelve;
  }

  Float get savingRateTwentyFour {
    return bank.savingRateTwentyFour;
  }
}

import 'dart:ffi';

class Bank {
  final int bankID;
  final String bankName;
  final String bankIcon;

  Bank({this.bankID, this.bankName, this.bankIcon});

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
        bankID: json["id"],
        bankIcon: json['bank_icon'],
        bankName: json['name']);
  }
}

class BankDetail {
  final int bankID;
  final String bankName;
  final String bankIcon;
  final double loanRateSix;
  final double loanRateTwelve;
  final double loanRateTwentyFour;
  final double savingRateSix;
  final double savingRateTwelve;
  final double savingRateTwentyFour;
  final double freeInterestRate;

  BankDetail(
      {this.bankID,
      this.bankIcon,
      this.bankName,
      this.loanRateSix,
      this.loanRateTwelve,
      this.loanRateTwentyFour,
      this.savingRateTwentyFour,
      this.savingRateSix,
      this.savingRateTwelve,
      this.freeInterestRate});

  factory BankDetail.fromJson(Map<String, dynamic> json) {
    return BankDetail(
        bankID: json['id'],
        bankIcon: json['icon'],
        bankName: json['name'],
        loanRateSix: json['loanRateSix'],
        loanRateTwelve: json['loanRateTwelve'],
        loanRateTwentyFour: json['loanRateTwentyFour'],
        savingRateSix: json['savingRateSix'],
        savingRateTwelve: json['savingRateTwelve'],
        savingRateTwentyFour: json['savingRateTwentyFour'],
        freeInterestRate: json['freeInterest']);
  }
}

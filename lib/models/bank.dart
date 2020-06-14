import 'dart:ffi';

class Bank {
  final String bankID;
  final String bankName;
  final String bankIcon;
  
  Bank({this.bankID ,this.bankName, this.bankIcon});

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      bankID: json["id"],
      bankIcon:  json['bank_icon'],
      bankName: json['name']
    );
  }
 
}

class BankDetail {
  final String bankID;
  final String bankname;
  final String bankIcon;
  final Float loanRateSix;
  final Float loanRateTwelve;
  final Float loanRateTwentyFour;
  final Float savingRateSix;
  final Float savingRateTwelve;
  final Float savingRateTwentyFour;

  BankDetail(
    {
      this.bankID, this.bankIcon, this.bankname,
      this.loanRateSix, this.loanRateTwelve, this.loanRateTwentyFour,
      this.savingRateTwentyFour, this.savingRateSix, this.savingRateTwelve
    }
  );

  factory BankDetail.fromJson(Map<String, dynamic> json) {
    return BankDetail(
      bankID: json['id'],
      bankIcon: json['bank_icon'],
      bankname: json['name'],
      loanRateSix: json['loanRateSix'],
      loanRateTwelve: json['loanRateTwelve'],
      loanRateTwentyFour: json['loanRateTwentyFour'],
      savingRateSix: json['savingRateSix'],
      savingRateTwelve: json['savingRateTwelve'],
      savingRateTwentyFour: json['savingRateTwentyFour'],
    );
  }

}
   

import 'package:flutter/cupertino.dart';
import 'package:swd/models/Bank.dart';
import 'package:swd/models/LoanAccount.dart';
import 'package:swd/services/httprequest.dart';

class LoanAccountViewModel extends ChangeNotifier {
  LoanAccount savingAccount;
  List<BankDetail> banks = [];

  Future<bool> addSavingAccount(
      LoanAccount loanAccount, String token) async {
    try {
      final result = await HttpRequest().addLoanAccount(loanAccount, token);
      savingAccount = result;
      notifyListeners();
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> fetchBanks() async {
    try {
      final result = await HttpRequest().fetchBanks();
      banks = result;
      notifyListeners();
    } catch (e) {
      return false;
    }
    return true;
  }
}
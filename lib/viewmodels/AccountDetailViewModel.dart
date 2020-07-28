import 'package:flutter/cupertino.dart';
import 'package:swd/models/LoanAccount.dart';
import 'package:swd/models/SavingAccount.dart';
import 'package:swd/services/calculation_http_request.dart';

class AccountDetailViewModel extends ChangeNotifier {
  SavingAccount savingAccount;
  LoanAccount loanAccount;

  Future<bool> getSavingAccountDetail(int id) async {
    try {
      final result = await HttpRequestC().getSavingAccountByID(id);
      savingAccount = result;
      notifyListeners();
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> getLoanAccountDetail(int id) async {
    try {
      final result = await HttpRequestC().getLoanAccountByID(id);
      loanAccount = result;
      notifyListeners();
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> updateSavingAccount(SavingAccount savingAccount) async {
    try {
      final result = await HttpRequestC().updateSavingAccount(savingAccount);
      savingAccount = result;
      notifyListeners();
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> updateLoanAccount(LoanAccount loanAccount) async {
    try {
      final result = await HttpRequestC().updateLoanAccount(loanAccount);
      loanAccount = result;
      notifyListeners();
    } catch (e) {
      return false;
    }
    return true;
  }
}

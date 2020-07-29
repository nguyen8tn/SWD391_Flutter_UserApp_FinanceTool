import 'package:flutter/cupertino.dart';
import 'package:swd/models/Bank.dart';
import 'package:swd/models/LoanAccount.dart';
import 'package:swd/models/SavingAccount.dart';
import 'package:swd/services/calculation_http_request.dart';
import 'package:swd/services/httprequest.dart';

class AccountDetailViewModel extends ChangeNotifier {
  SavingAccount savingAccount;
  LoanAccount loanAccount;
  List<BankDetail> banks;

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

  Future<bool> addSavingAccount(SavingAccount savingAccount) async {
    try {
      final result = await HttpRequestC().addSavingAccount(savingAccount);
      savingAccount = result;
      notifyListeners();
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> addLoanAccount(LoanAccount loanAccount) async {
    try {
      final result = await HttpRequestC().addLoanAccount(loanAccount);
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:swd/models/Bank.dart';
import 'package:swd/models/SavingAccount.dart';
import 'package:swd/services/httprequest.dart';

class SavingAccountViewModel extends ChangeNotifier {
  SavingAccount savingAccount;
  List<BankDetail> banks = [];

  Future<bool> addSavingAccount(
      SavingAccount savingAccount, String token) async {
    try {
      final result = await HttpRequest().addSavingAccount(savingAccount, token);
      savingAccount = result;
      notifyListeners();
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> updateSavingAccount(
      SavingAccount savingAccount, String token) async {
    try {
      final result =
          await HttpRequest().updateSavingAccount(savingAccount, token);
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

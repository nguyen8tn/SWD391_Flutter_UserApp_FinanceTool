import 'package:flutter/cupertino.dart';
import 'package:swd/models/Bank.dart';
import 'package:swd/models/SavingAccount.dart';
import 'package:swd/models/user.dart';
import 'package:swd/services/httprequest.dart';

class AddSavingAccountViewModel extends ChangeNotifier {
  SavingAccount savingAccount;
  List<Bank> banks = [];

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

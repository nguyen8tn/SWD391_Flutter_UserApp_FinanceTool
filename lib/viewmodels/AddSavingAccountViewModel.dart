import 'package:flutter/cupertino.dart';
import 'package:swd/models/SavingAccount.dart';
import 'package:swd/models/user.dart';
import 'package:swd/services/httprequest.dart';

class AddSavingAccountViewModel extends ChangeNotifier {
  SavingAccount savingAccount;

  Future<bool> addSavingAccount(
      SavingAccount savingAccount, String token) async {
    final result = await HttpRequest().addSavingAccount(savingAccount, token);
    if (result != null) {
      notifyListeners();
      return true;
    }
    return false;
  }
}

import 'package:flutter/cupertino.dart';
import 'package:swd/models/SavingAccount.dart';
import 'package:swd/services/calculation_http_request.dart';
import 'package:swd/viewmodels/AccountSavingViewModel.dart';

class AccountSavingListViewModel extends ChangeNotifier {
  List<SavingAccount> listSaving;

  Future<bool> getListAccountSavingByUserID(String keyword) async {
    try {
      final result = await HttpRequestC().getListSavingAccountByID(keyword);
      listSaving = result;
      notifyListeners();
    } catch (e) {
      return false;
    }
    return true;
  }
}

import 'package:flutter/cupertino.dart';
import 'package:swd/models/LoanAccount.dart';
import 'package:swd/models/SavingAccount.dart';
import 'package:swd/services/calculation_http_request.dart';
import 'package:swd/viewmodels/AccountSavingViewModel.dart';

class AccountListViewModel extends ChangeNotifier {
  List<SavingAccount> listSaving;
  List<LoanAccount> listLoans;
  double totalSaving = 0;
  double totalLoan = 0;

  Future<bool> getListAccountSavingByUserID() async {
    totalSaving = 0;
    try {
      final result = await HttpRequestC().getListSavingAccountByID();
      listSaving = result;
      for (var item in listSaving) {
        totalSaving += item.amount ?? 0;
      }
      notifyListeners();
    } catch (e) {
      print(e.toString());
      return false;
    }
    return true;
  }

  Future<bool> deleteSavingAccountByID(int keyword) async {
    try {
      final result = await HttpRequestC().deleteAccountByID(keyword, 1);
      listSaving.removeWhere((element) => element.id == keyword);

      notifyListeners();
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> getListAccountLoanByUserID() async {
    totalLoan = 0;
    try {
      final result = await HttpRequestC().getListLoanAccountByID();
      listLoans = result;
      for (var item in listLoans) {
        totalLoan += item.amount;
      }
      notifyListeners();
    } catch (e) {
      print(e.toString());
      return false;
    }
    return true;
  }

  Future<bool> deleteLoanAccountByID(int keyword) async {
    try {
      final result = await HttpRequestC().deleteAccountByID(keyword, 2);
      listLoans.removeWhere((element) => element.id == keyword);
      notifyListeners();
    } catch (e) {
      print(e.toString());
      return false;
    }
    return true;
  }
}

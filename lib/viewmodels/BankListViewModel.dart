import 'package:flutter/cupertino.dart';
import 'package:swd/models/Bank.dart';
import 'package:swd/services/httprequest.dart';
import 'package:swd/viewmodels/BankViewModel.dart';

class BankListViewModel extends ChangeNotifier {
  List<BankDetail> list = List<BankDetail>();

  Future<bool> fetchBanks() async {
    try {
      final result = await HttpRequest().fetchBanks();
      list = result;
      notifyListeners();
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> getBankByID(String keyword) async {
    if (keyword.isEmpty) {
      return false;
    }
    list.where((element) => element.bankName.contains(keyword));
    return true;
  }
}

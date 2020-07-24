import 'package:flutter/cupertino.dart';
import 'package:swd/services/httprequest.dart';
import 'package:swd/viewmodels/BankViewModel.dart';

class BankListViewModel extends ChangeNotifier {
  List<BankViewModel> list = List<BankViewModel>();

  Future<bool> fetchBanks(String keyword) async {
    final result = await HttpRequest().fetchBanks();
    list = result.map((bank) => BankViewModel(bank: bank)).toList();
    notifyListeners();
    return true;
  }
}

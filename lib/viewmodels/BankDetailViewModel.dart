import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:swd/models/Bank.dart';
import 'package:swd/models/BankPackage.dart';
import 'package:swd/services/calculation_http_request.dart';

class BankDetailViewModel extends ChangeNotifier {
  List<BankPackage> bankPackages;

  Future<bool> getListBankPackage(int keyword) async {
    try {
      final result = await HttpRequestC().getListBankPackage(keyword);
      bankPackages = result;
      notifyListeners();
    } catch (e) {
      return false;
    }
    return true;
  }
}

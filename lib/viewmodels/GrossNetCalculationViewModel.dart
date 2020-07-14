import 'package:flutter/cupertino.dart';
import 'package:swd/models/caculation.dart';
import 'package:swd/services/httprequest.dart';

class GrossNetCalculationViewModel extends ChangeNotifier {
  List<BaseFormula> baseFormulas;

  Future<bool> getAllFormulas() async {
    final result = await HttpRequest().getBaseFormula();
    baseFormulas = result;
    notifyListeners();
    if (result != null) {
      return true;
    } else {
      return false;
    }
  }
}

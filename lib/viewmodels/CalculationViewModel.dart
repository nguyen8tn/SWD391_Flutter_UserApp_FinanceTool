import 'package:flutter/cupertino.dart';

import 'package:swd/models/Operand.dart';

import 'package:swd/models/Caculation.dart';
import 'package:swd/services/calculation_http_request.dart';
import 'package:swd/services/httprequest.dart';

class CalculationViewModel extends ChangeNotifier {
  List<BaseFormula> baseFormulas;
  List<Operand> operants;
  Map<String, List<Operand>> result;

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

  Future<bool> getAllOperantByFormulaID(int id) async {
    try {
      final result = await HttpRequest().getListOperantByID(id);
      operants = result;
      notifyListeners();
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> calculateFormula(List<Operand> operands, int id) async {
    try {
      final result = await HttpRequestC().calculateFormula(operands, id);
      this.result = result;
      notifyListeners();
    } catch (e) {
      return false;
    }
    return true;
  }
}

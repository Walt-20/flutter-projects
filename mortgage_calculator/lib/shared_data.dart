import 'package:flutter/material.dart';

class SharedData extends ChangeNotifier {
  double _monthlyMortgage = 0.0;
  double _grossIncome = 0.0;

  double get monthlyMortgage => _monthlyMortgage;
  double get grossIncome => _grossIncome;

  void setMonthlyMortgage(double value) {
    _monthlyMortgage = value;
    debugPrint("setting monthly mortgage $_monthlyMortgage");
    notifyListeners();
  }

  void setGrossIncome(double value) {
    _grossIncome = value;
    debugPrint("setting gross income $_grossIncome");
    notifyListeners();
  }
}

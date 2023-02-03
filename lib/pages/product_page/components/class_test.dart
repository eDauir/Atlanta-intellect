import 'package:flutter/foundation.dart';

class Counter with ChangeNotifier {
  double x = 0.0;
  int right = 0;
  int fal = 0;

  int counterLengthTest = 0;

  List<bool> isResult = [];

  bool isShowRemoveBtn = false;

  checkRes() {
    for (var i = 0; i < isResult.length; i++) {
      if (isResult[i] == false) {
        isShowRemoveBtn = false;
        print('FLASE');
        return false;
      }
    }
    isShowRemoveBtn = true;
      print('TRUEEE');
    return true;
  }

  check() {
    right = 0;
    for (var i = 0; i < isResult.length; i++) {
      if (isResult[i] == true) right++;
    }
    return '$right/${isResult.length}';
  }

  setIsResult(bool value) {
    isResult.add(value);
    notifyListeners();
  }

  setReloadValue() {
    isResult = [];
    right = 0;
    counterLengthTest = 0;
    notifyListeners();
  }

  setCounter() {
    counterLengthTest++;
    notifyListeners();
  }

  void increase() {
    x = x + 1.0;
    notifyListeners();
  }
}

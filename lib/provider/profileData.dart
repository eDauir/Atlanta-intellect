import 'package:flutter/material.dart';

class ProfileData with ChangeNotifier {
  String name = '';
  String surname = '';
  String lastName = '';
  String addres = '';
  String tel = '';

  setInitValue({required String nameValue, surName, lastNameValue, addresValue, telVAlue}) {
    name = nameValue;
    surname = surName;
    addres = addresValue;
    tel = telVAlue;
    lastName = lastNameValue;
    // notifyListeners();
  }

  String? male;

  set setMale(String value) {
    male = value;
    notifyListeners();
  }
}

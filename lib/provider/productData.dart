import 'package:flutter/material.dart';

class ProductData with ChangeNotifier {
  String? lessonId;
  set setLessonId(String id) {
    lessonId = id;
    notifyListeners();
  }

  bool isLock = false;
}

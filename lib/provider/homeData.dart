import 'package:barber/api/Category/ICategory.dart';
import 'package:barber/api/home/Ihome.dart';
import 'package:flutter/material.dart';

class HomeData with ChangeNotifier {
  List likeProductsId = [];

  setLikeProducts(String id) {}

  Map<String, List<Products>>? productsMap = {'🔥 Все': []};

  String currentCategoryId = '';
  set setCurrentCategory(String id) {
    currentCategoryId = id;
  }

  List<Products>? products;
  int productsTotalPage = 0;
  String findTotal = '1';

  String activeIndex = '0';
  set setActiveIndex(String index) {
    activeIndex = index;
    notifyListeners();
  }

  addProducts(List<Products> arr) {
    products = arr;
  }

  addMore(List<Products> arr) {
    products!.addAll(arr);
  }

  setProducts(
      List<Products> arr, int totalPages, findPage, String nameCategory) {
    productsMap![nameCategory] = arr;
    products = arr;
    productsTotalPage = totalPages;
    findTotal = findPage;
    notifyListeners();
  }
}

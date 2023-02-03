import 'package:barber/api/Banner/IBanner.dart';
import 'package:barber/api/Category/ICategory.dart';
import 'package:barber/api/FAQ/IFaq.dart';
import 'package:barber/api/Mentors/IMentor.dart';
import 'package:barber/api/Notification/INotification.dart';
import 'package:barber/api/Tarif/ITarif.dart';
import 'package:flutter/material.dart';

class GlobalData with ChangeNotifier {
  // unitData
  int _unitTotal = 1000;
  get unitTotalCount => _unitTotal;

  // status USER
  int statusUser = 0;
  set setStatusUser(int val) {
    statusUser = val;
  }

  String? loginToken;
  setLoginToken(String token) {
    loginToken = token;
    notifyListeners();
  }

  // notyfication
  bool isNoty = true;
  set setIsNoty(bool value) {
    isNoty = value;
  }

  // ! Start Tarif

  List<ITarif> tarifs = [];
  List<IBoughtTarif> myTarif = [];

  bool isBuyTarif = false;
  int buyTarifIndex = -1;

  setMyTarif(List<IBoughtTarif> arr) {
    myTarif = arr;
    checkBuyTarif(tarfis: tarifs, boughtTarif: arr);
    print(isBuyTarif);
  }

  setTarif(List<ITarif> arr) {
    tarifs = arr;
  }

  checkBuyTarif(
      {required List<ITarif> tarfis, required List<IBoughtTarif> boughtTarif}) {
    if (boughtTarif.isEmpty) {
      isBuyTarif = false;
      return;
    }

    for (int i = 0; i < tarfis.length; i++) {
      if (tarfis[i].id == boughtTarif[0].rateId) {
        if (boughtTarif[0].activeDate == null) {}
        isBuyTarif = boughtTarif[0].active == '0' ? false : true;

        if (boughtTarif[0].activeDate != null) {
          var split = boughtTarif[0].activeDate.toString().split('-');
          var day = int.parse(split.last);
          var month = int.parse(split[1]);
          var year = int.parse(split.first);

          DateTime myPackageDate =
              new DateTime(year, month, day + int.parse(boughtTarif[0].day!));
          DateTime now = new DateTime.now();

          if (now.compareTo(myPackageDate) > 0) {
            isBuyTarif = false;
          } else {
            isBuyTarif = true;
            buyTarifIndex = i;
          }
        }
      }
    }
  }

  // ! End Tarif

  bool isMentor = false;
  set setIsMentor(bool val) {
    isMentor = val;
  }

  bool isInvestor = false;
  set setIsInvestor(bool val) {
    isInvestor = val;
  }

  bool isCurator = false;
  set setIsCurator(bool val) {
    isCurator = val;
  }

  setLoginTokenWithoutNoti(String token) {
    loginToken = token;
  }

  bool darkMode = false;
  setDarkMode() {
    darkMode = !darkMode;
    notifyListeners();
  }

  String title = 'Atlanta';
  get getTitle => title;
  set setTitle(String text) {
    title = text;
    notifyListeners();
  }

  // Banner SLider
  List<IBanner> bannerList = [];
  set setBannerList(List<IBanner> arr) {
    bannerList = arr;
    notifyListeners();
  }

  // MENTORs
  List<Workers> mentors = [];
  int mentorsTotalPage = 0;
  String findTotalMentors = '1';
  setMentors(List<Workers> arr, int? totalPage, String findCount) {
    mentors = arr;
    mentorsTotalPage = totalPage ?? 0;
    findTotalMentors = findCount;
    notifyListeners();
  }

  // get Category
  List<ICategory> categories = [];
  setCategory(List<ICategory> arr) {
    categories = arr;
    notifyListeners();
  }

  int isDevice = 0;
  get getIsDevice => isDevice;
  set setIsDevice(var device) {
    isDevice = device;
    // notifyListeners();
  }

  // Данные юзер для драуер
  List infoUser = [];
  get getInfoUser => infoUser;
  set setInfoUser(List data) {
    infoUser = data;
    notifyListeners();
  }

  List<INotification> noti = [];
  set setNoti(List<INotification> data) {
    noti = data;
  }

  List<IFaq> faq = [];
  setFaq(List<IFaq> data) {
    faq = data;
  }

  bool isNotifications = false;

  GlobalKey<ScaffoldState> globalKey = GlobalKey();
  get getGlobalKey => globalKey;
}

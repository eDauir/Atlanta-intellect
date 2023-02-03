import 'package:barber/api/Notification/INotification.dart';
import 'package:barber/generated/locale_keys.g.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class myCustomeBottomBar extends StatefulWidget {
  int numWidget;
  myCustomeBottomBar({Key? key, required this.numWidget}) : super(key: key);
  @override
  State<myCustomeBottomBar> createState() => _myCustomeBottomBarState();
}

class _myCustomeBottomBarState extends State<myCustomeBottomBar> {
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  @override
  Widget build(BuildContext context) {
    bool isnewnot = false;
    isEmptyNoti() {
      encryptedSharedPreferences.getString('noty').then((value) {
        if (value == 'true') {
          isnewnot = true;
          setState(() {});
        }
      }).catchError((onError) {});
    }

    var pageIndex = widget.numWidget;
    clickBottomBar(int index) async {
      String url = '';
      switch (index) {
        case 1:
          url = '';
          break;
        case 10:
          url = 'search';
          break;
        case 11:
          url = 'noti';
          break;
        case 15:
          url = 'tarif';
          break;
        case 5:
          url = 'profile';
          break;
        case 99:
          url = 'menu';
          break;
      }

      if (index == 99) {
        Scaffold.of(context).openEndDrawer();
      } else {
        context.go('/' + url);
      }

      setState(() {
        pageIndex = index;
      });
    }

    // Icons.home_outlined,

    CustomeIconBar(
        {String? text,
        required imgPath,
        required int index,
        required bool isNoti}) {
      bool minWidth = MediaQuery.of(context).size.width < 360 ? true : false;
      return TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.focused))
              return Colors.transparent;
            if (states.contains(MaterialState.hovered))
              return Colors.transparent;
            if (states.contains(MaterialState.pressed))
              return Colors.transparent;
            return Colors.transparent;
          }),
        ),
        onPressed: () async {
          isEmptyNoti();
          await clickBottomBar(index);
          setState(() {});
        },
        child: Container(
          color: bottomBarColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: index == 4 ? 2 : 0,
              ),
              pageIndex == index && index != 99
                  ? SvgPicture.asset(imgPath,
                      color: primary_dark,
                      width: marginScale(context, 20),
                      height: marginScale(context, 20),
                      fit: BoxFit.fill)
                  : SvgPicture.asset(imgPath,
                      color: Colors.grey,
                      width: marginScale(context, 20),
                      height: marginScale(context, 20),
                      fit: BoxFit.fill),
              if (isnewnot)
                Container(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  width: 20,
                  height: 20,
                ),
              SizedBox(
                height: marginScale(context, 3),
              ),
              text != null
                  ? Text(
                      text != null ? text : "",
                      style: headLine7.copyWith(
                          color: pageIndex == index && index != 99
                              ? primary_dark
                              : Colors.grey,
                          fontSize: 9),
                    )
                  : SizedBox(
                      height: 0,
                    )
            ],
          ),
        ),
      );
    }

    return Container(
      height: marginScale(context, 65),
      color: bottomBarColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomeIconBar(
              imgPath: 'assets/img/bottomBar1.svg',
              text:  LocaleKeys.bottom_bar_main.tr() ,
              index: 1,
              isNoti: false),
          // CustomeIconBar(
          //     imgPath: 'assets/img/book.svg',
          //     text: 'Книги',
          //     index: 16,
          //     isNoti: false),
          CustomeIconBar(
              imgPath: 'assets/img/search.svg',
              text:  LocaleKeys.bottom_bar_search.tr() ,
              index: 10,
              isNoti: false),
          CustomeIconBar(
              imgPath: 'assets/img/tarifIcon.svg',
              text: LocaleKeys.bottom_bar_tarif.tr(),
              index: 15,
              isNoti: false),
          CustomeIconBar(
              imgPath: 'assets/img/notification.svg',
              text: LocaleKeys.bottom_bar_noty.tr(),
              index: 11,
              isNoti: true),
          CustomeIconBar(
              imgPath: 'assets/img/bottomBar5.svg',
              text: LocaleKeys.bottom_bar_account.tr(),
              index: 5,
              isNoti: false),
        ],
      ),
    );
  }
}

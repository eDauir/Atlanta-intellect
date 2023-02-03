import 'package:barber/generated/locale_keys.g.dart';
import 'package:barber/pages/Profile/account/widgets/Policy.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:barber/res/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:barber/pages/Profile/account/mainProfile.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuItem {
  String text;
  String? icon;
  Function onTap;
  bool? isDarkMode;
  MenuItem(
      {required this.text, this.icon, required this.onTap, this.isDarkMode});
}

class AboutAppPage extends StatefulWidget {
  @override
  State<AboutAppPage> createState() => _AboutAppPageState();
}

class _AboutAppPageState extends State<AboutAppPage> {
  @override
  Widget build(BuildContext context) {
    List<MenuItem> items = [
      MenuItem(
          text: 'Пользовательское соглашение',
          icon: 'assets/img/setting.svg',
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Privacy()));
          }),
      MenuItem(
          text: 'Политика конфиденциальности',
          icon: 'assets/img/profile1.svg',
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Privacy()));
          }),
    ];

    return Scaffold(
      appBar: showAppBar(context, LocaleKeys.profile_about_app.tr()),
      body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              sizeHeight(50),
              SvgPicture.asset('assets/img/aboutApp.svg'),
              sizeHeight(15),
              Text(
                'Версия 1.12.5',
                style: headLine5Reg.copyWith(color: greyColor),
              )
            ],
          ),
          sizeHeight(42),
          ...items
              .map((e) => wrapItem(context, text: e.text, onPress: e.onTap)),
        ],
      ),
    );
  }
}

wrapItem(context, {required String text, required Function onPress}) {
  return Container(
    padding: EdgeInsets.only(
        left: marginScaleWC(15),
        top: marginScaleWC(12),
        bottom: marginScaleWC(12)),
    decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(width: 1, color: Colors.grey.withOpacity(0.5)))),
    child: TextButton(
        onPressed: () {
          onPress();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              textScaleFactor: textScale(context),
              style: headLine5Reg,
            ),
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: darkColor,
              size: 18,
            )
          ],
        )),
  );
}

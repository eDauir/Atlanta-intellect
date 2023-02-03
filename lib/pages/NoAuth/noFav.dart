import 'package:barber/res/style/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget noFav(context) {
  return Container(
      padding: EdgeInsets.only(top: marginScale(context, 30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/img/noFav.svg',
            width: 300,
          ),
          SizedBox(
            height: marginScale(context, 20),
          ),
          Text(
            'Нажмите 💟 на курсах, которое вас заинтересовало, и мы сохраним его здесь',
            textScaleFactor: textScale(context),
            style: headLine4Reg,
            textAlign: TextAlign.center,
          )
        ],
      ));
}

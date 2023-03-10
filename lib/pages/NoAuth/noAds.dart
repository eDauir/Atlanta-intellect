import 'package:barber/res/style/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget noAds({required context, String? text, bool noText = true , String ? assets}) {
  return Container(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        height: marginScale(context, 30),
      ),
      SvgPicture.asset(
        assets ?? 'assets/img/noAds.svg',
        width: marginScale(context, 230),
      ),
      SizedBox(
        height: 15,
      ),
      Text(
        'Здесь будут появляться уроки которые вы изучаете',
        textScaleFactor: textScale(context),
        textAlign: TextAlign.center,
        style: headLine4Reg,
      ),
      SizedBox(
        height: 15,
      ),
      if (noText)
        Text(
          text ?? 'К сожалению, ничего не найден, проверьте еще раз.',
          textScaleFactor: textScale(context),
          style: headLine4Reg,
          textAlign: TextAlign.center,
        )
    ],
  ));
}

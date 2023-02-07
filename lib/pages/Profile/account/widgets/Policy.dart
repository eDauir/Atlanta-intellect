import 'package:barber/pages/list/spisok.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:barber/res/widgets/widgets.dart';
import 'package:flutter/material.dart';

class Privacy extends StatelessWidget {
  const Privacy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar(context, 'Политика конфиденциальности',
          'assets/img/close-circle.svg'),
      body: SingleChildScrollView(
          child: Column(children: [
        ...zhigit
            .map((e) => textPolicy(context, e['num'], e['title'], e['value']))
      ])),
    );
  }

  Padding textPolicy(
      BuildContext context, String num, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                num,
                textScaleFactor: textScale(context),
                style: Theme.of(context).textTheme.headline4,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Container(
                  width: marginScale(context, 280),
                  child: Text(
                    title,
                    textScaleFactor: textScale(context),
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              value,
              textScaleFactor: textScale(context),
              style: headLine5Reg.copyWith(
                color: greyColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:barber/api/Tarif/ITarif.dart';
import 'package:barber/provider/globalData.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:barber/res/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

enum enumTarifBg { purple, orange }

class TarifPage extends StatefulWidget {
  @override
  State<TarifPage> createState() => _TarifPageState();
}

class _TarifPageState extends State<TarifPage> {
  List<ITarif> tarifs = [];
  bool isBuy = false;
  int indexBuyTarif = -1;

  getInitData() async {
    tarifs = context.read<GlobalData>().tarifs;
    isBuy = context.read<GlobalData>().isBuyTarif;
    indexBuyTarif = context.read<GlobalData>().buyTarifIndex;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getInitData();
  }

  @override
  Widget build(BuildContext context) {
    return (Container(
      child: Column(
        children: [
          sizeHeight(30),
          ...tarifs.asMap().entries.map((e) {
            return (buildItemForTarif(context,
                bg: e.key == 1 ? enumTarifBg.purple : enumTarifBg.orange,
                title: e.value.name ?? 'NON NAME',
                text: e.value.about ??
                    'Неограниченный доступ ко всем курсам e-Club, включая выбранную вами программу, на целый год. Ежегодное автоматическое обновление подписки',
                time: e.value.day ?? '0',
                price: e.value.price ?? '0',
                index: e.key));
          }),
          sizeHeight(20),
        ],
      ),
    ));
  }

  buildItemForTarif(BuildContext context,
      {required enumTarifBg bg,
      required String title,
      required String text,
      required String price,
      required String time,
      required int index}) {
    String startColor = '';
    String endColor = '';

    String textTime = '';

    int timeInt = int.parse(time);

    if (timeInt < 28) {
      textTime = '${timeInt} дней';
    } else if (timeInt >= 28 && timeInt <= 30) {
      textTime = 'в месяц';
    } else if (timeInt >= 365) {
      textTime = 'в год';
    }

    switch (bg) {
      case enumTarifBg.orange:
        startColor = '#FEB692';
        endColor = '#EA5455';
        break;
      case enumTarifBg.purple:
        startColor = '#CE9FFC';
        endColor = '#7367F0';
        break;
      default:
    }

    return Container(
      margin: EdgeInsets.only(bottom: marginScaleWC(15)),
      child: TextButton(
        style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(
                vertical: 0, horizontal: marginScaleWC(15))),
        onPressed: () {
          String tokenLogin = context.read<GlobalData>().loginToken ?? '';
          if (tokenLogin.isEmpty) {
            showModalDonAuth(context);
            return;
          }
          if (isBuy && indexBuyTarif == index) {
            showBoughtTarif(context, title);
          } else {
            showModalBuyTarif(context, name: title, price: price);
          }
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(marginScaleWC(15)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(marginScaleWC(20)),
            gradient: LinearGradient(
                colors: [
                  HexColor(startColor),
                  HexColor(endColor),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomRight,
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(color: colorWhite),
                textScaleFactor: textScaleWC(),
              ),
              sizeHeight(20),
              Text(
                text,
                style: headLine5Reg.copyWith(color: colorWhite),
                textScaleFactor: textScaleWC(),
                textAlign: TextAlign.start,
              ),
              sizeHeight(10),
              Text(
                '${MoneyFormat.get(price)} ₸/$textTime',
                textScaleFactor: textScaleWC(),
                style: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(color: colorWhite),
              )
            ],
          ),
        ),
      ),
    );
  }
}

showModalBuyTarif(context, {required String name, required String price}) {
  return showModal(
      context,
      Column(
        children: [
          SvgPicture.asset('assets/img/tarifModal.svg'),
          sizeHeight(30),
          Text(
            name,
            style: Theme.of(context)
                .textTheme
                .headline3!
                .copyWith(color: primary_color),
            textAlign: TextAlign.center,
            textScaleFactor: textScaleWC(),
          ),
          sizeHeight(15),
          Text(
            'Вы будете направлены в систему оплаты тарифа',
            style: headLine5Reg.copyWith(color: darkColor),
            textAlign: TextAlign.center,
            textScaleFactor: textScaleWC(),
          ),
          sizeHeight(20),
          ElevatedButton(onPressed: () async {}, child: Text('Перейти')),
          sizeHeight(10),
          cancelBtn(context)
        ],
      ));
}

showBoughtTarif(context, String title) {
  return showModal(
      context,
      Column(
        children: [
          SvgPicture.asset('assets/img/tarifModal.svg'),
          sizeHeight(30),
          Text(
            title ?? 'Тариф',
            style: Theme.of(context).textTheme.headline3,
            textAlign: TextAlign.center,
          ),
          sizeHeight(15),
          Text(
            'Вы купили этот тариф',
            style: headLine5Reg,
            textScaleFactor: textScaleWC(),
            textAlign: TextAlign.center,
          ),
          sizeHeight(20),
          cancelBtn(context)
        ],
      ));
}

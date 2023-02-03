import 'package:barber/api/Wallet/IWallet.dart';
import 'package:barber/api/Wallet/walletApi.dart';
import 'package:barber/api/payboxApi.dart';
import 'package:barber/pages/Profile/account/vars.dart';
import 'package:barber/pages/Welcome/item.dart';
import 'package:barber/pages/product_page/components/test.dart';
import 'package:barber/provider/globalData.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:barber/res/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';

class WalletTenge extends StatefulWidget {
  Function setS;
  bool isUnit;
  WalletTenge({Key? key, this.isUnit = false, required this.setS})
      : super(key: key);
  @override
  State<WalletTenge> createState() => _WalletTengeState();
}

class _WalletTengeState extends State<WalletTenge> {
  int availableSum = 0;
  List<IBoughtUnit> unitData = [];

  bool isEnableBuyBtn = false;

  List amounts = [
    '4990',
    '14990',
    '24990',
    '49990',
  ];

  getAllAmountUnit() async {
    unitData = await getBoughtUnit();
    if (unitData.isNotEmpty) {
      availableSum = context.read<GlobalData>().unitTotalCount -
          int.parse(unitData[0].sum ?? '0');
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState(); // async is not allowed on initState() directly
    if (widget.isUnit) {
      getAllAmountUnit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            IconButton(
                onPressed: () async {
                  Navigator.pop(context);
                  widget.setS();

                  // Navigator.pushReplacementNamed(context, routeName);

                  // // Navigator.pop(context);
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       settings: RouteSettings( isInitialRoute: true) ,
                  //         builder: (context) => WalletPage(
                  //               isUnit: widget.isUnit,
                  //             )));
                },
                icon: SvgPicture.asset('assets/img/arrowBack.svg')),
          ],
        ),
        title: Text(
          'Пополнить единицу',
          textScaleFactor: textScale(context),
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      body: (widget.isUnit == true && unitData.isEmpty)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: marginScale(context, 15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Выберите сумму пополнение',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    SizedBox(
                      height: marginScale(context, 20),
                    ),
                    if (widget.isUnit == false)
                      Column(
                        children: [
                          ...amounts.map((e) {
                            return buildItemCard(context, amount: e,
                                onPress: () async {
                              var res = await walletAddPaybox(e,
                                  'Пополнение баланса', 'addWallet', authToken);

                              if (res != false) if (await canLaunchUrl(
                                  Uri.parse(res))) {
                                await launchUrl(Uri.parse(res));
                              } else
                                print('DONT OPEN');
                              else
                                print('ERROR');
                            }, isBlock: false);
                          }),
                        ],
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Padding buildItemCard(BuildContext context,
      {required String amount,
      required Function onPress,
      String? unit,
      bool isBlock = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isBlock ? Colors.red : Colors.white,
            elevation: 0.1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: isBlock
              ? null
              : () async {
                  return await onPress();
                },
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: SvgPicture.asset('assets/img/tg.svg'),
              ),
              Text(
                unit != null ? '${unit} = ${amount} ' : amount,
                style: Theme.of(context).textTheme.headline2,
              ),
            ],
          )),
    );
  }
}

showReplenish(context, Function refresh) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      int numWidget = 0;
      List<String> amounts = [
        '4990',
        '14990',
        '24990',
        '49990',
      ];

      String? dropValue;

      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(marginScale(context, 20)))),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    SvgPicture.asset('assets/img/topupModal.svg'),
                    sizeHeight(20),
                    Text(
                      'Пополнить',
                      style: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(color: primary_color),
                      textAlign: TextAlign.center,
                    ),
                    sizeHeight(15),
                    DropdownButton(
                        hint: Text(
                          'Сумма',
                          style: headLine5Reg.copyWith(color: greyColor),
                        ),
                        value: dropValue,
                        items: [
                          ...amounts.map((e) {
                            return DropdownMenuItem(value: e, child: Text(e));
                          })
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            dropValue = value;
                          });
                        }),
                    sizeHeight(20),
                    Text(
                      'Выберите сумму пополнения. Вы будете перенаправлены в систему оплаты',
                      style: headLine5Reg,
                      textAlign: TextAlign.center,
                    ),
                    sizeHeight(15),
                    ElevatedButton(
                        onPressed: () async {
                          String? token = context.read<GlobalData>().loginToken;
                          if (dropValue == null || token == null) return;
                          var res = await walletAddPaybox(dropValue,
                              'Пополнение баланса', 'addWallet', token);

                          if (res !=
                              false) if (await canLaunchUrl(Uri.parse(res))) {
                            await launchUrl(Uri.parse(res));
                          } else
                            print('DONT OPEN');
                          else
                            print('ERROR');

                          await Future.delayed(Duration(milliseconds: 900));
                          while (WidgetsBinding.instance?.lifecycleState !=
                              AppLifecycleState.resumed) {
                            await Future.delayed(Duration(milliseconds: 100));
                          }

                          await refresh(1 , 'def');
                          Navigator.pop(context);
                        },
                        child: Text('Перейти')),
                    sizeHeight(10),
                    cancelBtn(
                      context,
                    ),
                  ],
                )
              ],
            );
          },
        ),
      );
    },
  );
}

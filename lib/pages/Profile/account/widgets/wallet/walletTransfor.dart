import 'package:barber/api/Wallet/walletApi.dart';
import 'package:barber/provider/globalData.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:barber/res/widgets/inputWidget.dart';
import 'package:barber/res/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

showModalTransfor(context, Function restartWallet) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      int numWidget = 0;
      String nameTransfer = '';
      TextEditingController idController = TextEditingController();
      TextEditingController sumController = TextEditingController();

      bool isNotFound = false;

      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(marginScale(context, 20)))),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            if (numWidget == 0) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  sendItem(context),
                  Column(
                    children: [
                      Text(
                        'Введите ID получателя',
                        style: headLine5Reg,
                        textAlign: TextAlign.center,
                      ),
                      sizeHeight(15),
                      if (isNotFound == true)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Не найдено',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(color: redColor),
                            ),
                            sizeHeight(15),
                          ],
                        ),
                      InputWidget(
                        controller: idController,
                        hintText: 'ID номер',
                      ),
                      sizeHeight(20),
                      ElevatedButton(
                          onPressed: () async {
                            String? authToken =
                                context.read<GlobalData>().loginToken;
                            if (authToken == null || idController.text.isEmpty)
                              return;
                            List res = await checkID(
                                login: authToken, id: idController.text);

                            if (res.length == 0) {
                              setState(() {
                                numWidget = 0;
                                isNotFound = true;
                                nameTransfer = '';
                              });
                            } else {
                              setState(() {
                                nameTransfer = res[0]['name'];
                                ++numWidget;
                                isNotFound = false;
                              });
                            }
                          },
                          child: Text('Далее')),
                      sizeHeight(10),
                      cancelBtn(
                        context,
                      ),
                    ],
                  )
                ],
              );
            } else {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  sendItem(context),
                  Column(
                    children: [
                      Text(
                        'Введите сумму перевода',
                        style: headLine5Reg,
                        textAlign: TextAlign.center,
                      ),
                      sizeHeight(15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            nameTransfer,
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(color: primary_color),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                      sizeHeight(15),
                      InputWidget(
                        controller: sumController,
                        hintText: 'Сумма',
                      ),
                      sizeHeight(20),
                      ElevatedButton(
                          onPressed: () async {
                            String? authToken =
                                context.read<GlobalData>().loginToken;

                            if (authToken == null) {
                              final snac = SnackBar(
                                  content: Text('Ошибка! Повторите попытку'));
                              ScaffoldMessenger.of(context).showSnackBar(snac);
                            } else {
                              if (idController.text.isEmpty &&
                                  sumController.text.isEmpty) {
                                final snackBar =
                                    SnackBar(content: Text('Не отпрвлено'));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else {
                                var res = await transfer(
                                    login: authToken,
                                    id: idController.text,
                                    amount: sumController.text);
                                if (res == true)  {
                                  final snack = SnackBar(
                                      content: Text('Успешно переведено'));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snack);
                                  await restartWallet(1, 'def');
                                  Navigator.pop(context);
                                } else {
                                  final snac = SnackBar(
                                      content:
                                          Text('Ошибка! Повторите попытку'));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snac);
                                }
                              }
                            }
                          },
                          child: Text('Отправить')),
                      sizeHeight(10),
                      cancelBtn(context, isShowPop: false, press: () {
                        setState(() => numWidget = 0);
                      }),
                    ],
                  )
                ],
              );
            }
          },
        ),
      );
    },
  );
}

sendItem(context) {
  return Column(
    children: [
      SvgPicture.asset('assets/img/transferModal.svg'),
      sizeHeight(20),
      Text(
        'Перевод',
        style: Theme.of(context)
            .textTheme
            .headline3!
            .copyWith(color: primary_color),
        textAlign: TextAlign.center,
      ),
      sizeHeight(15),
    ],
  );
}

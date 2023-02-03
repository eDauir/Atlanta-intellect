import 'package:barber/api/payboxApi.dart';
import 'package:barber/provider/globalData.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:barber/res/widgets/inputWidget.dart';
import 'package:barber/res/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class WalletOutput extends StatefulWidget {
  @override
  State<WalletOutput> createState() => _WalletOutputState();
}

class _WalletOutputState extends State<WalletOutput> {
  TextEditingController priceOutputController = TextEditingController();

  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: SvgPicture.asset('assets/img/arrowBack.svg')),
          ],
        ),
        title: Text(
          'Вывод',
          textScaleFactor: textScale(context),
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: marginScale(context, 15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Text(
                'Введите сумму для вывода',
                style: TextStyle(fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 15),
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: 'Сумма',
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    fillColor: HexColor('#F8F8F8'),
                    filled: true),
                controller: priceOutputController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ),
            Text(
              '*Наше приложение не несет ответственности за перевод денег по неправильно указанным реквизитам.',
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 30),
        child: ElevatedButton(
            onPressed: () async {
              String login = context.read<GlobalData>().loginToken ?? '';
              if (login.isEmpty || priceOutputController.text.length < 3)
                return;

              final load = showLoading(context);
              Navigator.of(context).push(load);

              var res = await outFromPaybox('output',
                  priceOutputController.text, 'output products', login, {});
              if (res != false) if (await canLaunchUrl(Uri.parse(res))) {
                await launchUrl(Uri.parse(res));
              } else
                print('DONT OPEN');
              else
                print('ERROR');

              Navigator.of(context).removeRoute(load);
            },
            child: Text(
              'Снять деньги',
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(fontWeight: FontWeight.w600, color: Colors.white),
            )),
      ),
    );
  }
}

showModalWalletOut(BuildContext context, Function reload) {
  TextEditingController sumCon = TextEditingController();
  return showModal(
      context,
      Column(
        children: [
          SvgPicture.asset('assets/img/withdrowModal.svg'),
          sizeHeight(30),
          Text(
            'Вывод',
            textScaleFactor: textScaleWC(),
            style: Theme.of(context)
                .textTheme
                .headline3!
                .copyWith(color: primary_color),
            textAlign: TextAlign.center,
          ),
          sizeHeight(15),
          Text(
            'Введите номер карты и сумму',
            style: headLine5Reg,
            textScaleFactor: textScaleWC(),
          ),
          sizeHeight(15),
          Form(
              child: Column(
            children: [
              InputWidget(
                controller: sumCon,
                hintText: 'Введите сумму',
              ),
              sizeHeight(20),
              ElevatedButton(
                  onPressed: () async {
                    String login = context.read<GlobalData>().loginToken ?? '';
                    if (login.isEmpty || sumCon.text.length < 3) return;

                    final load = showLoading(context);
                    Navigator.of(context).push(load);

                    var res = await outFromPaybox(
                        'output', sumCon.text, 'output products', login, {});
                    if (res != false) if (await canLaunchUrl(Uri.parse(res))) {
                      await launchUrl(Uri.parse(res));
                    } else
                      print('DONT OPEN');
                    else
                      print('error paybox ');

                    await Future.delayed(Duration(milliseconds: 900));
                    while (WidgetsBinding.instance?.lifecycleState !=
                        AppLifecycleState.resumed) {
                      await Future.delayed(Duration(milliseconds: 100));
                    }

                    await reload(1, 'def');

                    Navigator.of(context).removeRoute(load);
                    Navigator.pop(context);
                  },
                  child: Text('Вывести')),
              sizeHeight(10),
              cancelBtn(context)
            ],
          ))
        ],
      ));
}

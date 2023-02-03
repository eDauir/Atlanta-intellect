import 'package:barber/api/Wallet/walletApi.dart';
import 'package:barber/api/payboxApi.dart';
import 'package:barber/pages/Profile/account/vars.dart';
import 'package:barber/provider/globalData.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:barber/res/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WalletAddPage extends StatefulWidget {
  String? id;

  WalletAddPage({Key? key, required this.id}) : super(key: key);
  @override
  State<WalletAddPage> createState() => _WalletAddPageState();
}

class _WalletAddPageState extends State<WalletAddPage> {
  TextEditingController idController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  String name = '';
  bool anim = false;
  final _formKey = GlobalKey<FormState>();
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
          'Перевод',
          textScaleFactor: textScale(context),
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: marginScale(context, 15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Введите ID',
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(20),
                      suffixIcon: IconButton(
                        splashRadius: 25,
                        iconSize: 25,
                        onPressed: () async {
                          if (idController.text.isEmpty) {
                            setState(() {
                              name = 'Не найдено';
                            });
                          } else {
                            var res = await checkID(
                                login: authToken, id: idController.text);
                            anim = true;
                            setState(() {
                              if (res.length == 0) {
                                name = 'Не найдено';
                              } else
                                name = res[0]['name'];
                            });
                          }
                        },
                        icon: Icon(Icons.arrow_circle_right_outlined),
                      ),
                      isDense: true,
                      hintText: 'ID',
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.only(
                              bottomLeft: anim
                                  ? Radius.circular(0)
                                  : Radius.circular(10),
                              bottomRight: anim
                                  ? Radius.circular(0)
                                  : Radius.circular(10),
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      fillColor: HexColor('#F8F8F8'),
                      filled: true),
                  controller: idController,
                ),
                AnimatedContainer(
                  alignment: Alignment.centerLeft,
                  duration: Duration(milliseconds: 300),
                  height: anim ? 50 : 0,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: HexColor('#6F3DFF'),
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      name,
                      style: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Введите сумму',
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Некорректно введено';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: 'Сумма',
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.only(
                                bottomLeft: anim
                                    ? Radius.circular(0)
                                    : Radius.circular(10),
                                bottomRight: anim
                                    ? Radius.circular(0)
                                    : Radius.circular(10),
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        fillColor: HexColor('#F8F8F8'),
                        filled: true),
                    controller: amountController,
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {


                      }

                      if (idController.text == widget.id) {
                        final snac = SnackBar(
                            content: Text('Ошибка! Повторите попытку'));
                        ScaffoldMessenger.of(context).showSnackBar(snac);
                      } else {
                        if (idController.text.isEmpty &&
                            amountController.text.isEmpty) {
                          final snackBar =
                              SnackBar(content: Text('Не отпрвлено'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          var res = await transfer(
                              login: authToken,
                              id: idController.text,
                              amount: amountController.text);
                          if (res == true) {
                            final snack =
                                SnackBar(content: Text('Успешно переведено'));
                            ScaffoldMessenger.of(context).showSnackBar(snack);
                            Navigator.pop(context);
                          } else {
                            final snac = SnackBar(
                                content: Text('Ошибка! Повторите попытку'));
                            ScaffoldMessenger.of(context).showSnackBar(snac);
                          }
                        }
                      }


                      
                    },
                    child: Text('Перевод'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

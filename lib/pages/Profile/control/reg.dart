import 'package:barber/api/checkAuth.dart';
import 'package:barber/reload.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:barber/res/widgets/inputWidget.dart';
import 'package:barber/res/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

import '../../../api/profileApi.dart';
import '../../../provider/globalData.dart';

class RegPage extends StatefulWidget {
  const RegPage({Key? key}) : super(key: key);

  @override
  RegPageState createState() => RegPageState();
}

class RegPageState extends State<RegPage> {
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final mailController = TextEditingController();
  final passController = TextEditingController();
  final rePassController = TextEditingController();
  String name = '';
  late String surname;
  late String mail;
  late String pass;
  late String rePass;
  late String textError;
  bool regChecked = false;
  bool regError = false;
  bool registrationEnd = false;
  bool wrongMail = false;
  bool passwordVisible = false;
  bool rePassVisible = false;
  bool profileChecked = false;

  @override
  void initState() {
    super.initState();
    checkAuth();
  }



  checkAuth() async {
    var login = await getCheckedLogin();
    if (mounted) {
      if (login.isNotEmpty) {
        context.go('/profile');
      } else {
        setState(() {
          profileChecked = true;
        });
      }
    }
  }

  Future<void> waitLogin() async {
    mail = mailController.text;

    var resultLogin = await authQuery('login', mail, 'none');

    name = resultLogin[0]['name'];
    surname = resultLogin[0]['surname'];
    setState(() {});
  }

  Future<void> waitPass() async {
    pass = passController.text;

    var resultPass = await authQuery('password', mail, pass);

    await encryptedSharedPreferences
        .setString('login', resultPass)
        .then((bool success) async {
      if (success) {
        await encryptedSharedPreferences.setString('checkedLogin', resultPass);
      } else {}
    });

    if (resultPass != null) {
      await getInitDataWithToken(context: context, tokenLogin: resultPass);
    }

    context
        .read<GlobalData>()
        .setLoginTokenWithoutNoti(resultPass == null ? '' : resultPass);
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    mailController.dispose();
    passController.dispose();
    rePassController.dispose();
    super.dispose();
  }

  Future<void> regCheck() async {
    setState(() {
      name = nameController.text;
      surname = surnameController.text;
      mail = mailController.text;
      pass = passController.text;
      rePass = rePassController.text;
    });

    if (name.isNotEmpty &&
        surname.isNotEmpty &&
        mail.isNotEmpty &&
        pass.isNotEmpty &&
        rePass.isNotEmpty) {
      if (rePass != pass) {
      } else {
        if (isEmail(mail)) {
          var regResult =
              await regQuery('mailCheck', name, surname, mail, pass);
          if (regResult == true) {
            setState(() {
              regChecked = true;
            });
          } else {
            setState(() {
              textError = "Указанный адрес эл. почты уже используется";
              wrongMail = true;
              regError = true;
            });
          }
        } else {}
      }
    } else {
      setState(() {
        textError = "Заполите все поля";
        regError = true;
      });
    }
  }

  Future<void> regPut() async {
    var regResult = await regQuery('loadRegData', name, surname, mail, pass);
    if (regResult == true) {
      setState(() {
        registrationEnd = true;
      });
      showCongrats(context, onPress: () {
        context.go('/auth');
      });
    }
  }

  Widget rulesForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Center(
              child: Text(
                'Политика конфиденциальности и Условия использования',
                style: Theme.of(context).textTheme.headline3,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Center(
            child: Text(
              'Передавая Оператору персональные и иные данные посредством Сайта, Пользователь подтверждает свое согласие на использование указанных данных на условиях, изложенных в настоящей Политике конфиденциальности.\n\nЕсли Пользователь не согласен с условиями настоящей Политики конфиденциальности, он обязан прекратить использование Сайта.\n\nБезусловным акцептом настоящей Политики конфиденциальности является начало использования Сайта Пользователем.',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: registrationEnd
              ? Row(
                  children: const [
                    Text(
                      ' Регистрация успешно завершена',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                )
              : const Text(''),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 50),
                child: registrationEnd
                    ? ElevatedButton(
                        onPressed: () async {
                          // final load = showLoading(context);
                          // Navigator.of(context).push(load);
                          // await waitPass();
                          // Navigator.of(context).removeRoute(load);
                          context.go('/auth');
                        },
                        child: const Text('Войти'),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          regPut();
                          // setState(() {
                          //   registrationEnd = true;
                          // });
                        },
                        child: const Text('Я согласен'),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget regForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        showMainIconCenter(),
        // Text(
        //   'Вход в свой аккаунт',
        //   style: Theme.of(context).textTheme.headline1,
        // ),
        sizeHeight(40),
        InputWidget(
          AutovalidateModeSetting: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (nameController.text.isEmpty) {
              return 'Обьязательно';
            }
            if (nameController.text.length < 2) {
              return 'Слишком коротко';
            }
            return null;
          },
          controller: nameController,
          hintText: 'Укажите Имя',
          prefixIconPath: 'assets/img/inputUser.svg',
        ),
        sizeHeight(12),
        InputWidget(
          AutovalidateModeSetting: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (surnameController.text.isEmpty) {
              return 'Обьязательно';
            }
            if (surnameController.text.length < 2) {
              return 'Слишком коротко';
            }
            return null;
          },
          controller: surnameController,
          hintText: 'Укажите Фамилию',
          prefixIconPath: 'assets/img/inputUser.svg',
        ),
        sizeHeight(12),
        InputWidget(
          AutovalidateModeSetting: AutovalidateMode.onUserInteraction,
          validator: (val) =>
              !isEmail(mailController.text) ? "Неверный формат" : null,
          controller: mailController,
          hintText: 'Укажите почту',
          prefixIconPath: 'assets/img/inputEmail.svg',
        ),

        sizeHeight(12),
        InputWidget(
          AutovalidateModeSetting: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (passController.text.isEmpty) {
              return 'Обьязательно';
            }
            if (passController.text.length < 6) {
              return 'Минимум 6 символов';
            }
            return null;
          },
          controller: passController,
          hintText: 'Придумайте пароль',
          prefixIconPath: 'assets/img/inputPassword.svg',
          isPasswordField: true,
        ),

        sizeHeight(12),
        InputWidget(
          AutovalidateModeSetting: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (rePassController.text != passController.text) {
              return 'Пароль не совпадает';
            }
            return null;
          },
          controller: rePassController,
          hintText: 'Подтвердите новый пароль',
          prefixIconPath: 'assets/img/inputPassword.svg',
          isPasswordField: true,
        ),

        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: regError
              ? Row(
                  children: [
                    Text(
                      ' $textError',
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(color: Colors.red),
                    ),
                  ],
                )
              : const Text(''),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                loadRequest(context, regCheck);
              },
              child: const Text('Зарегистрироваться'),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        removeFocus(context);
      },
      child: Container(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 110),
        child: profileChecked
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width -
                                    marginScaleWC(50)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(),
                                  child: regChecked ? rulesForm() : regForm(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'У меня есть аккаунт.',
                        style: headLine5Reg.copyWith(color: greyColor),
                      ),
                      TextButton(
                          onPressed: () {
                            context.go('/auth');
                          },
                          child: Text('Войти',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(color: primary_color)))
                    ],
                  )
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

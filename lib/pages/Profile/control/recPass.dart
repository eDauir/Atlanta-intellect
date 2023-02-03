import 'package:barber/api/checkAuth.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:barber/res/widgets/inputWidget.dart';
import 'package:barber/res/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';
import '../../../api/profileApi.dart';
import '../../../provider/globalData.dart';

class RecPass extends StatefulWidget {
  const RecPass({Key? key}) : super(key: key);

  @override
  RecPassState createState() => RecPassState();
}

class RecPassState extends State<RecPass> {
  bool recSuccess = false;
  bool takeCodeRes = false;
  bool checkCodeRes = false;
  bool recPassRes = false;
  bool mailError = false;
  bool codeError = false;
  bool passError = false;
  bool passwordVisible1 = false;
  bool passwordVisible2 = false;
  late String errorText;
  late String mail;
  late String code;
  late String pass;
  late String rePass;
  late String name;
  late String surname;
  final mailController = TextEditingController();
  final codeController = TextEditingController();
  final passController = TextEditingController();
  final rePassController = TextEditingController();
  bool profileChecked = false;

  @override
  void initState() {
    checkAuth();
    super.initState();
  }

  checkAuth() async {
    var login = await getCheckedLogin();
    if (login.isNotEmpty) {
      context.go('/profile');
    } else {
      setState(() {
        profileChecked = true;
      });
    }
  }

  @override
  void dispose() {
    mailController.dispose();
    codeController.dispose();
    passController.dispose();
    rePassController.dispose();
    super.dispose();
  }

  Future<void> takeCode() async {
    mail = mailController.text;

    if (isEmail(mail)) {
      var httpResult =
          await recoveryQuery('pass', 'takeCode', mail, 'none', 'none');
      if (httpResult == false) {
        setState(() {
          errorText = "Аккаунт не найден";
          mailError = true;
        });
      } else {
        setState(() {
          name = httpResult[0]['name'];
          surname = httpResult[0]['surname'];
          takeCodeRes = true;
        });
      }
    } else {}
  }

  Future<void> checkCode() async {
    code = codeController.text;

    if (code.length == 6) {
      var httpResult =
          await recoveryQuery('pass', 'checkCode', mail, 'none', code);
      if (httpResult == true) {
        setState(() {
          checkCodeRes = true;
        });
      } else {
        setState(() {
          errorText = "Неверный код";
          codeError = true;
        });
      }
    } else {
      setState(() {
        errorText = "Неверный код";
        codeError = true;
      });
    }
  }

  Future<void> recPass() async {
    pass = passController.text;
    rePass = rePassController.text;

    if (pass.isEmpty) {
      setState(() {
        errorText = "Заполните поле";
        passError = true;
        recPassRes = true;
      });
    } else {
      if (pass == rePass) {
        var httpResult =
            await recoveryQuery('pass', 'changePass', mail, pass, code);
        if (httpResult == true) {
          setState(() {
            recSuccess = true;
            passError = false;
            recPassRes = true;
          });
          showCongrats(context, onPress: () {
            context.go('/');
          });
        } else {
          setState(() {
            errorText = "Не удалось";
            passError = true;
            recPassRes = true;
          });
        }
      } else {
        errorText = "";
        passError = true;
      }
    }
  }

  Widget takeCodeForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        showMainIconCenter(),
        Padding(
          padding: EdgeInsets.only(top: marginScaleWC(30)),
          child: InputWidget(
            AutovalidateModeSetting: AutovalidateMode.onUserInteraction,
            controller: mailController,
            prefixIconPath: 'assets/img/inputEmail.svg',
            validator: (val) =>
                !isEmail(mailController.text) ? "Неверный формат" : null,
            onFieldSubmitted: (value) async {
              final load = showLoading(context);
              Navigator.of(context).push(load);
              await takeCode();
              ;
              Navigator.of(context).removeRoute(load);
            },
            hintText: 'Введите адрес эл. почты',
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: mailError
              ? Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.circleExclamation,
                      color: Colors.red,
                      size: 16,
                    ),
                    Text(
                      ' $errorText',
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
          padding: EdgeInsets.only(top: marginScaleWC(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 50),
                child: ElevatedButton(
                  onPressed: () {
                    takeCode();
                  },
                  child: const Text('Далее'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget checkCodeForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_circle,
                  size: 23,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(name,
                      style: TextStyle(
                          fontSize: context.read<GlobalData>().isDevice == 1
                              ? 18
                              : 16)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: Text(surname,
                      style: TextStyle(
                          fontSize: context.read<GlobalData>().isDevice == 1
                              ? 18
                              : 16)),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Text(
            'Письмо с кодом подтверждения отправлено на эл. почту $mail.',
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: marginScaleWC(20)),
          child: InputWidget(
            controller: codeController,
            isPasswordField: true,
            prefixIconPath: 'assets/img/inputPassword.svg',
            onFieldSubmitted: (value) async {
              final load = showLoading(context);
              Navigator.of(context).push(load);
              await checkCode();
              Navigator.of(context).removeRoute(load);
            },
            hintText: 'Введите код',
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: codeError
              ? Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.circleExclamation,
                      color: Colors.red,
                      size: 16,
                    ),
                    Text(
                      ' $errorText',
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
          padding: EdgeInsets.only(top: marginScaleWC(30)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 50),
                child: ElevatedButton(
                  onPressed: () {
                    checkCode();
                  },
                  child: const Text('Далее'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget recPassForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ListTile(
        //   title: Padding(
        //     padding: const EdgeInsets.only(bottom: 5),
        //     child: Center(
        //       child: Text(
        //         'Восстановить пароль',
        //         style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
        //       ),
        //     ),
        //   ),
        // ),
        showMainIconCenter(),

        Padding(
          padding: EdgeInsets.only(top: marginScaleWC(30)),
          child: InputWidget(
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
        ),

        Padding(
          padding: EdgeInsets.only(top: 10),
          child: InputWidget(
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
        ),

        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: recPassRes
              ? passError
                  ? Row(
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.circleExclamation,
                          color: Colors.red,
                          size: 16,
                        ),
                        Text(
                          ' $errorText',
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(color: Colors.red),
                        ),
                      ],
                    )
                  : Row(
                      children: const [
                        FaIcon(
                          FontAwesomeIcons.check,
                          color: Colors.green,
                          size: 16,
                        ),
                        Text(
                          ' Пароль успешно создан',
                          style: TextStyle(color: Colors.green),
                        ),
                      ],
                    )
              : const Text(''),
        ),

        Padding(
          padding: EdgeInsets.only(top: marginScaleWC(30)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 50),
                child: ElevatedButton(
                  onPressed: () {
                    recPass();
                  },
                  child: const Text('Создать новый пароль'),
                ),
              ),
            ],
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
                                    marginScaleWC(20)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(),
                                  child: takeCodeRes
                                      ? checkCodeRes
                                          ? recPassForm()
                                          : checkCodeForm()
                                      : takeCodeForm(),
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
                        'Я вспомнил пароль.',
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

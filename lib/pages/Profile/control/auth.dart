import 'package:barber/api/checkAuth.dart';
import 'package:barber/api/profileApi.dart';
import 'package:barber/pages/Profile/account/widgets/Policy.dart';
import 'package:barber/provider/globalData.dart';
import 'package:barber/reload.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:barber/res/widgets/inputWidget.dart';
import 'package:barber/res/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  bool loginChecked = false;
  bool loginError = false;
  bool passwordError = false;
  bool passwordVisible = false;
  late String name;
  late String surname;
  late String login;
  late String password;
  late String errorText;
  final loginController = TextEditingController();
  final passController = TextEditingController();
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

  Future<void> waitLogin() async {
    login = loginController.text;

    if (login.isEmpty) {
      setState(() {
        errorText = "Заполните поле";
        loginError = true;
      });
    } else {
      var resultLogin = await authQuery('login', login, 'none');
      if (resultLogin == false) {
        setState(() {
          errorText = 'Аккаунт не найден';
          loginError = true;
        });
      } else {
        name = resultLogin[0]['name'];
        surname = resultLogin[0]['surname'];
        setState(() {
          loginChecked = true;
        });
      }
    }
  }

  Future<void> waitPass() async {
    password = passController.text;

    if (password.isEmpty) {
      setState(() {
        errorText = "Заполните поле";
        passwordError = true;
      });
    } else {
      var resultPass = await authQuery('password', login, password);
      if (resultPass == false) {
        setState(() {
          errorText = "Неверный пароль";
          passwordError = true;
        });
      } else {
        await encryptedSharedPreferences
            .setString('login', resultPass)
            .then((bool success) async {
          if (success) {
            await encryptedSharedPreferences.setString(
                'checkedLogin', resultPass);
          } else {}
        });

        if (resultPass != null) {
          await getInitDataWithToken(context: context, tokenLogin: resultPass);
        }

        context.go('/profile');
        context
            .read<GlobalData>()
            .setLoginTokenWithoutNoti(resultPass == null ? '' : resultPass);
      }
    }
  }

  @override
  void dispose() {
    // loginController.dispose();
    // passController.dispose();
    super.dispose();
  }

  Widget authLog() {
    return Container(
      // color: Colors.amber,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showMainIconCenter(),
          sizeHeight(80),
          InputWidget(
            controller: loginController,
            AutovalidateModeSetting: AutovalidateMode.onUserInteraction,
            // isPasswordField: true,

            hintText: 'Введите адрес эл. почты',
            prefixIconPath: 'assets/img/inputEmail.svg',
            validator: (value) {
              if (loginController.text.isEmpty) {
                return 'Обьязательно';
              }
              if (loginController.text.length < 2) {
                return 'Слишком коротко';
              }
              return null;
            },
            onFieldSubmitted: (value) async {
              await loadRequest(context, waitLogin);
            },
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: loginError
                  ? Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: marginScaleWC(10)),
                          child: Text(
                            ' $errorText',
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(color: Colors.red),
                          ),
                        ),
                      ],
                    )
                  : const Text(''),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: marginScaleWC(0)),
            child: Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await loadRequest(context, waitLogin);
                },
                child: Text('Продолжить'),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: marginScaleWC(10)),
            child: cancelBtn(context,
                text: 'Продолжить без авторизации',
                isShowPop: false, press: () {
              print('work');
              context.go('/');
            }),
          ),
          Padding(
            padding: EdgeInsets.only(top: marginScaleWC(40)),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Продолжая, я подтверждаю, что ознакомлен с ',
                style: headLine5Reg.copyWith(
                  color: greyColor,
                  fontFamily: 'MontserratAlternates',
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Политикой конфиденциальности ,',
                      style: TextStyle(color: primary_color),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => Privacy()))),
                  TextSpan(
                      text: ' Пользовательское соглашение',
                      style: TextStyle(color: primary_color),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => Privacy()))),
                  TextSpan(text: ' и принимаю их условия'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget authPass() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        showMainIconCenter(),
        sizeHeight(30),
        ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.account_circle,
                size: 23,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize:
                        (context.read<GlobalData>().isDevice == 1) ? 21 : 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  surname,
                  style: TextStyle(
                    fontSize:
                        (context.read<GlobalData>().isDevice == 1) ? 21 : 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        sizeHeight(30),
        InputWidget(
          AutovalidateModeSetting: AutovalidateMode.onUserInteraction,
          controller: passController,
          isPasswordField: true,
          prefixIconPath: 'assets/img/inputPassword.svg',
          validator: (value) {
            // return null;
            if (passController.text.isEmpty) {
              return 'Обьязательно';
            }
            if (passController.text.length < 6) {
              return 'Минимум 6 символов';
            }
            return null;
          },
          onFieldSubmitted: (value) async {
            final load = showLoading(context);
            Navigator.of(context).push(load);
            await waitPass();
            Navigator.of(context).removeRoute(load);
          },
          hintText: 'Введите пароль',
        ),
        if (passwordError)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(top: marginScaleWC(25)),
              child: passwordError
                  ? TextButton(
                      onPressed: () {
                        context.go('/recPass');
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Неправильный пароль. ',
                          style: headLine5Reg.copyWith(color: redColor),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Забыли?',
                                style: TextStyle(color: primary_color)),
                          ],
                        ),
                      ))
                  : const Text(''),
            ),
          ),
        Padding(
          padding: EdgeInsets.only(top: marginScaleWC(30)),
          child: Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final load = showLoading(context);
                Navigator.of(context).push(load);
                await waitPass();
                Navigator.of(context).removeRoute(load);
              },
              child: const Text('Войти'),
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
        // constraints:
        //     BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
        child: profileChecked
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Container(
                      height: MediaQuery.of(context).size.height >
                              marginScaleWC(800)
                          ? MediaQuery.of(context).size.height
                          : marginScaleWC(800),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(),
                          Container(
                            padding: EdgeInsets.only(top: marginScaleWC(150)),
                            constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width -
                                    marginScaleWC(50)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(),
                                  child: loginChecked ? authPass() : authLog(),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: marginScaleWC(60),
                                bottom: marginScaleWC(40)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'У вас нет аккаунта?',
                                  style:
                                      headLine5Reg.copyWith(color: greyColor),
                                ),
                                TextButton(
                                    onPressed: () {
                                      context.go('/reg');
                                    },
                                    child: Text('Создать аккаунт',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5!
                                            .copyWith(color: primary_color)))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

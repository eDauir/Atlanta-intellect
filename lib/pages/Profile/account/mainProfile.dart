import 'dart:convert';
import 'dart:typed_data';
import 'package:barber/api/checkAuth.dart';
import 'package:barber/api/profileApi.dart';
import 'package:barber/generated/locale_keys.g.dart';
import 'package:barber/pages/Favorite/favorite.dart';
import 'package:barber/pages/Profile/account/module/editImage.dart';
import 'package:barber/pages/Profile/account/readProfile.dart';
import 'package:barber/pages/Profile/account/vars.dart';
import 'package:barber/pages/Profile/account/widgets/about_app.dart';
import 'package:barber/pages/Profile/account/widgets/editAvatar.dart';
import 'package:barber/pages/Profile/account/widgets/my_book.dart';
import 'package:barber/pages/Profile/account/widgets/my_course.dart';
import 'package:barber/pages/Profile/account/widgets/settings.dart';
import 'package:barber/pages/Profile/account/widgets/Policy.dart';
import 'package:barber/pages/Profile/account/widgets/wallet/wallet.dart';
import 'package:barber/pages/product_page/components/test.dart';
import 'package:barber/pages/Profile/account/widgets/support.dart';
import 'package:barber/provider/globalData.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:barber/res/widgets/widgets.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cropperx/cropperx.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';

class MenuItem {
  String text;
  String? icon;
  Function onTap;
  bool? isDarkMode;
  MenuItem(
      {required this.text, this.icon, required this.onTap, this.isDarkMode});
}

class MainProdile extends StatefulWidget {
  @override
  State<MainProdile> createState() => _MainProdileState();
}

class _MainProdileState extends State<MainProdile> {
  Uint8List? _croppedImage;
  final OverlayType _overlayType = OverlayType.circle;
  final int _rotationTurns = 0;
  bool imgUpdated = false;
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();

  bool isPreloader = true;

  String? statusUserName;

  loadAvatar(res) {
    imgUpdated = true;
    avatar = res;
    //changeAvatar = res;
    setState(() {});
  }

  String _code = '';
  bool _onEditing = false;

  updateData() {
    setState(() {});
  }

  var login;

  // CHECKMAIl
  bool isError = false;
  bool isSuccessConfirm = false;
  bool isEditCode = false;

  checkAuth() async {
    setState(() {
      isPreloader = true;
    });
    login = await getCheckedLogin();
    if (login.isNotEmpty) {
      print(login);
      // var arr = await getFavoriteCardId(login);
      // if (arr != null) {
      //   context.read<FavoriteData>().setFavoriteCardsId(arr);
      // }
    } else {
      setState(() {
        isPreloader = true;
      });
      profileDetected = false;
      context.go('/auth');
      return;
    }
    isPreloader = false;
    setState(() {});
  }

  avatarNetwork() async {
    if (authToken.isEmpty) return;
    var result = await profileQuery(authToken, 'get');
    avatar = result['main'][0]['avatar'];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    checkAuth();
    avatarNetwork();
  }

  @override
  Widget build(BuildContext context) {
    switch (context.read<GlobalData>().statusUser) {
      case 1:
        statusUserName = 'Эксперт';
        break;
      case 5:
        statusUserName = 'Партнер';
        break;
      default:
        statusUserName = 'Пользователь';
    }
    List<MenuItem> items = [
      MenuItem(
          text: LocaleKeys.profile_courses.tr(),
          icon: 'assets/img/profile1.svg',
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyCourse()));
          }),
      MenuItem(
          text: LocaleKeys.profile_favorite.tr(),
          icon: 'assets/img/profileFav.svg',
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Favorite()));
          }),
      MenuItem(
          text: LocaleKeys.profile_wallet.tr(),
          icon: 'assets/img/wallet.svg',
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => WalletPage()));
          }),
      MenuItem(
          text: LocaleKeys.profile_settings.tr(),
          icon: 'assets/img/setting.svg',
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Settings()));
          }),
      MenuItem(
          text: LocaleKeys.profile_about_app.tr(),
          icon: 'assets/img/aboutIcon.svg',
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AboutAppPage()));
          }),
      MenuItem(
          text: LocaleKeys.profile_help.tr(),
          icon: 'assets/img/support.svg',
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SupportPage()));
          }),
    ];

    if (isPreloader == true || login.isEmpty) {
      return Container(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height - 80),
          child: Center(child: CircularProgressIndicator()));
    } else {
      return Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: CustomPaint(
              foregroundPainter: TopRed(),
            ),
          ),
          Container(
            height: 175,
            width: MediaQuery.of(context).size.width,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(),
            child: Stack(
              children: [
                Transform.translate(
                  offset: Offset(280, -75),
                  child: SvgPicture.asset(
                    'assets/img/topCircleBig.svg',
                  ),
                ),
                Transform.translate(
                  offset: Offset(-80, -75),
                  child: SvgPicture.asset(
                    'assets/img/topCircleMedium.svg',
                  ),
                ),
                Transform.translate(
                  offset: Offset(25, 70),
                  child: SvgPicture.asset(
                    'assets/img/topCircleSmall.svg',
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 105, left: 10, right: 10),
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(0.25),
                                      spreadRadius: 0)
                                ],
                              ),
                              child: CircularProfileAvatar(
                                '',
                                backgroundColor: Colors.white,
                                child: imgUpdated == true
                                    ? Image.memory(
                                        base64Decode(avatar!),
                                        fit: BoxFit.fill,
                                      )
                                    : Image.network(
                                        avatar ?? '',
                                        fit: BoxFit.cover,
                                      ),
                                radius: 50,
                                // imageFit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: 4,
                              right: 0,
                              child: IconButton(
                                onPressed: () async {
                                  var res = await pickerImage();
                                  if (res != null) {
                                    editAvatar(
                                        res,
                                        context,
                                        _overlayType,
                                        _rotationTurns,
                                        authToken,
                                        _croppedImage,
                                        loadAvatar);
                                  }
                                },
                                icon: SvgPicture.asset(
                                    'assets/img/editProfile.svg'),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: marginScale(context, 15),
                      ),
                      Text(
                        '${surnameController.text}\n${nameController.text}',
                        textAlign: TextAlign.center,
                        textScaleFactor: textScale(context),
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      SizedBox(height: marginScaleWC(10)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ID: ${id}. ',
                            style: headLine5Reg.copyWith(color: greyColor),
                          ),
                          sizeHeight(5),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ReadProfile(
                                              updataProfile: updateData,
                                            )));
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Профиль',
                                      textScaleFactor: textScale(context),
                                      style: headLine5Med.copyWith(
                                          color: primary_color)),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    size: 15,
                                    color: primary_color,
                                  )
                                ],
                              )),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  height: 1,
                ),
                SizedBox(
                  height: 20,
                ),
                if (mailStatus == false)
                  itemProfile(
                      text: 'Подтверждение аккаунта',
                      confirm: true,
                      context: context,
                      icon: 'assets/img/confirmMenu.svg',
                      onTap: () async {
                        final load = showLoading(context);
                        Navigator.of(context).push(load);
                        await activeAccQuery(login, null, 'mailSend', '');
                        Navigator.of(context).removeRoute(load);
                        await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (builder) {
                              TextEditingController confirmText =
                                  TextEditingController();

                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            marginScale(context, 20)))),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: marginScale(context, 10)),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(Icons.close))
                                  ],
                                ),
                                content: StatefulBuilder(
                                    builder: (context, StateSetter setState) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                          'assets/img/confirm.svg'),
                                      SizedBox(
                                        height: marginScale(context, 15),
                                      ),
                                      Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Код отправлен на',
                                            style: headLine4Med,
                                          )),
                                      Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            mainMail[0] +
                                                mainMail[1] +
                                                mainMail[2] +
                                                '****@' +
                                                mainMail.split('@').last,
                                            style: headLine4Med,
                                          )),
                                      SizedBox(
                                        height: marginScale(context, 30),
                                      ),
                                      VerificationCode(
                                        digitsOnly: true,
                                        textStyle: TextStyle(
                                            fontSize: 20.0,
                                            color:
                                                isError && isEditCode == false
                                                    ? Colors.red
                                                    : isSuccessConfirm
                                                        ? Colors.green
                                                        : black),
                                        keyboardType: TextInputType.number,
                                        itemSize: 48,
                                        underlineWidth: 2,
                                        underlineUnfocusedColor:
                                            isError && isEditCode == false
                                                ? Colors.red
                                                : isSuccessConfirm
                                                    ? Colors.green
                                                    : null,
                                        fullBorder: true,
                                        underlineColor:
                                            primary_color, // If this is null it will use primaryColor: Colors.red from Theme
                                        length: 4,
                                        cursorColor:
                                            primary_color, // If this is null it will default to the ambient

                                        onCompleted: (String value) {
                                          setState(() {
                                            isEditCode = true;
                                            _code = value;
                                          });
                                        },
                                        onEditing: (bool value) {
                                          setState(() {
                                            isEditCode = true;
                                            _onEditing = value;
                                          });
                                          if (!_onEditing)
                                            FocusScope.of(context).unfocus();
                                        },
                                      ),
                                      SizedBox(
                                        height: marginScale(context, 10),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                marginScale(context, 15)),
                                        child: ElevatedButton(
                                            onPressed: () async {
                                              if (isSuccessConfirm) {
                                                Navigator.pop(context);
                                                return;
                                              }
                                              var isCheck =
                                                  await activeAccQuery(
                                                      login,
                                                      null,
                                                      'mailCheck',
                                                      _code.toString());

                                              if (isCheck == false) {
                                                setState(() {
                                                  isSuccessConfirm = false;
                                                  isEditCode = false;
                                                  isError = true;
                                                });
                                              } else if (isCheck == true) {
                                                setState(
                                                  () {
                                                    mailStatus = true;
                                                    isSuccessConfirm = true;
                                                  },
                                                );

                                                updateData();

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        backgroundColor:
                                                            Colors.green,
                                                        content: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .task_alt_sharp,
                                                              color:
                                                                  Colors.white,
                                                              size: 25,
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  marginScale(
                                                                      context,
                                                                      10),
                                                            ),
                                                            Text(
                                                              'Вы подтвердили аккаунт',
                                                              style: headLine4Med
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .white),
                                                            ),
                                                          ],
                                                        )));
                                              }
                                            },
                                            child: Text(isSuccessConfirm
                                                ? 'Закрыть'
                                                : 'Проверить код')),
                                      ),
                                      SizedBox(
                                        height: marginScale(context, 25),
                                      )
                                    ],
                                  );
                                }),
                              );
                            });
                      }),
                if (mailStatus == true)
                  Column(
                    children: [
                      ...items.map((e) => itemProfile(
                          text: e.text,
                          context: context,
                          onTap: e.onTap,
                          icon: e.icon,
                          isDarkMode: e.isDarkMode ?? false)),
                    ],
                  ),
                itemProfile(
                    text: LocaleKeys.profile_exit.tr(),
                    context: context,
                    onTap: () {
                      showModal(
                          context,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/img/logout.svg'),
                              sizeHeight(15),
                              Text(
                                'Вы действительно хотите выйти?',
                                style: headLine5Reg,
                                textAlign: TextAlign.center,
                              ),
                              sizeHeight(20),
                              ElevatedButton(
                                  onPressed: () async {
                                    await encryptedSharedPreferences.clear();
                                    context
                                        .read<GlobalData>()
                                        .setLoginToken('');
                                    authToken = '';

                                    context.go('/');
                                  },
                                  child: Text(LocaleKeys.profile_exit.tr())),
                              sizeHeight(10),
                              cancelBtn(context)
                            ],
                          ));
                    },
                    isLogout: true)
              ],
            ),
          ),
        ],
      );
    }
  }
}

Widget itemProfile(
    {required String text,
    String? icon,
    required Function onTap,
    bool isLogout = false,
    bool isDel = false,
    bool confirm = false,
    bool isDarkMode = false,
    required BuildContext context}) {
  return Container(
    margin: EdgeInsets.only(bottom: marginScale(context, 10)),
    child: TextButton(
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(black),
          padding:
              MaterialStateProperty.all(EdgeInsets.only(top: 0, bottom: 0))),
      onPressed: () {
        onTap();
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                icon != null
                    ? SvgPicture.asset(
                        icon,
                        color: isDel ? Colors.red : black,
                        width: marginScale(context, 20),
                        height: marginScale(context, 20),
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                      )
                    : SizedBox(
                        width: marginScale(context, 20),
                        height: marginScale(context, 20),
                        child: SvgPicture.asset(
                          'assets/img/exit.svg',
                          width: marginScale(context, 20),
                          height: marginScale(context, 20),
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                        ),
                      ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    text,
                    textScaleFactor: textScaleWC(),
                    style: headLine4Med.copyWith(
                        fontSize: 16,
                        color: isLogout == true || isDel == true
                            ? Colors.red
                            : black),
                  ),
                ),
              ],
            ),
            if (isLogout == false &&
                isDarkMode == false &&
                isDel == false &&
                confirm == false)
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: marginScaleWC(20),
              ),
            if (isDarkMode)
              Switch(
                  value: context.watch<GlobalData>().darkMode,
                  onChanged: ((value) {
                    context.read<GlobalData>().setDarkMode();
                  }))
          ],
        ),
      ),
    ),
  );
}

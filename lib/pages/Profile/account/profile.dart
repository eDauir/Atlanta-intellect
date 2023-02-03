import 'dart:convert';
import 'dart:typed_data';
import 'package:barber/api/checkAuth.dart';
import 'package:barber/pages/NoAuth/noAuth.dart';
import 'package:barber/pages/Profile/account/vars.dart';
import 'package:barber/pages/Profile/account/widgets/activeMail.dart';
import 'package:barber/pages/Profile/account/widgets/deleteAccount.dart';
import 'package:barber/pages/Profile/account/widgets/editAvatar.dart';
import 'package:barber/pages/Profile/account/widgets/editDefault.dart';
import 'package:barber/pages/Profile/account/widgets/editFio.dart';
import 'package:barber/pages/Profile/account/widgets/editPassword.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:barber/res/widgets/widgets.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cropperx/cropperx.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../api/profileApi.dart';
import '../../../provider/globalData.dart';
import 'module/editImage.dart';
import 'module/queries.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key }) : super(key: key);

  @override
  State<Profile> createState() => _Profile();
}

class _Profile extends State<Profile> {
  Uint8List? _croppedImage;
  final OverlayType _overlayType = OverlayType.circle;
  final int _rotationTurns = 0;
  bool imgUpdated = false;
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();

  bool isPreloader = true;

  @override
  void initState() {
    checkAuth();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  loadAvatar(res) {
    imgUpdated = true;
    avatar = res;
    setState(() {});
  }

  checkAuth() async {
    var login = await getCheckedLogin();
    if (login.isNotEmpty) {
      var result = await profileQuery(login, 'get');
      var dataUser = await checkEditor(login);

      if (dataUser != null) {
        if (int.parse(dataUser[0]['editor']) >= 1) {
          isEditor = true;
        } else {
          isEditor = false;
        }
      }
      if (result == false) {
        await encryptedSharedPreferences.clear();
      } else {
        setState(() {
          mainMail = result['actS'][0]['mail'];
          if (result['actS'][0]['activeStatus'].toString() == '1') {
            mailStatus = true;
          }
          authToken = login;
          nameController.text = result['main'][0]['name'];
          surnameController.text = result['main'][0]['surname'];
          loginController.text = result['main'][0]['login'];
          id = result['main'][0]['user_id'];
          aboutController.text = (result['main'][0]['about'] != null)
              ? result['main'][0]['about']
              : '';
          otchController.text = (result['main'][0]['otchestvo'] != null)
              ? result['main'][0]['otchestvo']
              : '';
          avatar = result['main'][0]['avatar'];

          selectedDate = (result['main'][0]['birthday'] != null)
              ? DateTime.parse(result['main'][0]['birthday'])
              : DateTime.parse('1931-01-01');

          pol = (result['main'][0]['pol'] != null)
              ? result['main'][0]['pol']
              : 'Пусто';
          if (pol == 'Мужской') {
            setState(() {
              manChecked = true;
            });
          }
          if (pol == 'Женский') {
            setState(() {
              womanChecked = true;
            });
          }

          teleController.text = (result['main'][0]['telephone'] != null)
              ? result['main'][0]['telephone']
              : 'Не введено';
          addressController.text = (result['main'][0]['geo'] != null)
              ? result['main'][0]['geo']
              : 'Не введено';
          aboutController.text = (result['main'][0]['about'] != null)
              ? result['main'][0]['about']
              : 'Не введено';
          profileDetected = true;
        });
      }
    } else {
      profileDetected = false;
    }
    isPreloader = false;
    setState(() {});
  }

  Future<void> editBirthday(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1930, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      queryToBirthday(authToken, selectedDate);
    }
  }

  Widget giveListTile(int type, String name, IconData? iconName) {
    return ListTile(
      minLeadingWidth: 50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      onTap: (type != 0)
          ? () {
              setState(
                () {
                  if (type == 1) {
                    homeContact = !homeContact;
                  } else {
                    homeSecure = !homeSecure;
                  }
                },
              );
            }
          : null,
      leading: FaIcon(
        iconName,
        size: 25,
      ),
      contentPadding: const EdgeInsets.all(30),
      title: Text(
        name,
        textScaleFactor: textScale(context),
        style: TextStyle(
            fontSize: context.read<GlobalData>().isDevice == 1 ? 25 : 16),
      ),
      trailing: (type != 0)
          ? Icon(
              (type == 1)
                  ? homeContact
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down
                  : homeSecure
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
              size: context.read<GlobalData>().isDevice == 1 ? 45 : 35,
            )
          : const Text(''),
    );
  }

  Widget homeWindow() {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.5),
            child: Column(
              children: [
                giveListTile(0, 'Основные данные', FontAwesomeIcons.house),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 30, left: 30, right: 30),
                  child: Flex(
                    direction: context.read<GlobalData>().isDevice == 1
                        ? Axis.horizontal
                        : Axis.vertical,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProfileAvatar(
                              '',
                              cacheImage: false,
                              radius: 50,
                              child: imgUpdated
                                  ? Image.memory(
                                      base64Decode(avatar ?? ''),
                                      gaplessPlayback: true,
                                    )
                                  : Image.network(
                                      avatar ?? '',
                                      filterQuality: FilterQuality.medium,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            TextButton(
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
                              child: Text(
                                'Изменить',
                                textScaleFactor: textScale(context),
                                style: TextStyle(color: primary_color),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              children: [
                                Text(
                                  'Имя: ',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                                Text(
                                  '${surnameController.text} ${nameController.text} ${otchController.text}',
                                  style: TextStyle(
                                      fontSize:
                                          context.read<GlobalData>().isDevice ==
                                                  1
                                              ? 26
                                              : 16),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await editFio(
                                        context,
                                        authToken,
                                        surnameController,
                                        nameController,
                                        otchController);
                                    await checkAuth();
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: primary_color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 20),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'ID:',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 6),
                                          child: Text(
                                            id,
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Wrap(
                                runAlignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 20),
                                    child: Text(
                                      'Дата рождения: ',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          (selectedDate ==
                                                  DateTime.parse('1931-01-01'))
                                              ? 'Не введено'
                                              : selectedDate
                                                  .toString()
                                                  .split(' ')[0],
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            DateTime? picked =
                                                await showDatePicker(
                                                    builder: (context, child) {
                                                      return Theme(
                                                          data: ThemeData
                                                                  .light()
                                                              .copyWith(
                                                                  colorScheme:
                                                                      ColorScheme.light(
                                                                          primary:
                                                                              primary_color)),
                                                          child: child!);
                                                    },
                                                    locale: Locale('ru'),
                                                    context: context,
                                                    initialDate: selectedDate,
                                                    firstDate:
                                                        DateTime(1950, 8),
                                                    lastDate: DateTime.now());
                                            if (picked != null &&
                                                picked != selectedDate) {
                                              setState(() {
                                                selectedDate = picked;
                                              });
                                              queryToBirthday(
                                                  authToken, selectedDate);
                                            }
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            size: 18,
                                            color: primary_color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Wrap(
                                runAlignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(right: 20),
                                    child: Text(
                                      'Пол: ',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Checkbox(
                                        shape: const CircleBorder(),
                                        checkColor: Colors.white,
                                        activeColor: primary_color,
                                        value: manChecked,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            manChecked = value!;
                                            womanChecked = false;
                                          });
                                          queryToPol(authToken, manChecked);
                                        },
                                      ),
                                      const Text(
                                        'Муж. ',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Checkbox(
                                        shape: const CircleBorder(),
                                        checkColor: Colors.white,
                                        activeColor: primary_color,
                                        value: womanChecked,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            womanChecked = value!;
                                            manChecked = false;
                                          });
                                          queryToPol(authToken, manChecked);
                                        },
                                      ),
                                      const Text(
                                        'Жен. ',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (isEditor)
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Wrap(
                                runAlignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      'Обо мне: ',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      aboutController.text.isEmpty
                                          ? Text('Не введено')
                                          : Expanded(
                                              child: Text(
                                                aboutController.text,
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ),
                                      SizedBox(
                                        height: 20,
                                        child: IconButton(
                                          onPressed: () async {
                                            await editDefault(
                                                context,
                                                authToken,
                                                aboutController,
                                                'Обо мне',
                                                'about');
                                            await checkAuth();
                                          },
                                          padding: EdgeInsets.zero,
                                          icon: Icon(
                                            Icons.edit,
                                            size: 18,
                                            color: primary_color,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(
                        width: 150,
                        child: Text(''),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          mailStatus
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 25, left: 12.5, right: 12.5),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 25,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: borderRadius,
                              boxShadow: [shadow]),
                          child: homeContact
                              ? Column(
                                  children: [
                                    giveListTile(1, 'Контактные данные',
                                        Icons.library_books_outlined),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 30,
                                          right: 30,
                                          bottom: 25,
                                          top: 5),
                                      child: Flex(
                                        direction: context
                                                    .read<GlobalData>()
                                                    .isDevice ==
                                                1
                                            ? Axis.horizontal
                                            : Axis.vertical,
                                        children: [
                                          SizedBox(
                                            width: context
                                                        .read<GlobalData>()
                                                        .isDevice ==
                                                    1
                                                ? 320
                                                : double.infinity,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Адрес эл. почты',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10, bottom: 20),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        mainMail,
                                                        style: const TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: context
                                                        .read<GlobalData>()
                                                        .isDevice ==
                                                    1
                                                ? 320
                                                : double.infinity,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Номер телефона',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        '+' +
                                                            telephoneFormat(
                                                                teleController
                                                                    .text),
                                                        style: const TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                      IconButton(
                                                        onPressed: () async {
                                                          await editDefault(
                                                              context,
                                                              authToken,
                                                              teleController,
                                                              'Номер телефона',
                                                              'tele');
                                                          await checkAuth();
                                                        },
                                                        color: primary_color,
                                                        icon: const Icon(
                                                          Icons.edit,
                                                          size: 18,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: context
                                                        .read<GlobalData>()
                                                        .isDevice ==
                                                    1
                                                ? 320
                                                : double.infinity,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Местоположение',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 20),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        addressController.text,
                                                        style: const TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                      IconButton(
                                                        onPressed: () async {
                                                          await editDefault(
                                                              context,
                                                              authToken,
                                                              addressController,
                                                              'Местоположение',
                                                              'geo');
                                                          await checkAuth();
                                                        },
                                                        color: primary_color,
                                                        icon: const Icon(
                                                          Icons.edit,
                                                          size: 18,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : giveListTile(1, 'Контактные данные',
                                  Icons.library_books_outlined),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 25, left: 12.5, right: 12.5, bottom: 15),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 25,
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: borderRadius,
                                boxShadow: [shadow]),
                            child: homeSecure
                                ? Column(
                                    children: [
                                      giveListTile(
                                          3, 'Настройки', Icons.settings),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 30,
                                            right: 30,
                                            bottom: 25,
                                            top: 5),
                                        child: Flex(
                                          direction: context
                                                      .read<GlobalData>()
                                                      .isDevice ==
                                                  1
                                              ? Axis.horizontal
                                              : Axis.vertical,
                                          children: [
                                            SizedBox(
                                              width: context
                                                          .read<GlobalData>()
                                                          .isDevice ==
                                                      1
                                                  ? 320
                                                  : double.infinity,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Текущий пароль',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.grey),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 10),
                                                    child: Row(
                                                      children: [
                                                        const Text(
                                                          '**********',
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                        IconButton(
                                                          onPressed: () {
                                                            editPassword(
                                                                context,
                                                                authToken,
                                                                oldPasswordController,
                                                                newPasswordController,
                                                                reNewPasswordController,
                                                                passwordVisible1,
                                                                passwordVisible2,
                                                                passwordVisible3,
                                                                passError);
                                                          },
                                                          color: primary_color,
                                                          icon: const Icon(
                                                            Icons.edit,
                                                            size: 18,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: context
                                                          .read<GlobalData>()
                                                          .isDevice ==
                                                      1
                                                  ? 320
                                                  : double.infinity,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Выход',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.grey),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 10),
                                                    child: Row(
                                                      children: [
                                                        const Text(
                                                          'Выйти',
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                        IconButton(
                                                          onPressed: () async {
                                                            context
                                                                .read<
                                                                    GlobalData>()
                                                                .setInfoUser = [];
                                                            await encryptedSharedPreferences
                                                                .clear();
                                                            context.go('/');
                                                          },
                                                          color: primary_color,
                                                          icon: const Icon(
                                                            Icons.logout,
                                                            size: 18,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: context
                                                          .read<GlobalData>()
                                                          .isDevice ==
                                                      1
                                                  ? 320
                                                  : double.infinity,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Управление',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.grey),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 20),
                                                    child: Row(
                                                      children: [
                                                        const Text(
                                                          'Удалить аккаунт',
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                        IconButton(
                                                          onPressed: () {
                                                            deleteAccount(
                                                                context,
                                                                authToken,
                                                                encryptedSharedPreferences);
                                                          },
                                                          color: primary_color,
                                                          icon: const Icon(
                                                            Icons.delete,
                                                            size: 18,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : giveListTile(3, 'Настройки', Icons.settings)),
                      ),
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.only(
                    top: 25,
                    bottom: 25,
                  ),
                  child: Column(
                    children: [
                      giveListTile(0, 'Подтвердите свой адрес эл. почты',
                          FontAwesomeIcons.envelope),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 30, right: 30, bottom: 25, top: 5),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 300,
                                  height: 50,
                                  child: TextButton(
                                    onPressed: () async {
                                      await activeAccQuery(authToken,
                                          'activeAcc', 'mailSend', 'none');
                                      await activeMail(context, mailCode,
                                          authToken, mailStatError);
                                      await checkAuth();
                                    },
                                    child: Text(
                                      'Получить код на адрес эл. почты',
                                      style: TextStyle(
                                          fontSize: 16, color: primary_color),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isPreloader
        ? Container(
            height: MediaQuery.of(context).size.height,
            child: Center(child: CircularProgressIndicator()))
        : profileDetected
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: context.read<GlobalData>().isDevice == 1
                              ? 50
                              : 25,
                          left: 0,
                          right: 0),
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 500),
                        child: homeWindow(),
                      ),
                    ),
                  ],
                ),
              )
            : const NoAuthPage();
  }
}

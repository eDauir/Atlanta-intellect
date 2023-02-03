import 'package:barber/api/checkAuth.dart';
import 'package:barber/api/profileApi.dart';
import 'package:barber/pages/Profile/account/mainProfile.dart';
import 'package:barber/pages/Profile/account/module/queries.dart';
import 'package:barber/pages/Profile/account/vars.dart';
import 'package:barber/pages/Profile/account/widgets/deleteAccount.dart';
import 'package:barber/provider/globalData.dart';
import 'package:barber/provider/profileData.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:barber/res/widgets/inputWidget.dart';
import 'package:barber/res/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class ReadProfile extends StatefulWidget {
  Function updataProfile;

  ReadProfile({Key? key, required this.updataProfile}) : super(key: key);
  @override
  State<ReadProfile> createState() => _ReadProfileState();
}

class _ReadProfileState extends State<ReadProfile> {
  bool disableSendBtn = false;

  TextEditingController loginReadController = TextEditingController();
  TextEditingController mailController =
      TextEditingController(text: '${loginController.text}');

// DROPDOWN

  List<DropdownMenuItem<String>> get dropdownItemsMale {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          child: Text(
            "Пол",
          ),
          value: "0"),
      DropdownMenuItem(
          child: Text(
            "Муж.",
          ),
          value: "1"),
      DropdownMenuItem(
          child: Text(
            "Жен.",
          ),
          value: "2"),
    ];
    return menuItems;
  }

  String selectedDropValueMale = manChecked == true
      ? '1'
      : womanChecked == true
          ? '2'
          : "0";

  String selectedDropValue = '0';

  TextEditingController myNameCon = TextEditingController();
  TextEditingController mySurNameCon = TextEditingController();
  TextEditingController myLastNameCon = TextEditingController();
  TextEditingController myTelCon = TextEditingController();
  TextEditingController myAddresCon = TextEditingController();

  setInitData() async {
    myNameCon = TextEditingController(text: context.read<ProfileData>().name);
    mySurNameCon =
        TextEditingController(text: context.read<ProfileData>().surname);
    myLastNameCon =
        TextEditingController(text: context.read<ProfileData>().lastName);
    myTelCon = TextEditingController(text: context.read<ProfileData>().tel);
    myAddresCon =
        TextEditingController(text: context.read<ProfileData>().addres);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setInitData();
  }

//

  @override
  Widget build(BuildContext context) {
    var maskFormatter = new MaskTextInputFormatter(
      mask: '+# (###) ###-##-##',
      filter: {"#": RegExp(r'[0-9]')},
    );

    // setState(() {});

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
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
            'Редактировать',
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            child: Container(
              margin: EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  boxInput(InputWidget(
                    controller: myNameCon,
                    hintText: 'Имя',
                  )),
                  SizedBox(
                    height: 10,
                  ),
                  boxInput(InputWidget(
                    controller: mySurNameCon,
                    hintText: 'Фамилия',
                  )),
                  SizedBox(
                    height: 10,
                  ),
                  boxInput(
                    InputWidget(
                      controller: myLastNameCon,
                      hintText: 'Отчество',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  boxInput(InputWidget(
                    controller: myTelCon,
                    hintText: 'Телефон',
                    inputFormatters: true,
                    AutovalidateModeSetting: AutovalidateMode.always,
                  )
                      // TextFormField(
                      //   controller: myTelCon,
                      //   inputFormatters: [maskFormatter],
                      //   autocorrect: false,
                      //   autovalidateMode: AutovalidateMode.always,
                      //   // keyboardType: TextInputType.phone,
                      //   // autocorrect: true,
                      //   decoration: customDec(
                      //           hintext: 'Телефон',
                      //           radius: 10,
                      //           notPrefix: true,
                      //           context: context,
                      //           isActive: true)
                      //       .copyWith(),
                      // ),
                      ),
                  SizedBox(
                    height: 10,
                  ),
                  boxInput(
                    InputWidget(
                        controller: myAddresCon, hintText: 'Местопожение'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.black)),
                    onPressed: () async {
                      DateTime? picked = await showDatePicker(
                          locale: context.locale,
                          builder: (context, child) {
                            return Theme(
                                data: ThemeData.light().copyWith(
                                    colorScheme: ColorScheme.light(
                                        primary: primary_color)),
                                child: child!);
                          },
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(1930, 8),
                          lastDate: DateTime.now());
                      if (picked != null && picked != selectedDate) {
                        setState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 10),
                      decoration: BoxDecoration(
                          color: colorWhite,
                          borderRadius:
                              BorderRadius.circular(marginScaleWC(50)),
                          boxShadow: [shadow]),
                      child: boxItem(
                        context: context,
                        isPadding: false,
                        textChild: Text(
                          (selectedDate == DateTime.parse('1931-01-01'))
                              ? 'Не введено'
                              : selectedDate.toString().split(' ')[0],
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black.withOpacity(0.6)),
                          textScaleFactor: textScale(context),
                        ),
                        button: IconButton(
                          onPressed: () async {},
                          icon: SvgPicture.asset(
                              'assets/img/ProdileCalendar.svg'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  boxInput(
                    InputWidget(
                      controller: loginController,
                      hintText: 'Адрес эл.почты',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: colorWhite,
                        borderRadius: BorderRadius.circular(marginScaleWC(50)),
                        boxShadow: [shadow]),
                    child: DropdownButtonHideUnderline(
                      child: Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton(
                            dropdownColor: colorWhite,

                            icon: Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 13,
                                  )),
                            ),

                            underline: SizedBox(),
                            // dropdownColor: greys,
                            borderRadius: BorderRadius.circular(10),
                            isExpanded: true,
                            value: selectedDropValueMale,
                            onChanged: (String? value) {
                              setState(() {
                                selectedDropValueMale = value!;
                              });
                              // context.read<ProfileData>().setMale =
                              //     selectedDropValueMale;
                            },
                            items: dropdownItemsMale,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: marginScale(context, 15),
                  ),
                  Divider(),
                  TextButton(
                      onPressed: () async {
                        showModal(
                            context,
                            Column(
                              children: [
                                SvgPicture.asset('assets/img/delAccount.svg'),
                                sizeHeight(15),
                                Text(
                                  'Ваш аккаунт будет удален. Вы уверены?',
                                  style: headLine5Reg,
                                  textAlign: TextAlign.center,
                                ),
                                sizeHeight(20),
                                ElevatedButton(
                                    onPressed: () async {
                                      String login = context
                                              .read<GlobalData>()
                                              .loginToken ??
                                          '';
                                      if (login.isEmpty) return;
                                      await deleteAccount(context, login,
                                          encryptedSharedPreferences);
                                    },
                                    child: Text('Удалить')),
                                sizeHeight(10),
                                cancelBtn(context),
                              ],
                            ));
                      },
                      child: Text(
                        'Удалить аккаунт',
                        textScaleFactor: textScaleWC(),
                        style: headLine4Reg.copyWith(
                          color: redColor,
                          decoration: TextDecoration.underline,
                        ),
                      )),
                  SizedBox(
                    height: 35,
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                          onPressed: () async {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);

                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            if (disableSendBtn == true) return;
                            setState(() {
                              disableSendBtn = true;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                'Обновлено',
                              ),
                            ));

                            if (nameController.text == myNameCon.text &&
                                surnameController.text == mySurNameCon.text &&
                                otchController.text == myLastNameCon.text) {
                            } else {
                              await queryToFio(
                                  myNameCon.text,
                                  mySurNameCon.text,
                                  myLastNameCon.text,
                                  authToken);
                              nameController.text = myNameCon.text;
                              surnameController.text = mySurNameCon.text;
                              otchController.text = myLastNameCon.text;

                              widget.updataProfile();
                            }

                            if (addressController.text != myAddresCon.text) {
                              await queryToGeo(authToken, myAddresCon.text);
                            }

                            if (myTelCon.text.isNotEmpty &&
                                myTelCon.text != 'Не введено' &&
                                teleController.text != myTelCon.text) {
                              await queryToTele(authToken, myTelCon.text);
                            }

                            if (loginController.text.isNotEmpty &&
                                loginController.text != constMail) {
                              var res = await changeMail(
                                  authToken, loginController.text);
                              if (res == 'true') {
                                constMail = loginController.text;
                                setState(() {});
                              }
                            }

                            context.read<ProfileData>().setInitValue(
                                  nameValue: myNameCon.text,
                                  surName: mySurNameCon.text,
                                  lastNameValue: myLastNameCon.text,
                                  addresValue: myAddresCon.text,
                                  telVAlue: myTelCon.text,
                                );

                            if (selectedDropValueMale == '0') {
                              await changeDefElemQuery(
                                  authToken, 'users_profile', 'pol', '');
                            } else {
                              await queryToPol(authToken,
                                  selectedDropValueMale == '1' ? true : false);
                            }
                            manChecked =
                                selectedDropValueMale == '1' ? true : false;
                            womanChecked =
                                selectedDropValueMale == '2' ? true : false;

                            await queryToBirthday(authToken, selectedDate);

                            setState(() {
                              disableSendBtn = false;
                            });
                          },
                          child: Text(
                            'Обновить',
                          ))),
                  SizedBox(
                    height: 25,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  boxInput(Widget child) {
    return Container(
      constraints: BoxConstraints(maxHeight: marginScale(context, 44)),
      child: child,
    );
  }

  Widget boxItem(
      {required BuildContext context,
      Widget? textChild,
      Widget? button,
      bool dropDown = false,
      bool isPadding = true}) {
    return Container(
        constraints: isPadding == false
            ? null
            : BoxConstraints(maxHeight: marginScale(context, 44)),
        padding:
            isPadding == false ? null : EdgeInsets.only(left: 25, bottom: 5),
        decoration: isPadding == false
            ? null
            : BoxDecoration(
                color: HexColor('#F8F8F8'),
                borderRadius: BorderRadius.circular(10)),
        child: (dropDown == false)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (textChild != null) textChild,
                  if (button != null) button
                ],
              )
            : textChild);
  }
}

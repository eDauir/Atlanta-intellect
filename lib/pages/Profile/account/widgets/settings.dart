import 'package:barber/generated/locale_keys.g.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:barber/res/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LangChange {
  Locale local;
  String value;

  LangChange({required this.local, required this.value});
}

class Settings extends StatefulWidget {
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isNotyState = true;

  List<LangChange> itemsLang = [
    LangChange(local: Locale('ru'), value: LocaleKeys.lang_ru.tr()),
    LangChange(local: Locale('kk'), value: LocaleKeys.lang_kz.tr()),
  ];

  LangChange? valueBtn;

  getCurrentLocal() {
    if (context.locale == Locale('ru')) {
      setState(() {
        valueBtn = itemsLang[0];
      });
    } else {
      setState(() {
        valueBtn = itemsLang[1];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getCurrentLocal();
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
          LocaleKeys.profile_settings.tr(),
          textScaleFactor: textScale(context),
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: marginScale(context, 15)),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: marginScaleWC(10)),
              child: TextButton(
                style: TextButton.styleFrom(padding: EdgeInsets.only(left: 0)),
                onPressed: () {
                  changeLang(context, valueBtn, itemsLang);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Язык',
                      style: headLine5Reg,
                      textScaleFactor: textScale(context),
                    ),
                    Text(
                      valueBtn?.value ?? '',
                      style: headLine5Reg.copyWith(color: primary_color),
                      textScaleFactor: textScaleWC(),
                    )
                  ],
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: marginScaleWC(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Push-уведомление',
                    style: headLine4Reg.copyWith(color: darkColor),
                    textScaleFactor: textScaleWC(),
                  ),
                  SizedBox(
                    height: marginScaleWC(29),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: CupertinoSwitch(
                          value: isNotyState,
                          activeColor: primary_color,
                          onChanged: (value) {
                            setState(() {
                              isNotyState = value;
                            });
                          }),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }

  Future<dynamic> changeLang(
      BuildContext context, LangChange? valueBtn, List<LangChange> itemsLang) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(marginScale(context, 20)))),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset('assets/img/lang.svg'),
                  sizeHeight(20),
                  Text(
                    'Язык',
                    textScaleFactor: textScaleWC(),
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(color: primary_color),
                    textAlign: TextAlign.center,
                  ),
                  sizeHeight(15),
                  Text(
                    'Выберите язык системы.',
                    style: headLine5Reg,
                    textScaleFactor: textScaleWC(),
                  ),
                  sizeHeight(15),
                  Container(
                    child: DropdownButton(
                        value: valueBtn,
                        hint: Text('Выберите язык'),
                        items: [
                          ...itemsLang.map((e) {
                            return (DropdownMenuItem(
                                value: e, child: Text(e.value)));
                          })
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            valueBtn = value;
                          });
                        }),
                  ),
                  sizeHeight(20),
                  ElevatedButton(
                      onPressed: () {
                        if (valueBtn == context.locale &&
                            valueBtn?.local != null) {
                          Navigator.pop(context);
                        } else {
                          context.setLocale(valueBtn!.local);
                        }
                      },
                      child: Text('Выбрать')),
                  sizeHeight(10),
                  cancelBtn(context),
                ],
              );
            }),
          );
        });
  }
}

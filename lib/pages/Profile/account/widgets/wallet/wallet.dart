import 'package:barber/api/Wallet/IWallet.dart';
import 'package:barber/api/Wallet/walletApi.dart';
import 'package:barber/generated/locale_keys.g.dart';
import 'package:barber/pages/Profile/account/widgets/wallet/walletOutput.dart';
import 'package:barber/pages/Profile/account/widgets/wallet/walletTenge.dart';
import 'package:barber/pages/Profile/account/widgets/wallet/walletTransfor.dart';
import 'package:barber/provider/globalData.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:barber/res/widgets/inputWidget.dart';
import 'package:barber/res/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

enum ChooseImage { red, green, orange }

class WalletPage extends StatefulWidget {
  bool isUnit;
  WalletPage({Key? key, this.isUnit = false}) : super(key: key);
  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  TextEditingController searchController = TextEditingController();
  late FocusNode focusNode;
  int curPage = 1;
  int pageCount = 0;
  bool isLoad = true;
  List<IWallet> walletInfo = [];
  bool strEnd = false;

  getData(int goPage, String type, [bool isReload = true]) async {
    if (isReload) {
      setState(() {
        isLoad = true;
      });
    }

    String login = context.read<GlobalData>().loginToken ?? '';

    if (login == '') {
      Navigator.pop(context);
    }

    var res = await getWalletInfo(login: login, page: goPage.toString());

    if (res.isEmpty) {
      return;
    }

    if (type == 'def') {
      walletInfo = res;
    } else {
      walletInfo[0].history?.addAll(res[0].history);
    }

    setState(() {
      pageCount = walletInfo[0].count!;
      if (isReload) {
        isLoad = false;
      }
    });
  }

  setS() {
    getData(curPage, 'def');
  }

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    getData(curPage, 'def');
    focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        removeFocus(context);
      },
      child: Scaffold(
        appBar: showAppBar(
          context,
          LocaleKeys.profile_wallet.tr(),
        ),
        body: isLoad
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: marginScale(context, 15)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      // ! CARD
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(marginScale(context, 25)),
                            child: SvgPicture.asset(
                              'assets/img/walletBox.svg',
                              width: double.infinity,
                              height: marginScale(context, 196),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned.fill(
                              top: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: marginScale(context, 15),
                                    vertical: marginScale(context, 15)),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '₸${MoneyFormat.get(widget.isUnit ? walletInfo[0].main![0].unitValue ?? '0' : walletInfo[0].main![0].amount ?? '0')}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline1!
                                                  .copyWith(color: colorWhite),
                                            ),
                                            Text(
                                              widget.isUnit
                                                  ? 'Единица'
                                                  : 'Доступный баланс',
                                              style: headLine5Reg.copyWith(
                                                  color: colorWhite),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    sizeHeight(30),
                                    widget.isUnit
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              buildWalletBtn(
                                                  context: context,
                                                  title: 'Купить',
                                                  chooseType: ChooseImage.red,
                                                  color: colorsRed,
                                                  onPress: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    WalletTenge(
                                                                      setS:
                                                                          setS,
                                                                      isUnit:
                                                                          true,
                                                                    )));
                                                  }),
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              buildWalletBtn(
                                                  context: context,
                                                  title: 'Пополнить',
                                                  chooseType: ChooseImage.green,
                                                  color: colorsRed,
                                                  onPress: () {
                                                    showReplenish(
                                                        context, getData);
                                                    // Navigator.push(
                                                    //     context,
                                                    //     MaterialPageRoute(
                                                    //         builder: (context) =>
                                                    //             WalletTenge(
                                                    //               setS: setS,
                                                    //             )));
                                                  }),
                                              sizeWidth(15),
                                              buildWalletBtn(
                                                  context: context,
                                                  title: 'Перевод',
                                                  chooseType:
                                                      ChooseImage.orange,
                                                  onPress: () async {
                                                    showModalTransfor(
                                                        context, getData);
                                                    // var res = await Navigator.push(
                                                    //     context,
                                                    //     MaterialPageRoute(
                                                    //         builder: (context) =>
                                                    //             WalletAddPage(
                                                    //                 id: walletInfo
                                                    //                     .first
                                                    //                     .main
                                                    //                     ?.first
                                                    //                     .userId)));
                                                    // getData(curPage, 'def');
                                                  }),
                                              sizeWidth(15),
                                              buildWalletBtn(
                                                  context: context,
                                                  title: 'Вывод',
                                                  chooseType: ChooseImage.red,
                                                  color: colorsRed,
                                                  onPress: () {
                                                    showModalWalletOut(
                                                        context, getData);
                                                  }),
                                            ],
                                          )
                                  ],
                                ),
                              )),
                        ],
                      ),
                      // ! INPUT
                      SizedBox(
                        height: marginScale(context, 20),
                      ),
                      InputWidget(
                        controller: searchController,
                        hintText: 'Введите текст',
                      ),
                      SizedBox(
                        height: marginScale(context, 20),
                      ),

                      // !
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Все транзакции',
                          style: headLine5Med,
                          textScaleFactor: textScaleWC(),
                        ),
                      ),
                      SizedBox(
                        height: marginScale(context, 30),
                      ),
                      ...walletInfo[0].history!.map(
                        (e) {
                          return buildItemTransaction(
                              context: context,
                              date: e.date!,
                              toUser: e.toUser,
                              myID: walletInfo[0].main![0].userId,
                              name: walletInfo[0].main![0].userId == e.toUser
                                  ? e.fromName
                                  : e.toName,
                              sum: e.amount ?? '123',
                              type: e.type!);
                        },
                      ),
                      if (!strEnd)
                        TextButton(
                            onPressed: () {
                              if (curPage < pageCount) {
                                curPage++;
                                getData(curPage, 'addAll', false);
                              } else {
                                strEnd = true;
                              }

                              setState(() {});
                            },
                            child: Text('Показать еще'))
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Container buildItemTransaction({
    required BuildContext context,
    String? title,
    required String date,
    required String type,
    String? toUser,
    String? myID,
    String? name,
    required String sum,
    // required ChooseImage chooseImage
  }) {
    String img = '';
    late Color currentColor;
    String place = '';

    if (title == null) {
      switch (type) {
        case '1':
          title = 'Пополнение';
          img = 'assets/img/addWallet.svg';
          break;
        case '2':
          title = 'Вывод';
          img = 'assets/img/card-receive.svg';
          break;
        case '3':
          title = 'Бонус';
          img = 'assets/img/bonus.svg';
          break;
        case '4':
          title = 'Покупка курса';
          img = 'assets/img/buyCourse.svg';
          break;
        case '5':
          title = 'Перевод: ${name}';
          img = (toUser == myID)
              ? 'assets/img/send.svg'
              : 'assets/img/recieve.svg';
          break;
        case '6':
          title = 'Продажа курса';
          img = 'assets/img/walletbuycourse.svg';
          break;
        case '7':
          title = 'Покупка единицы';
          img = 'assets/img/buyCourse.svg';
          break;
        case '8':
          title = 'Бонус от единицы';
          img = 'assets/img/bonus.svg';
          break;
        default:
      }

      if (type == '1' || type == '3' || type == '6' || type == '8') {
        currentColor = colorsGreen;
        place = '+';
      } else {
        currentColor = colorsRed;
        place = '-';
      }

      if (type == '5') {
        if (toUser == myID) {
          currentColor = colorsGreen;
          place = '+';
        } else {
          currentColor = colorsRed;
          place = '-';
        }
      }
    }
    return Container(
      padding: EdgeInsets.only(bottom: marginScale(context, 10)),
      margin: EdgeInsets.only(bottom: marginScale(context, 10)),
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(
          color: greys.withOpacity(0.2),
          width: 1.0,
        ),
      )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                img,
                width: marginScale(context, 34),
                height: marginScale(context, 34),
                fit: BoxFit.scaleDown,
              ),
              SizedBox(
                width: marginScale(context, 15),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title!,
                      style: Theme.of(context).textTheme.headline5,
                      textScaleFactor: textScaleWC(),
                    ),
                    SizedBox(
                      height: marginScale(context, 5),
                    ),
                    Text(
                      date,
                      style: headLine5Reg.copyWith(color: greyColor),
                      textScaleFactor: textScaleWC(),
                    ),
                  ],
                ),
              )
            ],
          ),
          Text(
            '${place}${MoneyFormat.get(sum)} ',
            textScaleFactor: textScaleWC(),
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(color: currentColor),
          )
        ],
      ),
    );
  }

  Widget buildWalletBtn(
      {required BuildContext context,
      required String title,
      required Function onPress,
      required ChooseImage chooseType,
      Color? color}) {
    String img = '';

    switch (chooseType) {
      case ChooseImage.red:
        img = 'assets/img/outputCard.svg';
        break;
      case ChooseImage.green:
        img = 'assets/img/bonusCard.svg';
        break;
      case ChooseImage.orange:
        img = 'assets/img/transferCard.svg';
        break;
    }

    return TextButton(
      onPressed: () {
        onPress();
      },
      child: Column(
        children: [
          Container(
            width: marginScaleWC(54),
            height: marginScaleWC(54),
            decoration: BoxDecoration(
                color: colorWhite,
                borderRadius: BorderRadius.circular(marginScaleWC(50))),
            child: Center(
              child: SvgPicture.asset(img),
            ),
          ),
          sizeHeight(5),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(color: colorWhite),
          )
        ],
      ),
    );
  }
}

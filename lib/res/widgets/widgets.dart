import 'package:barber/api/Product/productApi.dart';
import 'package:barber/provider/globalData.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MoneyFormat {
  static get(String price) {
    if (price.length > 2) {
      var value = price;
      value = value.replaceAll(RegExp(r'\D'), '');
      value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ' ');
      return value;
    } else {
      return price;
    }
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

// for hover Web
class OnHover extends StatefulWidget {
  final Widget Function(bool isHovered) builder;
  const OnHover({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  State<OnHover> createState() => _OnHoverState();
}

class _OnHoverState extends State<OnHover> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        onEnter: (event) => onEntered(true),
        onExit: (event) => onEntered(false),
        child: widget.builder(isHovered));
  }

  void onEntered(bool isHovered) => setState(() {
        this.isHovered = isHovered;
      });
}

String telephoneFormat(String phoneNumber) {
  if (phoneNumber.isEmpty) {
    return '';
  } else if (phoneNumber.length != 11) {
    return phoneNumber;
  } else {
    var newFormat = phoneNumber.split('');
    String res = newFormat[0];
    res = res + ' ' + newFormat[1] + newFormat[2] + newFormat[3];
    res = res + ' ' + newFormat[4] + newFormat[5] + newFormat[6];
    res = res + ' ' + newFormat[7] + newFormat[8];
    res = res + ' ' + newFormat[9] + newFormat[10];

    return res;
  }
}

Container itemCatName(
  BuildContext context,
  catName, [
  bool margin = true,
]) {
  return Container(
      margin: margin == false
          ? null
          : EdgeInsets.only(
              top: marginScale(context, 0), bottom: marginScale(context, 0)),
      padding: EdgeInsets.symmetric(
          horizontal: marginScale(context, 8),
          vertical: marginScale(context, 5)),
      decoration: BoxDecoration(
          color: bgPrimaryColor, borderRadius: BorderRadius.circular(8)),
      child: Text(
        catName,
        textScaleFactor: textScale(context),
        overflow: TextOverflow.ellipsis,
        style: headLine7.copyWith(color: primary_color),
      ));
}

btnMore(
  BuildContext context,
  Function getData,
  int curPage,
) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: marginScale(context, 20)),
    child: TextButton(
        onPressed: () {
          // print((curPage++).toString());
          getData(page: (++curPage).toString(), searchKey: '');
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Показать больше',
              textScaleFactor: textScale(context),
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(color: primary_color),
            ),
            SizedBox(
              width: marginScale(context, 3),
            ),
            Icon(Icons.keyboard_arrow_down_rounded)
          ],
        )),
  );
}

DialogRoute showLoading(context) {
  return DialogRoute(
      context: context,
      builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Пожалуйста подождите',
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                CircularProgressIndicator()
              ],
            ),
          ),
      barrierDismissible: false);
}

showMainIconCenter() {
  return Align(
      alignment: Alignment.center,
      child: SvgPicture.asset(
        'assets/img/homeIcon.svg',
        width: 100,
        height: 40,
        fit: BoxFit.cover,
      ));
}

showModal(BuildContext context, Widget widget) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(marginScale(context, 20)))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [widget],
            ),
          ));
}

Future<dynamic> showFeedBackWindow(BuildContext context,
    {required String productId}) {
  return showDialog(
      context: context,
      builder: ((context) {
        TextEditingController textController = new TextEditingController();
        int? ratingSend;
        return SingleChildScrollView(
          child: StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.only(
                  top: marginScale(context, 0),
                  left: marginScale(context, 25),
                  right: marginScale(context, 25),
                  bottom: marginScale(context, 25)),
              titlePadding: EdgeInsets.only(
                  top: marginScale(context, 15),
                  right: marginScale(context, 15)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(marginScale(context, 20)))),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.close,
                    ),
                    splashRadius: marginScale(context, 15),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: SvgPicture.asset('assets/img/cup.svg'),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: marginScale(context, 30),
                        bottom: marginScale(context, 15)),
                    child: RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      itemSize: marginScale(context, 24),
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: primary_color,
                      ),
                      onRatingUpdate: (rating) {
                        ratingSend = int.parse(rating.toStringAsFixed(0));
                      },
                    ),
                  ),
                  TextFormField(
                    controller: textController,
                    maxLines: 4,
                    style: Theme.of(context).textTheme.headline5,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.all(marginScale(context, 15)),
                        fillColor: homeBg,
                        hintText: 'Напишите'),
                  ),
                  SizedBox(
                    height: marginScale(context, 20),
                  ),
                  Container(
                    child: ElevatedButton(
                        onPressed: () async {
                          if (ratingSend == null ||
                              textController.text.isEmpty) {
                            return;
                          }

                          Navigator.pop(context);
                          String login =
                              context.read<GlobalData>().loginToken ?? '';
                          if (login.isEmpty) return;

                          await sendFeedback(
                              login: login,
                              productId: productId,
                              text: textController.text,
                              rating: ratingSend.toString());

                          textController.text = '';
                        },
                        child: Text('Отправить')),
                  ),
                ],
              ),
            );
          }),
        );
      }));
}

// !REMOVE FOCUS
removeFocus(context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

loadRequest(context, Function request) async {
  final loadShow = showLoading(context);
  Navigator.of(context).push(loadShow);
  await request();
  Navigator.of(context).pop();
}

AppBar mainAppbar(BuildContext context,
        {bool isBack = true, required String title}) =>
    AppBar(
      leading: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: TextButton(
            onPressed: () {
              removeFocus(context);
              Navigator.pop(context);
            },
            child: SvgPicture.asset(
              isBack ? 'assets/img/backIcon.svg' : 'assets/img/closeIcon.svg',
              width: marginScaleWC(32),
              height: marginScaleWC(32),
            )),
      ),
      title: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Text(
          title,
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
    );

AppBar showAppBar(context, text, [String? img]) {
  return AppBar(
    leading: Center(
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset(img ?? 'assets/img/arrowBack.svg')),
        ],
      ),
    ),
    title: Text(
      text,
      textScaleFactor: textScale(context),
      style: Theme.of(context).textTheme.headline2,
    ),
  );
}

showCongrats(context, {String? text, Function? onPress}) {
  return showModal(
      context,
      Column(
        children: [
          SvgPicture.asset('assets/img/conrgats.svg'),
          sizeHeight(25),
          Text(
            'Поздравляем!',
            style: Theme.of(context)
                .textTheme
                .headline3!
                .copyWith(color: primary_color),
            textAlign: TextAlign.center,
          ),
          sizeHeight(15),
          Text(
            text ??
                'Ваш аккаунт успешно создан. Через несколько секунд вы будете перенаправлены на страницу входа.',
            style: headLine5Reg,
            textAlign: TextAlign.center,
          ),
          sizeHeight(20),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (onPress != null) {
                  onPress();
                }
              },
              child: Text('OK'))
        ],
      ));
}

class TopRed extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = primary_color;
    Path path = Path()
      ..relativeLineTo(0, 130)
      ..quadraticBezierTo(size.width / 2, 175, size.width, 130)
      ..relativeLineTo(0, -130)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

cancelBtn(context, {String? text, Function? press, bool isShowPop = true}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: primary_opac,
          shadowColor: primary_opac,
          foregroundColor: primary_color,
          elevation: 0),
      onPressed: () {
        if (isShowPop) {
          Navigator.pop(context);
        }
        if (press != null) {
          press();
        }
      },
      child: Text(text ?? 'Отмена'));
}

// DON T AUTH

showModalDonAuth(context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(marginScale(context, 20)))),
          contentPadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.symmetric(
              horizontal: marginScale(context, 20),
              vertical: marginScale(context, 20)),
          actionsAlignment: MainAxisAlignment.center,
          alignment: Alignment.center,
          actions: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/img/account.svg'),
                SizedBox(
                  height: marginScale(context, 15),
                ),
                Text(
                  'Аккаунт',
                  style: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(color: primary_color),
                ),
                SizedBox(
                  height: marginScale(context, 15),
                ),
                Text(
                  'Для покупки требуется авторизация',
                  style: headLine5Med,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: marginScale(context, 20),
                ),
                ElevatedButton(
                  onPressed: () async {
                    context.go('/profile');
                  },
                  child: Text('Перейти'),
                )
              ],
            )
          ],
        );
      });
}

import 'package:barber/generated/locale_keys.g.dart';
import 'package:barber/pages/list/lists.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:barber/res/widgets/bottomBar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class Wrapper extends StatefulWidget {
  ThemeProvider them;
  Widget bodyWidget;
  int numWidget;

  Wrapper(
      {super.key,
      required this.bodyWidget,
      this.numWidget = 404,
      required this.them});
  @override
  State<Wrapper> createState() => _WrapperState();
}

int _selectedIndex = 0;

class _WrapperState extends State<Wrapper> {
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String? titleAppBar = null;

  @override
  Widget build(BuildContext context) {
    switch (widget.numWidget) {
      case 5:
        titleAppBar = 'Аккаунт';
        break;
      // case 8:
      //   titleAppBar = 'Забыли пароль';
      //   break;
      case 11:
        titleAppBar = LocaleKeys.bottom_bar_noty.tr();
        break;
      case 10:
        titleAppBar = LocaleKeys.bottom_bar_search.tr();
        break;
      case 16:
        titleAppBar = 'Книги';
        break;
      case 15:
        titleAppBar = 'Тариф';
        break;
    }

    return WillPopScope(
      onWillPop: () async {
        context.go('/');
        return false;
      },
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
            appBar: (widget.numWidget == 88 ||
                    widget.numWidget == 5 ||
                    widget.numWidget == 6)
                ? null
                : AppBar(
                    automaticallyImplyLeading: false,
                    leading: widget.numWidget == 5 ||
                            widget.numWidget == 11 ||
                            widget.numWidget == 10 ||
                            widget.numWidget == 1 ||
                            widget.numWidget == 15
                        ? null
                        : IconButton(
                            onPressed: () {
                              switch (widget.numWidget) {
                                case 7:
                                  return context.go('/auth');

                                default:
                                  return context.go('/');
                              }
                            },
                            icon: SvgPicture.asset('assets/img/arrowBack.svg')),
                    title: titleAppBar != null
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/img/iconApp.svg' , width: marginScaleWC(40) ,),
                              SizedBox(
                                width: marginScale(context, 15),
                              ),
                              Text(
                                titleAppBar!,
                                textScaleFactor: textScale(context),
                                style: Theme.of(context).textTheme.headline2,
                              ),
                            ],
                          )
                        : widget.numWidget == 1
                            ? SvgPicture.asset(
                                'assets/img/homeIcon.svg',
                                width: marginScaleWC(142),
                              )
                            : null),
            body: SingleChildScrollView(
                child: Container(color: homeBg, child: widget.bodyWidget)),
            bottomNavigationBar: (widget.numWidget == 88 ||
                    widget.numWidget == 6 ||
                    widget.numWidget == 7 ||
                    widget.numWidget == 8)
                ? null
                : myCustomeBottomBar(
                    numWidget: widget.numWidget,
                  )),
      ),
    );
  }
}

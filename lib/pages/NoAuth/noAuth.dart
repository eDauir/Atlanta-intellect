import 'package:barber/res/style/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../provider/globalData.dart';


class NoAuthPage extends StatelessWidget {
  const NoAuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return Center(
        child: Container(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height - 100),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                   SvgPicture.asset(
                          'assets/svg/noAuthNew.svg',
                          width: 200,
                        ),
                  // Image.asset('assets/img/404.svg'),
                  Text(
                    'Вы не авторизованы',
                    textScaleFactor: textScale(context),
                    style: TextStyle(
                        fontSize:
                            context.read<GlobalData>().isDevice == 1 ? 35 : 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Для продолжения пройдите авторизацию',
                    textScaleFactor: textScale(context),
                    style: TextStyle(
                        fontSize:
                            context.read<GlobalData>().isDevice == 1 ? 28 : 14),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(
                    height: 40,
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                )),
                                side: MaterialStateProperty.all(BorderSide(
                                    width: 1.0,
                                    color: primary_color)),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white)),
                            onPressed: () {
                              context.go('/');
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Text(
                                'На главную',
                                textScaleFactor: textScale(context),
                                style: TextStyle(
                                    color: primary_color,
                                    fontSize:
                                        context.read<GlobalData>().isDevice == 1
                                            ? 18
                                            : 16),
                              ),
                            )),
                      ),
                      // SizedBox(
                      //   width: 30,
                      // ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            context.go('/auth');
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Text(
                              'Войти',
                              textScaleFactor: textScale(context),
                              style: TextStyle(
                                  fontSize:
                                      context.read<GlobalData>().isDevice == 1
                                          ? 18
                                          : 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    
  }
}

import 'package:barber/res/style/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class NotPages extends StatelessWidget {
  const NotPages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 150),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/img/404.svg'),
              // Image.asset('assets/img/404.svg'),
              Text(
                'Страница не найдена',
                textScaleFactor: textScale(context),
                style: TextStyle(
                    fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Мы не можем найти страницу, которую вы ищете',
                textScaleFactor: textScale(context),
                style: TextStyle(
                    fontSize: 14),
                textAlign: TextAlign.center,
              ),

              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    )),
                    // side: BorderSide(width: 1.0, color: Colors.blue),
                  ),
                  onPressed: () {
                    context.go('/');
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Text('На главную',
                    textScaleFactor: textScale(context),
                        style: TextStyle(
                            fontSize:  16)),
                  )),

              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

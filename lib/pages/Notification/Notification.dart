import 'package:barber/api/Notification/INotification.dart';
import 'package:barber/provider/globalData.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../api/Notification/notificationApi.dart';

class Notification extends StatefulWidget {
  @override
  State<Notification> createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  notiFic() async {
    List<INotification> notis =
        await getNotification(context.read<GlobalData>().loginToken!);
  }

  @override
  void initState() {
    super.initState();
    notiFic();
  }

  @override
  Widget build(BuildContext context) {
    if (context.read<GlobalData>().noti.isEmpty) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: EdgeInsets.symmetric(
            horizontal: marginScale(context, 15),
            vertical: marginScale(context, 30)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/img/noNoty.svg',
              width: marginScale(context, 210),
            ),
            SizedBox(
              height: marginScale(context, 20),
            ),
            Text(
              'Здесь будет появляться уведомления об акциях и скидках, для получения уведомления надо авторизоваться',
              style: headLine4Reg,
              textAlign: TextAlign.center,
            )
          ],
        ),
      );
    }
    Map<dynamic, dynamic> notify = context.read<GlobalData>().noti[0].notify!;

    return Container(
      margin: EdgeInsets.only(top: 30),
      padding: EdgeInsets.symmetric(horizontal: 15),
      color: homeBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...notify.entries.map((e) {
            return itemNotiBox(context: context, data: e.key, noti: e.value);
          }),
        ],
      ),
    );
  }

  Container itemNotiBox(
      {required BuildContext context,
      required String data,
      required List noti}) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data,
            textScaleFactor: textScale(context),
            style: Theme.of(context).textTheme.headline4,
          ),
          SizedBox(
            height: 22,
          ),

          ...noti.map((e) {
            return itemNoti(
                img: iconSwitch(e['type']),
                context: context,
                text: e['text'],
                title: e['title']);
          }),

          // itemNoti(context: context,  )
        ],
      ),
    );
  }

  Container itemNoti({
    required BuildContext context,
    String? title,
    String? text,
    img,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 23),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
          color: colorWhite, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          SvgPicture.asset(img),
          SizedBox(
            width: 19,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? '21',
                textScaleFactor: textScale(context),
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width -
                    marginScale(context, 135),
                child: Text(
                  text ?? 'Вы оплатили курс',
                  textScaleFactor: textScale(context),
                  maxLines: 4,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: greys.withOpacity(0.8),
                      fontWeight: FontWeight.w300),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

iconSwitch(type) {
  switch (type) {
    case '1':
      return 'assets/img/noti2.svg';

    case '2':
      return 'assets/img/noti.svg';
    case '3':
      return 'assets/img/notiSetting.svg';
    case '4':
      return 'assets/img/notiNews.svg';

    default:
      return 'assets/img/defNoti.svg';
  }
}

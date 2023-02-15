import 'package:barber/api/MyCourse/IMyCourse.dart';
import 'package:barber/api/MyCourse/myCourseApi.dart';
import 'package:barber/pages/NoAuth/noAds.dart';
import 'package:barber/pages/product_page/product_appbar.dart';
import 'package:barber/provider/globalData.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:barber/res/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class MyCourse extends StatefulWidget {
  MyCourse({Key? key}) : super(key: key);

  @override
  State<MyCourse> createState() => _MyCourseState();
}

class _MyCourseState extends State<MyCourse> with TickerProviderStateMixin {
  late TabController _courseTabController;

  int totalPages = 0;
  List<ProductsCourse> passedLesson = [];
  List<ProductsCourse> workingLesson = [];

  bool isLoad = true;

  getData() async {
    setState(() {
      isLoad = true;
    });
    String token = context.read<GlobalData>().loginToken ?? '';
    List<IMyCourse> data = await getMyCourse(login: token);

    if (data.isNotEmpty) {
      for (int a = 0; a < data[0].products!.length; a++) {
        if (data[0].products![a].progressCount ==
            data[0].products![a].lessonsCount) {
          passedLesson.add(data[0].products![a]);
        } else {
          workingLesson.add(data[0].products![a]);
        }
      }
    }

    isLoad = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();

    TabController _courseTabController = TabController(length: 2, vsync: this);
  }

  TabBar get _courseTabBar => TabBar(
        tabs: [
          Tab(
            text: 'В изучении',
          ),
          Tab(text: 'Завершено')
        ],
        unselectedLabelColor: greyColor,
        unselectedLabelStyle: headLine4Reg,
        labelColor: primary_color,
        labelStyle: Theme.of(context).textTheme.headline4,
        indicator: BoxDecoration(
            border: Border(bottom: BorderSide(color: primary_color, width: 3))),
        indicatorSize: TabBarIndicatorSize.tab,
      );

  @override
  Widget build(BuildContext context) {
    if (isLoad == true) {
      return Scaffold(
          body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(child: CircularProgressIndicator())));
    }
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Мои Курсы',
              textScaleFactor: textScale(context),
              style: Theme.of(context).textTheme.headline2,
            ),
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: SvgPicture.asset('assets/img/arrowBack.svg')),
            bottom: PreferredSize(
              preferredSize: _courseTabBar.preferredSize,
              child: ColoredBox(
                  color: Theme.of(context).cardColor, child: _courseTabBar),
            ),
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: marginScale(context, 15)),
                  child: Padding(
                    padding: EdgeInsets.only(top: marginScale(context, 20)),
                    child: workingLesson.isEmpty
                        ? noAds(
                            context: context,
                            noText: false,
                            assets: "assets/img/welcome2.svg")
                        : Column(
                            children: [
                              ...workingLesson.map((e) => myCourse(
                                  context,
                                  e.file ?? '',
                                  e.name ?? '',
                                  e.price ?? '',
                                  e.lessonsCount ?? '0',
                                  e.progressCount ?? '0',
                                  e.id ?? '0',
                                  e.progressDuration)),
                            ],
                          ),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: marginScale(context, 15)),
                  child: Padding(
                    padding: EdgeInsets.only(top: marginScale(context, 20)),
                    child: passedLesson.isEmpty
                        ? noAds(
                            context: context,
                            noText: false,
                            assets: "assets/img/welcome2.svg")
                        : Column(
                            children: [
                              ...passedLesson.map((e) => myCourse(
                                  context,
                                  e.file ?? '',
                                  e.name ?? '',
                                  e.price ?? '',
                                  e.lessonsCount ?? '0',
                                  e.progressCount ?? '0',
                                  e.id ?? '0',
                                  e.progressDuration)),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  myCourse(BuildContext context, String img, String name, String price,
      String course, String incourse, String id, String? time) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductAppBar(
                      name: name,
                      price: price,
                      id: id,
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: marginScale(context, 15)),
        padding: EdgeInsets.all(marginScale(context, 10)),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  offset: Offset(4, 6),
                  color: Color.fromARGB(6, 15, 01, 4),
                  blurRadius: 60)
            ],
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: marginScale(context, 80),
              width: marginScale(context, 80),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.all(Radius.circular(marginScale(context, 20))),
                child: Image.network(
                  img,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: marginScale(context, 12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textScaleFactor: textScale(context),
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: marginScale(context, 10)),
                    child: Text(
                      time != null
                          ? '${(double.parse(time) / 60).toStringAsFixed(1)}ч'
                          : '',
                      textScaleFactor: textScale(context),
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(color: Colors.grey),
                    ),
                  ),
                  LinearPercentIndicator(
                    padding: EdgeInsets.zero,
                    animation: true,
                    animationDuration: 1000,
                    barRadius: Radius.circular(5),
                    width: MediaQuery.of(context).size.width * 0.4,
                    lineHeight: 10,
                    percent:
                        (double.parse(incourse) / double.parse(course) > 1.0)
                            ? 1
                            : double.parse(incourse) / double.parse(course),
                    backgroundColor: Colors.grey.withOpacity(0.5),
                    progressColor: colorSwitch(
                        double.parse(incourse), double.parse(course)),
                    trailing: Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Row(
                        children: [
                          Text(
                            '${incourse.toString()}/',
                            textScaleFactor: textScale(context),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Text(
                            course.toString(),
                            textScaleFactor: textScale(context),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  colorSwitch(
    double ins,
    double course,
  ) {
    int res = (ins / course * 10).round();
    switch (res) {
      case 1:
      case 2:
      case 3:
      case 4:
        return Colors.red;

      case 5:
      case 6:
      case 7:
        return Colors.yellow;
      case 8:
      case 9:
        return Colors.green;
      case 10:
        return primary_color;
    }
  }
}

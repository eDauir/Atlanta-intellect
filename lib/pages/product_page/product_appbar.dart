import 'package:barber/api/Comments/IComments.dart';
import 'package:barber/api/Comments/commentsApi.dart';
import 'package:barber/api/MyCourse/IMyCourse.dart';
import 'package:barber/api/MyCourse/myCourseApi.dart';
import 'package:barber/api/Product/IProduct.dart';
import 'package:barber/api/Product/productApi.dart';
import 'package:barber/api/Wallet/walletApi.dart';
import 'package:barber/api/checkAuth.dart';
import 'package:barber/api/payboxApi.dart';
import 'package:barber/pages/Profile/account/vars.dart';
import 'package:barber/pages/Profile/account/widgets/wallet/wallet.dart';
import 'package:barber/pages/product_page/components/product_lessons.dart';
import 'package:barber/pages/product_page/components/product_mentors.dart';
import 'package:barber/pages/product_page/components/product_otziv.dart';
import 'package:barber/pages/product_page/components/product.dart';
import 'package:barber/provider/globalData.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:barber/res/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductAppBar extends StatefulWidget {
  String img;
  String name;
  String price;
  String id;

  ProductAppBar(
      {Key? key,
      this.img = '',
      this.name = '',
      required this.price,
      required this.id})
      : super(key: key);

  @override
  State<ProductAppBar> createState() => _ProductAppBarState();
}

class _ProductAppBarState extends State<ProductAppBar>
    with TickerProviderStateMixin {
  late TabController _tabController;

  bool isOffline = false;

  List<Product> products = [];
  List<Sections> sections = [];
  List<UserInfo> userInfo = [];

  List<IComments>? comments;

  bool isBuy = false;

  String payboxLink = '';

  int allDuration = 0;
  int lessonCount = 0;

  bool isPassedCourse = false;

  List myProgress = [];
  List<IProductProgress> myProgressFinish = [];
  var login;
  var editor;
  bool isLoad = true;
  bool getLog = false;

  bool isEnableBuyBtn = false;

  checkAuth() async {
    login = await getCheckedLogin();
    if (login.isNotEmpty) {
      getLog = true;
    }
  }

  changeBuy(bool isbuy, String link) {
    setState(() {
      isBuy = isbuy;
      payboxLink = link;
    });
  }

  getData() async {
    setState(() {
      isLoad = true;
    });

    List<IProductId>? data = await getProductId(productId: widget.id);
    if (data != null && data.isNotEmpty) {
      isOffline = data[0].product![0].online == '0' ? true : false;
      var login = context.read<GlobalData>().loginToken;
      if (login != null && login.isNotEmpty) {
        List<IMyCourse> myCourseData = await getMyCourse(login: login);

        if (myCourseData.isNotEmpty) {
          for (ProductsCourse a in myCourseData[0].products!) {
            if (a.id == widget.id) {
              isBuy = true;
              break;
            }
          }

          if (isBuy == true) {
            var isMyProgres =
                await getProgressProduct(data[0].product![0].id, login);
            List<IProductProgress> getFinishProgress =
                await getProgressProductFinish(data[0].product![0].id, login);

            myProgress = isMyProgres ?? [];
            myProgressFinish = getFinishProgress;
          }
        }
      }
      comments = await getComments(
        id: widget.id,
      );
      if (isOffline == false) {
        sections = data[0].sections ?? [];
        allDuration = data[0].allDuration ?? 0;
        lessonCount = data[0].lessonsCount ?? 0;
        if (lessonCount == myProgress.length) {
          isPassedCourse = true;
        }
      }
      products = data[0].product ?? [];
      userInfo = data[0].userInfo ?? [];
    }

    isLoad = false;
    setState(() {});
  }

  changePassedCourse() {
    setState(() {
      isPassedCourse = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    checkAuth();
    TabController _tabController = TabController(length: 3, vsync: this);
  }

  TabBar get _tabBar => TabBar(
        tabs: [
          Tab(
            text: 'О курсе',
          ),
          if (isOffline == false) Tab(text: 'Уроки'),
          Tab(text: 'Отзывы')
        ],
        unselectedLabelColor: greyColor,
        labelColor: primary_color,
        unselectedLabelStyle: headLine4Reg!.copyWith(color: greyColor),
        labelStyle: Theme.of(context).textTheme.headline4,
        indicator: BoxDecoration(
            border: Border(bottom: BorderSide(color: primary_color, width: 3))),
        indicatorSize: TabBarIndicatorSize.tab,
      );

  @override
  Widget build(BuildContext context) {
    if (isLoad)
      return Scaffold(
          body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(child: CircularProgressIndicator())));
    return Padding(
      padding: EdgeInsets.zero,
      child: Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) => DefaultTabController(
              length: 3,
              child: NestedScrollView(
                headerSliverBuilder: (context, value) {
                  print(constraints);
                  return [
                    SliverAppBar(
                      leading: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: SvgPicture.asset(
                                'assets/img/arrowBack.svg',
                                color: colorWhite,
                              )),
                        ],
                      ),
                      floating: true,
                      pinned: true,
                      backgroundColor: Theme.of(context).canvasColor,
                      expandedHeight: 480,
                      flexibleSpace: FlexibleSpaceBar(
                        background: ProductPage(
                          lessonCount: lessonCount,
                          products: products,
                          isOffline: isOffline,
                          durationLesson: allDuration.toString(),
                          id: widget.id,
                        ),
                      ),
                      bottom: PreferredSize(
                        preferredSize: _tabBar.preferredSize,
                        child: ColoredBox(
                            color: Theme.of(context).canvasColor,
                            child: _tabBar),
                      ),
                    ),
                  ];
                },
                body: TabBarView(children: [
                  ProductMentors(
                    productInfo: products[0].about ?? '',
                    mentor: userInfo[0],
                    mentorId: userInfo[0].userId ?? '',
                  ),
                  if (isOffline == false)
                    ProductLessons(
                      isBuy: isBuy,
                      section: sections,
                      lessonCount: lessonCount,
                      myProgress: myProgress,
                      myProgressFinish: myProgressFinish,
                      isPassedCourse: isPassedCourse,
                      changePassedCourse: changePassedCourse,
                    ),
                  ProductOtziv(
                    id: widget.id,
                    isBought: isBuy,
                    isOffline: isOffline,
                    productId: widget.id,
                    initData: comments ?? [],
                  )
                ]),
              ),
            ),
          ),
          bottomSheet: isPassedCourse == true || isBuy
              ? isOffline
                  ? boughtOfflineCourse(context)
                  : null
              : Container(
                  height: marginScale(context, 64),
                  padding: EdgeInsets.all(marginScale(context, 10)),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (getLog == false) {
                        return showModalDonAuth(context);
                      }
                      if (mailStatus == false) {
                        return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            marginScale(context, 20)))),
                                contentPadding: EdgeInsets.zero,
                                actionsPadding: EdgeInsets.symmetric(
                                    horizontal: marginScale(context, 20),
                                    vertical: marginScale(context, 20)),
                                actionsAlignment: MainAxisAlignment.center,
                                alignment: Alignment.center,
                                actions: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                          'assets/img/confirm.svg'),
                                      SizedBox(
                                        height: marginScale(context, 15),
                                      ),
                                      Text(
                                        'Подтвердите Email ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2!
                                            .copyWith(color: primary_color),
                                      ),
                                      SizedBox(
                                        height: marginScale(context, 15),
                                      ),
                                      Text(
                                        'Для покупки требуется подтверждение аккаунта',
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

                      if (context.read<GlobalData>().isBuyTarif) {
                        String login =
                            context.read<GlobalData>().loginToken ?? '';
                        if (login.isEmpty || isEnableBuyBtn) return;

                        isEnableBuyBtn = true;
                        final loadShow = showLoading(context);
                        Navigator.of(context).push(loadShow);
                        await buyCoursePartner(
                          login: login,
                          productId: widget.id,
                          amount: '5',
                        );
                        Navigator.of(context).pop();
                        await getData();
                        isEnableBuyBtn = false;

                        return;
                      } else {
                        context.go('/tarif');
                      }
                    },
                    child: Text(
                      context.read<GlobalData>().isBuyTarif
                          ? 'Активировать'
                          : 'Присоединиться',
                      textScaleFactor: textScale(context),
                    ),
                  ),
                )),
    );
  }

  congrutulationBuyDialog(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(marginScale(context, 20)))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset('assets/img/buyTarif.svg'),
                SizedBox(
                  height: marginScale(context, 30),
                ),
                Text('Поздравляем!',
                    style: Theme.of(context).textTheme.headline2!),
                SizedBox(
                  height: marginScale(context, 15),
                ),
                Text(
                  'Вы успешно произвели оплату и записались на курс.',
                  style: headLine5Med,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: marginScale(context, 20),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Закрыть'))
              ],
            ),
          );
        });
  }

  notAmount(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(marginScale(context, 20)))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset('assets/img/buyTarif.svg'),
                SizedBox(
                  height: marginScale(context, 30),
                ),
                Text('Нету денег!',
                    style: Theme.of(context).textTheme.headline2!),
                SizedBox(
                  height: marginScale(context, 15),
                ),
                Text(
                  'Вы успешно произвели оплату и записались на курс.',
                  style: headLine5Med,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: marginScale(context, 20),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WalletPage()));
                      // Navigator.pop(context);
                    },
                    child: Text('Закрыть'))
              ],
            ),
          );
        });
  }

  boughtOfflineCourse(context) {
    return Container(
      height: marginScale(context, 64),
      padding: EdgeInsets.all(marginScale(context, 10)),
      child: ElevatedButton(
          onPressed: () async {
            showModal(
                context,
                Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: SvgPicture.asset('assets/img/clipboard.svg'),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: primary_color,
                          borderRadius: BorderRadius.all(Radius.circular(100))),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text('Квитанция о курсе',
                        style: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith(color: primary_color)),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '· Вы купили курс: ${products[0].name}',
                              style: headLine4Med,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '· Цена: ₸${products[0].price}',
                              style: headLine4Med,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () => {Navigator.pop(context)},
                      child: Text('Закрыть'),
                    )
                  ],
                ));
          },
          child: Text(
            'Мой билет',
            textScaleFactor: textScale(context),
          )),
    );
  }
}

import 'package:barber/api/Mentors/IMentor.dart';
import 'package:barber/api/Mentors/mentorsApi.dart';
import 'package:barber/api/home/Ihome.dart';
import 'package:barber/api/home/homeApi.dart';
import 'package:barber/generated/locale_keys.g.dart';
import 'package:barber/pages/Experts/Experts.dart';
import 'package:barber/pages/NoAuth/noAds.dart';
import 'package:barber/pages/list/tiles_product.dart';
import 'package:barber/pages/mentor_page/mentor.dart';
import 'package:barber/pages/product_page/product_appbar.dart';
import 'package:barber/provider/globalData.dart';
import 'package:barber/provider/homeData.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:barber/res/widgets/inputWidget.dart';
import 'package:barber/res/widgets/pagination.dart';
import 'package:barber/res/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  Object? extra;

  Search({
    super.key,
    this.extra,
  });

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  dynamic extra;
  int ActiveIndex = 0;
  bool isIgnoreExtra = false;
  bool isLoad = true;
  bool isLoadPress = false;

  String searchKeyInput = '';
  int totalPage = 0;
  int curPage = 1;
  List<Workers> mentors = [];
  List<Products> products = [];

  String findCount = '1';

  final myController = TextEditingController();

  initValue() {
    setState(() {
      isLoad = true;
    });

    checkActiveIndex();
    setState(() {
      mentors = context.read<GlobalData>().mentors;
      products = context.read<HomeData>().productsMap!['🔥 Все'] ?? [];
      // findCount =
      isLoad = false;
      if (ActiveIndex == 0) {
        totalPage = context.read<HomeData>().productsTotalPage;
        findCount = context.read<HomeData>().findTotal;
        curPage = (products.length / 2).ceil();
      } else {
        totalPage = context.read<GlobalData>().mentorsTotalPage;
        findCount = context.read<GlobalData>().findTotalMentors;
        curPage = (mentors.length / 2).ceil();
      }
    });
  }

  checkActiveIndex() {
    if (widget.extra != null && isIgnoreExtra == false) {
      extra = widget.extra as Map;

      ActiveIndex = extra['index'];
    }
  }

  getData({
    String page = '1',
    String searchKey = '',
  }) async {
    setState(() {
      isLoad = true;
    });

    if (searchKey.isEmpty && (page == '1')) {
      return initValue();
    }

    checkActiveIndex();

    if (ActiveIndex == 0) {
      await getProductsData(searchKey: searchKey, page: page);
    } else {
      await getMentorsData(searchKey: searchKeyInput, page: page);
    }
    curPage = int.parse(page);
    isLoad = false;

    setState(() {});
  }

  getProductsData({String searchKey = '', required String page}) async {
    List<IHome> data = await getProduct(searchKey: searchKeyInput, page: page);

    if (page == '1' && searchKey.isNotEmpty) {
      products = data[0].products ?? [];
    } else {
      for (var i in data[0].products!) {
        products.add(i);
      }
    }
    totalPage = data[0].count ?? 0;
    findCount = data[0].total ?? '0';
  }

  getMentorsData({String searchKey = '', required String page}) async {
    List<IMentor> data =
        await getMentors(searchKey: searchKeyInput, page: page);
    if (page == '1' && searchKey.isNotEmpty) {
      mentors = data[0].workers ?? [];
    } else {
      for (var i in data[0].workers!) {
        mentors.add(i);
      }
    }
    totalPage = data[0].count ?? 0;
    findCount = data[0].total ?? '0';
  }

  late FocusNode focusNode;
  @override
  void initState() {
    super.initState();
    initValue();
    // getData();

    focusNode = FocusNode();
    focusNode.addListener(() {
      setState(() {});
    });
  }

  onSubmit(String value) async {
    searchKeyInput = myController.text;
    await getData(searchKey: value);
  }

  @override
  Widget build(BuildContext context) {
    // if (isLoad) return CircularProgressIndicator();
    return Container(
      color: homeBg,
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          left: marginScale(context, 10),
          right: marginScale(context, 10)),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 19),
            child: InputWidget(
              controller: myController,
              hintText: LocaleKeys.i_search.tr(),
              prefixIconPath: 'assets/img/searchForSearchPage.svg',
              onFieldSubmitted: (value) {
                onSubmit(value);
                isLoadPress = true;
              },
            ),
          ),
          Container(
            child: chooseBtn(
              text1: LocaleKeys.courses.tr(),
              text2: LocaleKeys.mentors.tr(),
              fun1: () async {
                setState(() {
                  ActiveIndex = 0;
                  isIgnoreExtra = true;
                  myController.text = '';
                  searchKeyInput = '';
                  mentors = [];
                  products = [];
                });
                await getData(searchKey: searchKeyInput);
              },
              fun2: () async {
                setState(() {
                  ActiveIndex = 1;
                  isIgnoreExtra = true;
                  myController.text = '';
                  searchKeyInput = '';
                  products = [];
                  mentors = [];
                });
                await getData(searchKey: searchKeyInput);
              },
              activeIndex: ActiveIndex,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: marginScale(context, 10)),
            child: Text(
              !isLoadPress ? '' : '$findCount найдено',
              textScaleFactor: textScale(context),
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(color: primary_color),
            ),
          ),
          isLoad
              ? CircularProgressIndicator()
              : isLoadPress
                  ? Column(
                      children: [
                        if (ActiveIndex == 1)
                          ...mentors.map((e) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Mentor(
                                              id: e.userId!,
                                            )));
                              },
                              child: ItemExpert(
                                  name: e.name,
                                  avater: e.avatar,
                                  job: e.job,
                                  context: context),
                            );
                          }),
                        if (ActiveIndex == 0)
                          ...products.map((e) {
                            return Container(
                              margin: EdgeInsets.only(
                                  bottom: marginScale(context, 15)),
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProductAppBar(
                                                  name: e.name ?? '',
                                                  price: e.price ?? '15000',
                                                  id: e.id ?? '0',
                                                )));
                                  },
                                  child: Tile(
                                    img: e.file ?? '',
                                    text: e.name ?? '',
                                    cat: e.catName,
                                    price: e.price ?? '15000',
                                    isFav: false,
                                    id: e.id ?? '88',
                                    starCount:
                                        '${(double.parse(e.rating ?? '0')).toStringAsFixed(1)}',
                                    starFeedback: e.ratingCount,
                                    lessonCount: e.lessonsCount,
                                    hour:
                                        '${(double.parse(e.lessonsDuration ?? '0') / 60).toStringAsFixed(1)}ч',
                                  )),
                            );
                          }),
                        if (totalPage > 1 && totalPage > curPage)
                          btnMore(context, getData, curPage),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/img/search_first.svg',
                          width: marginScale(context, 230),
                        ),
                        SizedBox(
                          height: marginScale(context, 15),
                        ),
                        Text(
                          'Здесь вы найдете все необходимое вам онлайн-курса и эксперта',
                          textAlign: TextAlign.center,
                          style: headLine4Reg,
                        )
                      ],
                    ),
          if (((ActiveIndex == 0 && products.isEmpty) ||
                  (ActiveIndex == 1 && mentors.isEmpty)) &&
              isLoad == false)
            Container(
                margin: EdgeInsets.only(top: 15),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: noAds(context: context))
        ],
      ),
    );
  }
}

class chooseBtn extends StatefulWidget {
  Function fun1;
  Function fun2;
  String text1;
  String text2;
  // activeIndex = 1|2;
  int? activeIndex;

  chooseBtn(
      {super.key,
      required this.fun1,
      required this.fun2,
      this.activeIndex,
      this.text1 = 'Курсы',
      this.text2 = 'Эксперты'});
  @override
  State<chooseBtn> createState() => _chooseBtnState();
}

class _chooseBtnState extends State<chooseBtn> {
  int ActiveBtnIndex = 0;
  bool replace = false;
  @override
  Widget build(BuildContext context) {
    if (replace == false) {
      ActiveBtnIndex = widget.activeIndex ?? 0;
    }
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: ActiveBtnIndex == 0 ? primary_color : null,
                  side: BorderSide(color: primary_color, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    ActiveBtnIndex = 0;
                    replace = true;
                  });
                  widget.fun1();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: marginScale(context, 10),
                      vertical: marginScaleWC(11)),
                  child: Text(widget.text1,
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: ActiveBtnIndex == 0
                              ? colorWhite
                              : primary_color)),
                )),
          ),
          SizedBox(
            width: marginScale(context, 15),
          ),
          Expanded(
            child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: ActiveBtnIndex == 1 ? primary_color : null,
                  side: BorderSide(color: primary_color, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    ActiveBtnIndex = 1;
                    replace = true;
                  });
                  widget.fun2();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: marginScale(context, 10),
                      vertical: marginScaleWC(11)),
                  child: Text(widget.text2,
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: ActiveBtnIndex == 1
                              ? colorWhite
                              : primary_color)),
                )),
          ),
        ],
      ),
    );
  }
}

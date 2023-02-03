import 'package:barber/api/home/Ihome.dart';
import 'package:barber/api/home/homeApi.dart';
import 'package:barber/pages/Home/components/ListViewHor.dart';
import 'package:barber/pages/list/tiles_product.dart';
import 'package:barber/pages/product_page/product_appbar.dart';
import 'package:barber/provider/globalData.dart';
import 'package:barber/provider/homeData.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:barber/res/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class MoreProduct extends StatefulWidget {
  MoreProduct({Key? key}) : super(key: key);

  @override
  State<MoreProduct> createState() => _MoreProductState();
}

class _MoreProductState extends State<MoreProduct> {
  List<Products>? products = [];
  ScrollController _scrollController = ScrollController();

  int currentPage = 1;
  int totalPage = 1;

  bool isLoad = false;

  getData({required String page, String searchKey = ''}) async {
    setState(() {
      isLoad = true;
    });

    String categoryId = context.read<HomeData>().currentCategoryId;

    List<IHome>? data = await getProduct(page: page, id: categoryId);

    currentPage = int.parse(page);
    totalPage = data![0].count ?? 1;

    print(totalPage);
    print(currentPage);

    context.read<HomeData>().addMore(data[0].products ?? []);

    isLoad = false;
    setState(() {});
  }

  initData(int? totalPageData) async {
    setState(() {
      isLoad = true;
    });

    currentPage = 1;
    totalPage = totalPageData ?? context.read<HomeData>().productsTotalPage;

    isLoad = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initData(5);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if ((++currentPage) <= totalPage) {
          getData(page: (++currentPage).toString());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Products>? curProducts = context.read<HomeData>().products ?? [];

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset('assets/img/arrowBack.svg')),
          title: Text(
            'Все курсы',
            style: Theme.of(context).textTheme.headline2,
            textScaleFactor: textScale(context),
          )),
      body: isLoad
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: marginScale(context, 10)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListViewHor(
                      isHome: false,
                      initCategoryPage: initData,
                    ),
                    SizedBox(
                      height: marginScale(context, 20),
                    ),
                    ...curProducts.map((e) {
                      return Container(
                        margin:
                            EdgeInsets.only(bottom: marginScale(context, 15)),
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
                              price: e.price ?? '15000',
                              cat: e.catName,
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
                    if (totalPage > 1 && totalPage >= currentPage)
                      btnMore(context, getData, currentPage),
                  ],
                ),
              ),
            ),
    );
  }
}

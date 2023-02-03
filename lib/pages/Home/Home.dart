import 'package:barber/api/home/Ihome.dart';
import 'package:barber/api/home/homeApi.dart';
import 'package:barber/pages/Home/components/ListViewHor.dart';
import 'package:barber/pages/Home/components/mentors.dart';
import 'package:barber/pages/list/tiles_product.dart';
import 'package:barber/pages/product_page/product_appbar.dart';
import 'package:barber/pages/Home/components/sliderBanner.dart';
import 'package:barber/provider/homeData.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:barber/res/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Products>? products;

  getData() async {
    List<IHome> data = await getProduct();
    context.read<HomeData>().setProducts(
        data[0].products ?? [], data[0].count ?? 0, data[0].total, '🔥 Все');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // getData();
  }

  @override
  Widget build(BuildContext context) {
    products = context.watch<HomeData>().products;
    return Container(
      padding: EdgeInsets.only(
          left: marginScale(context, 10),
          right: marginScale(context, 10),
          top: MediaQuery.of(context).padding.top),
      color: homeBg,
      child: Column(
        children: [
          SizedBox(
            height: marginScale(context, 26),
          ),
          SliderBanner(),
          SizedBox(
            height: marginScale(context, 20),
          ),
          Mentors(),
          SizedBox(
            height: marginScale(context, 10),
          ),
          ListViewHor(
            isHome: true,
          ),
          SizedBox(
            height: marginScale(context, 15),
          ),
          context.watch<HomeData>().products == null
              ? Text('NO DATA')
              : Container(
                  padding: EdgeInsets.only(
                      right: 5, bottom: marginScale(context, 15)),
                  child: Column(
                    children: [
                      ...context.watch<HomeData>().products!.map((e) {
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
                    ],
                  ),
                )
        ],
      ),
    );
  }
}

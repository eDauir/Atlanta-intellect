import 'package:barber/api/Favorite/favoriteApi.dart';
import 'package:barber/api/home/Ihome.dart';
import 'package:barber/pages/NoAuth/noFav.dart';
import 'package:barber/pages/list/lists.dart';
import 'package:barber/provider/globalData.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:barber/res/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Favorite extends StatefulWidget {
  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List<Products> products = [];
  int totalPage = 1;
  int curPage = 1;

  bool isLoad = true;

  getFavoriteData({String page = '0', String searchKey = ''}) async {
    setState(() {
      isLoad = true;
    });
    var login = context.read<GlobalData>().loginToken;
    if (login != null) {
      List<IHome> data = await getFavoriteCards(login, page);
      if (data != null && data.isNotEmpty) {
        products = data[0].products ?? [];
        totalPage = data[0].count!;
      }
    }
    curPage = int.parse(page);
    isLoad = false;
    setState(() {});
  }

  checkProducts(List<Products> arr) {
    setState(() {
      products = arr;
    });
  }

  @override
  void initState() {
    super.initState();
    getFavoriteData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: homeBg,
        appBar: AppBar(
          leading: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: SvgPicture.asset('assets/img/arrowBack.svg')),
            ],
          ),
          title: Text(
            'Избранные',
            textScaleFactor: textScale(context),
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        body: isLoad
            ? Container(
                height: MediaQuery.of(context).size.height - 120,
                child: Center(child: CircularProgressIndicator()))
            : products.isNotEmpty
                ? Column(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            ListItem(
                              productsProps: products,
                              checkProductsParent: checkProducts,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      if (totalPage > 1 && totalPage > curPage)
                        btnMore(context, getFavoriteData, curPage),
                      // Pagination(
                      //     AllEndPage: totalPage,
                      //     currentPage: curPage,
                      //     changePage: getFavoriteData)
                    ],
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: marginScale(context, 15)),
                    child: Align(
                        alignment: Alignment.center, child: noFav(context)),
                  ));
  }
}

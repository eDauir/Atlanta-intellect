import 'package:barber/api/Category/ICategory.dart';
import 'package:barber/api/Category/categoryApi.dart';
import 'package:barber/api/home/Ihome.dart';
import 'package:barber/api/home/homeApi.dart';
import 'package:barber/generated/locale_keys.g.dart';
import 'package:barber/pages/Home/components/more/more_product/more_product.dart';
import 'package:barber/provider/globalData.dart';
import 'package:barber/provider/homeData.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ListViewHor extends StatefulWidget {
  bool isHome;
  Function? initCategoryPage;
  ListViewHor({Key? key, required this.isHome, this.initCategoryPage})
      : super(key: key);
  @override
  State<ListViewHor> createState() => _ListViewHorState();
}

class _ListViewHorState extends State<ListViewHor> {
  List<ICategory> categories = [];

  getData() async {
    categories = await getCategory();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // getData();
  }

  @override
  Widget build(BuildContext context) {
    categories = context.read<GlobalData>().categories;
    List items = List<Widget>.generate(
        categories.length,
        (i) => buildOutlinedBtn(
              data: categories[i],
              initCategoryPage: widget.initCategoryPage,
            ));

    return Column(
      children: [
        widget.isHome
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.our_courses.tr(),
                    textScaleFactor: textScale(context),
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => MoreProduct())));
                        // context.go('/search', extra: {'index': 0});
                      },
                      child: Text(
                        LocaleKeys.all.tr(),
                        textScaleFactor: textScale(context),
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(color: primary_color),
                      ))
                ],
              )
            : SizedBox(),
        SizedBox(
          height: marginScale(context, 15),
        ),
        Container(
          height: marginScale(context, 35),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              buildOutlinedBtn(
                initCategoryPage: widget.initCategoryPage,
              ),
              ...items.map((e) => e)
            ],
          ),
        ),
      ],
    );
  }
}

class buildOutlinedBtn extends StatefulWidget {
  ICategory? data;
  Function? initCategoryPage;
  buildOutlinedBtn({Key? key, this.data, this.initCategoryPage})
      : super(key: key);

  @override
  State<buildOutlinedBtn> createState() => _buildOutlinedBtnState();
}

class _buildOutlinedBtnState extends State<buildOutlinedBtn> {
  bool isActive = false;
  @override
  Widget build(BuildContext context) {
    String activeIndex = context.read<HomeData>().activeIndex;
    if (widget.data != null) {
      isActive = activeIndex == widget.data!.id;
    } else {
      isActive = activeIndex == '0';
    }

    setInitPage(data) {
      if (widget.initCategoryPage != null) {
        widget.initCategoryPage!(data[0].count);
      }
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: marginScale(context, 5)),
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              backgroundColor: isActive ? primary_color : colorWhite),
          onPressed: () async {
            if (widget.data == null) {
              if (context.read<HomeData>().activeIndex != '0') {
                context.read<HomeData>().setActiveIndex = '0';
                context.read<HomeData>().setCurrentCategory = '';
                List<IHome> data = await getProduct();
                context.read<HomeData>().setProducts(
                    data[0].products ?? [],
                    data[0].count ?? 0,
                    data[0].total,
                    widget.data?.name ?? '🔥 Все');
                setInitPage(data);
              }
              return;
            }

            if (context.read<HomeData>().activeIndex == widget.data!.id &&
                isActive == true) {
              context.read<HomeData>().setActiveIndex = '0';
              context.read<HomeData>().setCurrentCategory = '';
              List<IHome> data = await getProduct();
              context.read<HomeData>().setProducts(
                  data[0].products ?? [],
                  data[0].count ?? 0,
                  data[0].total,
                  widget.data?.name ?? '🔥 Все');
              setInitPage(data);
            } else {
              context.read<HomeData>().setActiveIndex =
                  widget.data != null ? widget.data!.id ?? '0' : '-1';
              context.read<HomeData>().setCurrentCategory =
                  widget.data?.id ?? '';
              List<IHome> data = await getProduct(id: widget.data?.id ?? '');

              context.read<HomeData>().setProducts(
                  data[0].products ?? [],
                  data[0].count ?? 0,
                  data[0].total,
                  widget.data?.name ?? '🔥 Все');
              setInitPage(data);
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: marginScale(context, 2),
                vertical: marginScale(context, 1)),
            child: Text(
              widget.data?.name ?? '🔥 Все',
              textScaleFactor: textScale(context),
              style: Theme.of(context).textTheme.headline5!.copyWith(
                  color: isActive ? colorWhite : primary_color, height: 1),
            ),
          )),
    );
  }
}

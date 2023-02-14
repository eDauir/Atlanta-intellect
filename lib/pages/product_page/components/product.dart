import 'package:barber/api/Favorite/favoriteApi.dart';
import 'package:barber/api/Product/IProduct.dart';
import 'package:barber/provider/favoriteData.dart';
import 'package:barber/provider/globalData.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:barber/res/widgets/Video.dart';
import 'package:barber/res/widgets/formaters.dart';
import 'package:barber/res/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  String? durationLesson;
  String id;
  int? lessonCount;
  List<Product> products;
  bool isOffline;

  ProductPage(
      {Key? key,
      required this.products,
      this.durationLesson,
      required this.isOffline,
      required this.id,
      this.lessonCount})
      : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Product> products = [];
  bool isLoadLike = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isLikeId = context.read<FavoriteData>().checkFavoriteCard(widget.id);
    products = widget.products;
    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) => Center(
          child: Container(
            // color: Colors.red,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      child: Image.network(
                        products[0].file!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (products[0].intro != null)
                      Positioned.fill(
                          child: Center(
                              child: IconButton(
                                  padding: EdgeInsets.zero,
                                  iconSize: marginScale(context, 30),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => WillPopScope(
                                        onWillPop: () async {
                                          Navigator.pop(context);
                                          return false;
                                        },
                                        child: Dialog(
                                          insetPadding: EdgeInsets.zero,
                                          backgroundColor: Colors.black,
                                          child: Stack(
                                            children: [
                                              VideoWidget(
                                                  isAutoPlayAndFull: true,
                                                  
                                                  link:
                                                      products[0].intro ?? ''),
                                              Positioned(
                                                top: marginScale(context, 50),
                                                child: IconButton(
                                                    padding: EdgeInsets.zero,
                                                    splashRadius: 10,
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    icon: Icon(
                                                      Icons.arrow_back,
                                                      color: Colors.white,
                                                    )),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                    // VideoWidget(
                                    //   link: 'https://zheruiyq.com/digway/videos/1.mp4',
                                    // );
                                  },
                                  icon: Container(
                                      width: marginScale(context, 56),
                                      height: marginScale(context, 56),
                                      decoration: BoxDecoration(
                                          color: colorWhite,
                                          borderRadius: BorderRadius.circular(
                                              marginScale(context, 28))),
                                      child: Icon(
                                        Icons.play_circle_fill,
                                        size: marginScale(context, 18),
                                      ))))),
                    if (widget.isOffline)
                      Positioned(
                          bottom: marginScale(context, 15),
                          left: marginScale(context, 15),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: marginScale(context, 81),
                                maxHeight: marginScale(context, 27)),
                            decoration: BoxDecoration(
                                color: colorsOrange,
                                borderRadius: BorderRadius.circular(
                                    marginScale(context, 8))),
                            child: Center(
                              child: Text(
                                'Офлайн',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(color: colorWhite),
                              ),
                            ),
                          ))
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                          horizontal: marginScale(context, 15),
                          vertical: marginScale(context, 15))
                      .copyWith(top: marginScaleWC(20)),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            top: marginScale(context, 0),
                            bottom: marginScale(context, 0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width -
                                    marginScale(context, 70),
                              ),
                              child: Text(
                                products[0].name ?? '',
                                textScaleFactor: textScale(context),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3!
                                    .copyWith(fontSize: 24),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // ! Like product
                            IconButton(
                              onPressed: () async {
                                var login =
                                    context.read<GlobalData>().loginToken;
                                if (login == null) {
                                  return;
                                }

                                if (login.isEmpty) return;

                                if (isLikeId) {
                                  setState(() {
                                    isLoadLike = true;
                                  });
                                  await delFavoriteCard(login, widget.id);
                                  isLoadLike = false;
                                } else {
                                  setState(() {
                                    isLoadLike = true;
                                  });
                                  await addFavoriteCard(login, widget.id);
                                  isLoadLike = false;
                                }
                                context
                                    .read<FavoriteData>()
                                    .putFavoriteCard(widget.id);
                                setState(() {});
                              },
                              icon: SvgPicture.asset(
                                isLikeId
                                    ? 'assets/img/activeFav.svg'
                                    : 'assets/img/favIcon.svg',
                                width: marginScale(context, 24),
                                height: marginScale(context, 24),
                              ),
                              splashRadius: 20,
                            )
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Container(
                                    margin: EdgeInsets.only(
                                        top: marginScale(context, 10),
                                        bottom: marginScale(context, 10)),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: marginScale(context, 8),
                                        vertical: marginScale(context, 5)),
                                    decoration: BoxDecoration(
                                        color: bgPrimaryColor,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Text(
                                      products[0].catName ?? '',
                                      textScaleFactor: textScale(context),
                                      style: headLine7.copyWith(
                                          color: primary_color, fontSize: 10),
                                    )),
                                SizedBox(
                                  width: marginScale(context, 15),
                                ),
                                Icon(
                                  Icons.star,
                                  size: 20,
                                  color: colorStar,
                                ),
                                if (products[0].rating == null)
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: marginScale(context, 5),
                                        left: marginScale(context, 6)),
                                    child: Text(
                                      startCountFormat(
                                          products[0].rating ?? '1'),
                                      textScaleFactor: textScale(context),
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                  ),
                                if (products[0].ratingCount != null)
                                  Text(
                                    "(${products[0].ratingCount} оценок)",
                                    textScaleFactor: textScale(context),
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: marginScale(context, 20)),
                        width: MediaQuery.of(context).size.width,
                        child: widget.isOffline
                            ? infoProduct(
                                '${products[0].orderCount}',
                                'Участников',
                                'assets/img/people.svg',
                                widget.isOffline)
                            : Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (widget.lessonCount != null)
                                    infoProduct(widget.lessonCount.toString(),
                                        'Уроков', 'assets/img/sort.svg'),
                                  if (   products[0].orderCount != null  )
                                    Row(
                                      children: [
                                        Container(
                                          width: 1,
                                          height: marginScale(context, 45),
                                          color: Theme.of(context).dividerColor,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  marginScale(context, 20)),
                                          child: 

                                              infoProduct('${products[0].orderCount}',
                                        'Резидентов', 'assets/img/people.svg'),


                                        ),
                                        Container(
                                          width: 1,
                                          height: marginScale(context, 45),
                                          color: Theme.of(context).dividerColor,
                                        )
                                      ],
                                    ),
                                  if (widget.durationLesson != null)
                                    infoProduct(
                                              '${(double.parse(widget.durationLesson ?? '0') / 60).toStringAsFixed(1)}',
                                              'Часов',
                                              'assets/img/clock.svg'),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: marginScale(context, 50),
                    top: 5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container infoProduct(String text, String infoText, String img,
      [bool isOffline = false]) {
    return Container(
      child: isOffline
          ? Row(
              children: [
                Row(
                  children: [
                    SvgPicture.asset(img),
                    SizedBox(
                      width: marginScale(context, 6),
                    ),
                    Text(
                      text,
                      textScaleFactor: textScale(context),
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ],
                ),
                SizedBox(
                  width: marginScale(context, 13),
                ),
                Text(
                  infoText,
                  style: Theme.of(context).textTheme.headline4,
                  textScaleFactor: textScale(context),
                ),
              ],
            )
          : Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset(img),
                    SizedBox(
                      width: marginScale(context, 6),
                    ),
                    Text(
                      text,
                      textScaleFactor: textScale(context),
                      style: headLine5Med,
                    ),
                  ],
                ),
                SizedBox(
                  height: marginScale(context, 13),
                ),
                Text(
                  infoText,
                  style: headLine4Reg,
                  textScaleFactor: textScale(context),
                ),
              ],
            ),
    );
  }
}

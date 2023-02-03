import 'package:barber/api/Favorite/favoriteApi.dart';
import 'package:barber/provider/favoriteData.dart';
import 'package:barber/provider/globalData.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:barber/res/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

class Tile extends StatefulWidget {
  Tile(
      {Key? key,
      required this.text,
      required this.img,
      required this.id,
      required this.price,
      this.cat = '3D Дизайн',
      this.starCount = '4.3',
      this.lessonCount,
      this.starFeedback,
      this.hour = '200',
      this.isFav = false,
      this.isShowFav = true})
      : super(key: key);

  final String text;
  String img;
  String id;
  final String price;
  String? cat;
  bool isFav;
  bool isShowFav;
  final String starCount;
  String? starFeedback;
  String? lessonCount;
  String? hour;

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> {
  bool isLoadLike = false;

  @override
  Widget build(BuildContext context) {
    bool isLikeId = context.read<FavoriteData>().checkFavoriteCard(widget.id);
    Radius containerRadius = Radius.circular(20);
    return Container(
      padding: EdgeInsets.only(left: marginScale(context, 10)),
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: HexColor('#04060F').withOpacity(0.04),
              offset: Offset(0, 0.8),
              blurRadius: 60),
        ],
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.only(
            topLeft: containerRadius,
            bottomLeft: containerRadius,
            topRight: widget.isFav ? Radius.circular(0) : containerRadius,
            bottomRight: widget.isFav ? Radius.circular(0) : containerRadius),
      ),
      height: marginScale(context, 120),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: marginScale(context, 9),
                  right: marginScale(context, 12)),
              width: marginScale(context, 100),
              height: marginScale(context, 100),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.all(Radius.circular(marginScale(context, 20))),
                child: CachedNetworkImage(
                  imageUrl: widget.img,
                  imageBuilder: (context, imageProvider) => Image(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                  placeholder: (context, url) => Center(
                      child: Container(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator())),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(top: marginScale(context, 9)),
                width: marginScale(context, 100),
                height: marginScale(context, 100),
                padding: EdgeInsets.symmetric(vertical: marginScaleWC(0))
                    .copyWith(right: marginScaleWC(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          widget.cat != null
                              ? Container(
                                  constraints: BoxConstraints(
                                      maxWidth: marginScale(context, 112)),
                                  child: itemCatName(context, widget.cat))
                              : SizedBox(),
                          if (widget.isShowFav)
                            Container(
                              width: marginScale(context, 20),
                              height: marginScale(context, 20),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size(marginScale(context, 20),
                                      marginScale(context, 20)),
                                ),
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
                                child: SvgPicture.asset(
                                  isLikeId
                                      ? 'assets/img/activeFav.svg'
                                      : 'assets/img/favIcon.svg',
                                  width: marginScale(context, 20),
                                  height: marginScale(context, 20),
                                  fit: BoxFit.fill,
                                  // height: 15,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            bottom: marginScale(context, 10),
                            right: marginScale(context, 10)),
                        child: Container(
                            // height: 20,
                            child: Text(widget.text,
                                maxLines: 2,
                                style:
                                    Theme.of(context).textTheme.headline4!))),
                    // Padding(
                    //   padding: EdgeInsets.only(bottom: marginScale(context, 7)),
                    //   child: Text(
                    //     '₸${MoneyFormat.get(widget.price)}',
                    //     textScaleFactor: textScale(context),
                    //     style: TextStyle(
                    //         color: primary_color,
                    //         fontSize: 14,
                    //         fontWeight: FontWeight.w600),
                    //   ),
                    // ),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/img/star.svg',
                                width: marginScale(context, 11.37),
                                height: marginScale(context, 10.9),
                              ),
                              SizedBox(
                                width: marginScale(context, 6),
                              ),
                              Text(
                                widget.starCount,
                                textScaleFactor: textScale(context),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(color: HexColor('#E9A424')),
                              )
                            ],
                          ),
                          SizedBox(
                            width: marginScale(context, 5),
                          ),
                          Text(
                            '(${widget.starFeedback ?? ''})',
                            textScaleFactor: textScale(context),
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: greyColor),
                          ),
                          horLine(context),
                          Padding(
                            padding:
                                EdgeInsets.only(right: marginScale(context, 4)),
                            child: SvgPicture.asset(
                              'assets/img/play.svg',
                              width: marginScale(context, 11.67),
                              height: marginScale(context, 11.67),
                            ),
                          ),
                          Text(
                            widget.lessonCount ?? '',
                            textScaleFactor: textScale(context),
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: greyColor),
                          ),
                          horLine(context, true),
                          Padding(
                            padding:
                                EdgeInsets.only(right: marginScale(context, 6)),
                            child: SvgPicture.asset(
                              'assets/img/watch.svg',
                              width: marginScale(context, 11.67),
                              height: marginScale(context, 11.67),
                            ),
                          ),
                          Text(
                            widget.hour ?? '' + 'ч',
                            textScaleFactor: textScale(context),
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: greyColor),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding horLine(BuildContext context, [bool isLeftBig = false]) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: marginScaleWC(isLeftBig ? 10 : 5))
              .copyWith(right: marginScaleWC(isLeftBig ? 5 : 11)),
      child: Text(
        ' | ',
        textScaleFactor: textScale(context),
        style: Theme.of(context).textTheme.headline6!.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 10,
            color: greys.withOpacity(0.6)),
      ),
    );
  }
}

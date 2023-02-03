import 'package:barber/api/Favorite/favoriteApi.dart';
import 'package:barber/api/home/Ihome.dart';
import 'package:barber/pages/list/tiles_product.dart';
import 'package:barber/pages/product_page/product_appbar.dart';
import 'package:barber/provider/favoriteData.dart';
import 'package:barber/provider/globalData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class ListItem extends StatefulWidget {
  List<Products> productsProps;
  bool isSlidable;
  Function? checkProductsParent;

  ListItem(
      {Key? key,
      this.productsProps = const [],
      this.isSlidable = true,
      this.checkProductsParent})
      : super(key: key);

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (widget.productsProps.isNotEmpty)
            ...widget.productsProps.asMap().entries.map((e) => Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductAppBar(
                                    img: e.value.avatar ?? '',
                                    name: e.value.name ?? '',
                                    price: e.value.price ?? '',
                                    id: e.value.id ?? '0',
                                  )));
                    },
                    child: slidableWid(valKey: e.key, item: e.value),
                  ),
                ))
        ],
      ),
    );
  }

  slidableWid({required int valKey, required Products item}) {
    // if(item != null) {
    //   isLikeId = ;
    // }

    delProduct() async {
      var login = context.read<GlobalData>().loginToken;
      if (login == null) {
        return;
      }

      await delFavoriteCard(login, item.id!);

      context.read<FavoriteData>().putFavoriteCard(item.id);

      if (widget.productsProps != null) {
        setState(() {
          widget.productsProps.removeAt(valKey);
        });
        if (widget.checkProductsParent != null) {
          widget.checkProductsParent!(widget.productsProps);
        }
      }
    }

    if (widget.isSlidable == false) {
      return Tile(
        text: item.name ?? '',
        img: item.file ?? '',
        price: item.price ?? '',
        cat: item.catName ?? '',
        id: item.id ?? '',
        starCount: '${(double.parse(item.rating ?? '0')).toStringAsFixed(1)}',
        starFeedback: item.ratingCount,
        lessonCount: item.lessonsCount,
        hour:
            '${(double.parse(item.lessonsDuration ?? '0') / 60).toStringAsFixed(1)}ч',
      );
    } else {
      return Slidable(
          key: UniqueKey(),
          endActionPane: ActionPane(
            extentRatio: 1 / 3,
            dismissible: DismissiblePane(onDismissed: () async {
              await delProduct();
            }),
            motion: ScrollMotion(),
            children: [
              SlidableAction(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                onPressed: (value) async {
                  await delProduct();
                },
                backgroundColor: Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                
              ),
            ],
          ),
          child: Tile(
            text: item.name ?? '',
            img: item.file ?? '',
            price: item.price ?? '',
            cat: item.catName ?? '',
            id: item.id ?? '',
            isShowFav: false,
            starCount:
                '${(double.parse(item.rating ?? '0')).toStringAsFixed(1)}',
            starFeedback: item.ratingCount,
            lessonCount: item.lessonsCount,
            hour:
                '${(double.parse(item.lessonsDuration ?? '0') / 60).toStringAsFixed(1)}ч',
          ));
    }
  }
}

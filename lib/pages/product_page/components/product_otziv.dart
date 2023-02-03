import 'package:barber/api/Comments/IComments.dart';
import 'package:barber/api/Comments/commentsApi.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:barber/res/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ProductOtziv extends StatefulWidget {
  String id;
  bool isOffline;
  bool isBought;
  String? productId;
  List<IComments>? initData;

  ProductOtziv(
      {Key? key,
      required this.id,
      required this.isOffline,
      this.productId,
      this.initData,
      required this.isBought})
      : super(key: key);

  @override
  State<ProductOtziv> createState() => _ProductOtzivState();
}

class _ProductOtzivState extends State<ProductOtziv> {
  List<Comments> comments = [];

  int totalPage = 1;
  int curPage = 1;

  bool isLoad = false;

  getData({String page = '0', String searchKey = ''}) async {
    setState(() {
      isLoad = true;
    });
    List<IComments>? data = await getComments(id: widget.id, page: page);

    curPage = int.parse(page);

    if (data != null && data.isNotEmpty) {
      if (page == '0') {
        comments = data[0].comments ?? [];
      } else {
        comments.addAll(data[0].comments ?? []);
      }
      totalPage = data[0].count ?? 0;
    }

    isLoad = false;
    if (mounted) setState(() {});
  }

  initData() async {
    if (widget.initData == null) {
      return;
    }
    if (widget.initData!.isEmpty) {
      return;
    }

    comments = widget.initData?[0].comments ?? [];
    totalPage = widget.initData?[0].count ?? 0;
    isLoad = false;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: marginScale(context, 15)),
      child: Column(
        children: [
          ...comments.map((e) {
            return comment(context, e);
          }),
          SizedBox(
            height: marginScale(context, 20),
          ),
          if (totalPage > 1) btnMore(context, getData, curPage),

          // ! offline feedback
          if (widget.isBought && widget.isOffline && widget.productId != null)
            SizedBox(
              height: marginScale(context, 20),
            ),
          if (widget.isBought && widget.isOffline && widget.productId != null)
            ElevatedButton(
                onPressed: () async {
                  await showFeedBackWindow(context,
                      productId: widget.productId!);
                },
                child: Text('Оставить отзыв'))
        ],
      ),
    );
  }

  Padding comment(BuildContext context, Comments item) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: greys,
                      minRadius: marginScale(context, 22),
                      backgroundImage: NetworkImage(item.avatar ?? ''),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: marginScale(context, 12)),
                      child: Text(
                        (item.name ?? '') + ' ' + (item.surname ?? ''),
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: marginScale(context, 8),
                          vertical: marginScale(context, 3)),
                      decoration: BoxDecoration(
                          border: Border.all(color: primary_color, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 15,
                            color: primary_color,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: marginScale(context, 5)),
                            child: Text(
                              item.rating ?? '5',
                              textScaleFactor: textScale(context),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(fontSize: 12),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: marginScale(context, 10)),
              child: Text(
                item.text ?? '',
                textScaleFactor: textScale(context),
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            SizedBox(
              height: marginScale(context, 10),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    item.date!.substring(0, 10),
                    textScaleFactor: textScale(context),
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.grey, fontSize: 12),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

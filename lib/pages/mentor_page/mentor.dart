import 'package:barber/api/Mentors/IMentorId.dart';
import 'package:barber/api/Mentors/mentorsApi.dart';
import 'package:barber/api/Product/productApi.dart';
import 'package:barber/api/home/Ihome.dart';
import 'package:barber/pages/list/lists.dart';
import 'package:barber/pages/mentor_page/component/mentor_appbar.dart';
import 'package:barber/pages/product_page/components/product_otziv.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:barber/res/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readmore/readmore.dart';

class Mentor extends StatefulWidget {
  String id;

  Mentor({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<Mentor> createState() => _MentorState();
}

class _MentorState extends State<Mentor> with TickerProviderStateMixin {
  late TabController _mentorTabController;

  IMentorId? mentorId;
  List<Products> products = [];
  bool isLoad = true;
  bool courseisnotEmpty = true;

  getData() async {
    setState(() {
      isLoad = true;
    });
    var data = await getMentorId(id: widget.id);
    List<IHome>? dataProduct = await getMentorProducts(widget.id);
    if (dataProduct != null && dataProduct.isNotEmpty) {
      products = dataProduct[0].products ?? [];
      courseisnotEmpty = false;
    }
    mentorId = data[0];

    isLoad = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    TabController _mentorTabController = TabController(length: 3, vsync: this);
    getData();
  }

  TabBar get _mentorTabBar => TabBar(
        tabs: [
          Tab(text: 'О эксперте'),
          Tab(text: 'Курсы'),
          // Tab(text: 'Отзывы')
        ],
        unselectedLabelColor: greyColor,
        unselectedLabelStyle: headLine4Reg,
        
        labelColor: primary_color,
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
    if (mentorId == null) return Text('noDAta');
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                actions: [
                  // IconButton(
                  //     onPressed: () {},
                  //     icon: SvgPicture.asset('assets/img/circle_menu.svg'))
                ],
                leading: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: SvgPicture.asset('assets/img/arrowBack.svg')),
                  ],
                ),
                pinned: true,
                floating: true,
                backgroundColor: Theme.of(context).canvasColor,
                expandedHeight: marginScale(context, 330),
                flexibleSpace: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top +
                          marginScale(context, 20)),
                  child: MentorsAppBar(
                    mentorId: mentorId!,
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: _mentorTabBar.preferredSize,
                  child: ColoredBox(
                      color: Theme.of(context).canvasColor,
                      child: _mentorTabBar),
                ),
              )
            ];
          },
          body: TabBarView(children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 20, bottom: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Немного о себе',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ReadMoreText(mentorId?.about ?? '',
                          textScaleFactor: textScale(context),
                          trimCollapsedText: ' Развернуть',
                          trimExpandedText: 'Свернуть',
                          colorClickableText: primary_color,
                          trimLines: 5,
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(
                                  color: HexColor('#808080'),
                                  fontWeight: FontWeight.w400)),
                    )
                  ],
                ),
              ),
            ),
            !courseisnotEmpty
                ? ListItem(
                    productsProps: products,
                    isSlidable: false,
                  )
                : SizedBox(),
            // products.isNotEmpty
            //     ? ProductOtziv(
            //         id: products[0].id ?? '0',
            //         isBought: false,
            //         isOffline: true,
            //       )
            //     : SizedBox()
          ]),
        ),
      ),
    );
  }
}
